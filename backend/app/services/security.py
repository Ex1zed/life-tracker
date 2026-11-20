from datetime import UTC, datetime, timedelta

import jwt

from app.config import get_settings

ALGORITHM = "HS256"

# Long-lived for the MVP: the phone keeps the token, no refresh tokens yet.
ACCESS_TOKEN_TTL = timedelta(days=30)


def create_access_token(user_id: str) -> str:
    """Signed JWT whose "sub" (subject) is the user id."""
    now = datetime.now(UTC)
    payload = {"sub": user_id, "iat": now, "exp": now + ACCESS_TOKEN_TTL}
    return jwt.encode(payload, get_settings().secret_key, algorithm=ALGORITHM)