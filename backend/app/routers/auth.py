from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db import get_db
from app.schemas.auth import EmailCodeRequest, MessageResponse
from app.services import auth as auth_service

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/email/request",
    response_model=MessageResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def request_email_code(
    body: EmailCodeRequest,
    db: Annotated[Session, Depends(get_db)],
) -> MessageResponse:
    """Send a 6-digit sign-in code to the given email."""
    try:
        auth_service.request_login_code(db, body.email)
    except auth_service.CodeRequestTooSoon:
        raise HTTPException(
            status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Wait a minute before requesting a new code",
        ) from None
    return MessageResponse(detail="Code sent")