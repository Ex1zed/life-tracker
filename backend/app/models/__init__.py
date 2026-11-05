# Import every model here so Base.metadata knows all tables (Alembic needs this).
from app.models.auth import AuthCode, AuthIdentity, AuthProvider
from app.models.checkin import DailyCheckin
from app.models.insight import Insight, InsightKind
from app.models.settings import UserSettings
from app.models.sleep import SleepEntry, SleepSource
from app.models.user import User

__all__ = [
    "AuthCode",
    "AuthIdentity",
    "AuthProvider",
    "DailyCheckin",
    "Insight",
    "InsightKind",
    "SleepEntry",
    "SleepSource",
    "User",
    "UserSettings",
]