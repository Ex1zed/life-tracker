import hashlib
import hmac
import secrets
from datetime import timedelta

from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.config import get_settings
from app.models import AuthCode
from app.models.common import utc_now
from app.services.email import send_login_code

CODE_TTL = timedelta(minutes=10)
RESEND_INTERVAL = timedelta(minutes=1)


class CodeRequestTooSoon(Exception):
    """A new code was requested less than RESEND_INTERVAL after the last one."""


def normalize_email(email: str) -> str:
    return email.strip().lower()


def hash_code(code: str) -> str:
    """HMAC with the server secret: a leaked table alone can't be brute-forced."""
    key = get_settings().secret_key.encode()
    return hmac.new(key, code.encode(), hashlib.sha256).hexdigest()


def request_login_code(db: Session, email: str) -> None:
    """Creates a fresh 6-digit code for the email and sends it."""
    email = normalize_email(email)
    now = utc_now()

    last = db.scalar(
        select(AuthCode)
        .where(AuthCode.email == email)
        .order_by(AuthCode.created_at.desc())
        .limit(1)
    )
    if last is not None and now - last.created_at < RESEND_INTERVAL:
        raise CodeRequestTooSoon

    code = f"{secrets.randbelow(1_000_000):06d}"

    # One active code per email: the new one replaces any previous ones.
    db.execute(delete(AuthCode).where(AuthCode.email == email))
    db.add(
        AuthCode(
            email=email,
            code_hash=hash_code(code),
            expires_at=now + CODE_TTL,
            created_at=now,
        )
    )
    db.commit()

    send_login_code(email, code)