import hashlib
import hmac
import secrets
from datetime import timedelta

from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.config import get_settings
from app.models import AuthCode, AuthIdentity, AuthProvider, User
from app.models.common import utc_now
from app.services.email import send_login_code
from app.services.security import create_access_token

CODE_TTL = timedelta(minutes=10)
RESEND_INTERVAL = timedelta(minutes=1)
MAX_ATTEMPTS = 5


class CodeRequestTooSoon(Exception):
    """A new code was requested less than RESEND_INTERVAL after the last one."""


class InvalidCode(Exception):
    """The code is wrong, expired, or was never requested."""


class TooManyAttempts(Exception):
    """MAX_ATTEMPTS wrong codes were entered; a new code must be requested."""


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


def sign_in_with_code(db: Session, email: str, code: str) -> str:
    """Checks the code, creates the user on first sign-in, returns an access token."""
    email = normalize_email(email)

    auth_code = db.scalar(select(AuthCode).where(AuthCode.email == email))
    if auth_code is None or auth_code.expires_at < utc_now():
        raise InvalidCode
    if auth_code.attempts >= MAX_ATTEMPTS:
        raise TooManyAttempts

    # compare_digest takes the same time for any input: no timing hints.
    if not hmac.compare_digest(auth_code.code_hash, hash_code(code)):
        auth_code.attempts += 1
        db.commit()
        raise InvalidCode

    db.delete(auth_code)  # a code works only once
    user = _get_or_create_email_user(db, email)
    db.commit()  # code deletion and user creation are saved together
    return create_access_token(user.id)


def _get_or_create_email_user(db: Session, email: str) -> User:
    identity = db.scalar(
        select(AuthIdentity).where(
            AuthIdentity.provider == AuthProvider.EMAIL,
            AuthIdentity.subject == email,
        )
    )
    if identity is not None:
        return identity.user

    # The email is verified by the code, so it's safe to attach this sign-in
    # method to an existing user with the same email (e.g. from Google later).
    user = db.scalar(select(User).where(User.email == email))
    if user is None:
        user = User(email=email)
        db.add(user)

    db.add(AuthIdentity(user=user, provider=AuthProvider.EMAIL, subject=email))
    db.flush()  # assigns user.id before we build the token
    return user