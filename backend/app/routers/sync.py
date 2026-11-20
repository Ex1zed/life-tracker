from typing import Annotated

from fastapi import APIRouter, Depends, Query
from pydantic import AwareDatetime
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import CurrentUser
from app.schemas.sync import CheckinOut, SyncPullResult, SyncPushRequest, SyncPushResult
from app.services import sync as sync_service

router = APIRouter(prefix="/sync", tags=["sync"])


@router.post("/push", response_model=SyncPushResult)
def push(
    body: SyncPushRequest,
    user: CurrentUser,
    db: Annotated[Session, Depends(get_db)],
) -> SyncPushResult:
    """Upload records changed on the device. The latest change wins."""
    result = sync_service.push_checkins(db, user.id, body.checkins)
    return SyncPushResult(applied=result.applied, skipped=result.skipped)


@router.get("/pull", response_model=SyncPullResult)
def pull(
    user: CurrentUser,
    db: Annotated[Session, Depends(get_db)],
    since: Annotated[
        AwareDatetime | None,
        Query(description="Cursor from the previous pull; omit to get everything"),
    ] = None,
) -> SyncPullResult:
    """Download records changed on the server after `since`."""
    result = sync_service.pull_checkins(db, user.id, since)
    return SyncPullResult(
        checkins=[
            CheckinOut(
                id=row.id,
                date=row.date,
                mood=row.mood,
                energy=row.energy,
                productivity=row.productivity,
                note=row.note,
                created_at=sync_service.from_db_time(row.created_at),
                updated_at=sync_service.from_db_time(row.updated_at),
                deleted_at=sync_service.from_db_time(row.deleted_at),
            )
            for row in result.checkins
        ],
        cursor=sync_service.from_db_time(result.cursor),
        has_more=result.has_more,
    )