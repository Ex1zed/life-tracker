# Import every model here so Base.metadata knows all tables (Alembic needs this).
from app.models.auth import AuthCode, AuthIdentity, AuthProvider
from app.models.user import User

__all__ = ["AuthCode", "AuthIdentity", "AuthProvider", "User"]