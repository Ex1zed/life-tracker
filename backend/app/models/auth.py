from datetime import datetime
from enum import StrEnum
from typing import TYPE_CHECKING

from sqlalchemy import Enum, ForeignKey, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base
from app.models.common import UtcDateTime, new_uuid, utc_now

if TYPE_CHECKING:
    from app.models.user import User


class AuthProvider(StrEnum):
    EMAIL = "email"
    GOOGLE = "google"
    APPLE = "apple"


class AuthIdentity(Base):
    """One way a user can sign in. A user may have several."""

    __tablename__ = "auth_identities"
    __table_args__ = (UniqueConstraint("provider", "subject"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_uuid)
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    # values_callable: store "email", not the member name "EMAIL".
    provider: Mapped[AuthProvider] = mapped_column(
        Enum(AuthProvider, values_callable=lambda e: [m.value for m in e])
    )
    # Email address for EMAIL, the "sub" claim for GOOGLE and APPLE.
    subject: Mapped[str] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(UtcDateTime, default=utc_now)

    user: Mapped["User"] = relationship(back_populates="identities")


class AuthCode(Base):
    """One-time sign-in code sent by email. Server-only, never synced."""

    __tablename__ = "auth_codes"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_uuid)
    email: Mapped[str] = mapped_column(String(255), index=True)
    code_hash: Mapped[str] = mapped_column(String(255))
    expires_at: Mapped[datetime] = mapped_column(UtcDateTime)
    attempts: Mapped[int] = mapped_column(default=0)
    created_at: Mapped[datetime] = mapped_column(UtcDateTime, default=utc_now)