from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base
from app.models.common import UtcDateTime, new_uuid, utc_now

if TYPE_CHECKING:
    from app.models.auth import AuthIdentity


class User(Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_uuid)
    # Nullable: Apple may not share an email. MySQL allows many NULLs in a unique column.
    email: Mapped[str | None] = mapped_column(String(255), unique=True)
    created_at: Mapped[datetime] = mapped_column(UtcDateTime, default=utc_now)

    identities: Mapped[list["AuthIdentity"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )