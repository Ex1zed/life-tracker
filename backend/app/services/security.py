from datetime import UTC, datetime, timedelta

import jwt

from app.config import get_settings

ALGORITHM = "HS256"

# Long-lived for the MVP: the phone keeps the token, no refresh tokens yet.
ACCESS_TOKEN_TTL = timedelta(days=30)


class InvalidToken(Exception):
    """The token is malformed, has a bad signature, or has expired."""


def create_access_token(user_id: str) -> str:
    """Signed JWT whose "sub" (subject) is the user id."""
    now = datetime.now(UTC)
    payload = {"sub": user_id, "iat": now, "exp": now + ACCESS_TOKEN_TTL}
    return jwt.encode(payload, get_settings().secret_key, algorithm=ALGORITHM)


def decode_access_token(token: str) -> str:
    """Returns the user id from a valid token, otherwise raises InvalidToken."""
    try:
        payload = jwt.decode(
            token,
            get_settings().secret_key,
            algorithms=[ALGORITHM],  # never trust the algorithm from the token itself
            options={"require": ["sub", "exp"]},
        )
    except jwt.InvalidTokenError:
        raise InvalidToken from None
    return payload["sub"]