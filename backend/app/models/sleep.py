from datetime import datetime
from enum import StrEnum

from sqlalchemy import CheckConstraint, Enum, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base
from app.models.common import SyncMixin, UtcDateTime


class SleepSource(StrEnum):
    HEALTH = "health"
    MANUAL = "manual"


class SleepEntry(SyncMixin, Base):
    __tablename__ = "sleep_entries"
    __table_args__ = (
        CheckConstraint("quality BETWEEN 1 AND 10", name="quality_range"),
        CheckConstraint("sleep_end > sleep_start", name="end_after_start"),
    )

    sleep_start: Mapped[datetime] = mapped_column(UtcDateTime)
    sleep_end: Mapped[datetime] = mapped_column(UtcDateTime)
    source: Mapped[SleepSource] = mapped_column(
        Enum(SleepSource, values_callable=lambda e: [m.value for m in e])
    )
    # Nullable: Health data arrives at night, the rating comes in the morning.
    quality: Mapped[int | None] = mapped_column()
    note: Mapped[str | None] = mapped_column(Text)