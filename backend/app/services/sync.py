from dataclasses import dataclass
from datetime import UTC, datetime

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import DailyCheckin
from app.schemas.sync import CheckinIn


@dataclass
class PushResult:
    applied: int = 0
    skipped: int = 0


def to_db_time(value: datetime | None) -> datetime | None:
    """Timezone-aware time from the API -> naive UTC, as we store it in MySQL."""
    if value is None:
        return None
    return value.astimezone(UTC).replace(tzinfo=None)


def push_checkins(db: Session, user_id: str, items: list[CheckinIn]) -> PushResult:
    """Saves check-ins from a device. One check-in per date; the latest change wins."""
    result = PushResult()

    for item in items:
        updated_at = to_db_time(item.updated_at)
        # A check-in is identified by (user, date), not by id: two devices can
        # create a check-in for the same day offline, each with its own UUID.
        existing = db.scalar(
            select(DailyCheckin).where(
                DailyCheckin.user_id == user_id,
                DailyCheckin.date == item.date,
            )
        )

        if existing is None:
            if db.get(DailyCheckin, item.id) is not None:
                # This id already belongs to another user's row: never touch it.
                result.skipped += 1
                continue
            db.add(
                DailyCheckin(
                    id=item.id,
                    user_id=user_id,
                    date=item.date,
                    mood=item.mood,
                    energy=item.energy,
                    productivity=item.productivity,
                    note=item.note,
                    created_at=to_db_time(item.created_at),
                    updated_at=updated_at,
                    deleted_at=to_db_time(item.deleted_at),
                )
            )
            # Write now, so a second item with the same date in this batch finds it.
            db.flush()
            result.applied += 1
        elif updated_at > existing.updated_at:
            existing.mood = item.mood
            existing.energy = item.energy
            existing.productivity = item.productivity
            existing.note = item.note
            existing.updated_at = updated_at
            existing.deleted_at = to_db_time(item.deleted_at)
            result.applied += 1
        else:
            # The server already has this change or a newer one.
            result.skipped += 1

    db.commit()
    return result