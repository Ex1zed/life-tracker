from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import CurrentUser
from app.schemas.sync import SyncPushRequest, SyncPushResult
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