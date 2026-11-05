import uuid
from datetime import UTC, datetime

from sqlalchemy import DateTime
from sqlalchemy.dialects import mysql

# MySQL DATETIME has no timezone, so we always store naive UTC.
# fsp=6 keeps microseconds: sync compares updated_at, seconds are too coarse.
UtcDateTime = DateTime().with_variant(mysql.DATETIME(fsp=6), "mysql")


def utc_now() -> datetime:
    """Current UTC time without tzinfo, ready to be stored in MySQL."""
    return datetime.now(UTC).replace(tzinfo=None)


def new_uuid() -> str:
    """Random UUID as a string, the same format the phone generates."""
    return str(uuid.uuid4())