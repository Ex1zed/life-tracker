from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.db import get_db
from app.models import User
from app.services.security import InvalidToken, decode_access_token

# auto_error=False: we return our own 401 instead of FastAPI's default error.
bearer_scheme = HTTPBearer(auto_error=False)


def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer_scheme)],
    db: Annotated[Session, Depends(get_db)],
) -> User:
    """Resolves the signed-in user from the 'Authorization: Bearer' header."""
    unauthorized = HTTPException(
        status.HTTP_401_UNAUTHORIZED,
        detail="Not authenticated",
        headers={"WWW-Authenticate": "Bearer"},
    )
    if credentials is None:
        raise unauthorized
    try:
        user_id = decode_access_token(credentials.credentials)
    except InvalidToken:
        raise unauthorized from None

    user = db.get(User, user_id)  # lookup by primary key
    if user is None:  # valid token, but the user was deleted
        raise unauthorized
    return user


# Use in any endpoint: def endpoint(user: CurrentUser): ...
CurrentUser = Annotated[User, Depends(get_current_user)]