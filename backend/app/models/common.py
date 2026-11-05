import uuid
from datetime import UTC, datetime

from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy.dialects import mysql
from sqlalchemy.orm import Mapped, mapped_column

# MySQL DATETIME has no timezone, so we always store naive UTC.
# fsp=6 keeps microseconds: sync compares updated_at, seconds are too coarse.
UtcDateTime = DateTime().with_variant(mysql.DATETIME(fsp=6), "mysql")


def utc_now() -> datetime:
    """Current UTC time without tzinfo, ready to be stored in MySQL."""
    return datetime.now(UTC).replace(tzinfo=None)


def new_uuid() -> str:
    """Random UUID as a string, the same format the phone generates."""
    return str(uuid.uuid4())


class SyncMixin:
    """Common columns of tables synced between the phone and the server."""

    # Generated on the phone, so the same row has the same id everywhere.
    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_uuid)
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    created_at: Mapped[datetime] = mapped_column(UtcDateTime, default=utc_now)
    # Set by the device that made the change; used to resolve conflicts.
    updated_at: Mapped[datetime] = mapped_column(UtcDateTime, default=utc_now)
    # Soft delete: deletions are synced like any other change.
    deleted_at: Mapped[datetime | None] = mapped_column(UtcDateTime)
    # Server clock time of the last write; /sync/pull filters by it. Server-only.
    server_updated_at: Mapped[datetime] = mapped_column(
        UtcDateTime, default=utc_now, onupdate=utc_now, index=True
    )