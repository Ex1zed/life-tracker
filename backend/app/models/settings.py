import datetime as dt

from sqlalchemy import String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base
from app.models.common import SyncMixin


class UserSettings(SyncMixin, Base):
    """One row per user. Times of day are local wall-clock times in `timezone`."""

    __tablename__ = "settings"
    __table_args__ = (UniqueConstraint("user_id"),)

    # IANA timezone name, e.g. "Asia/Krasnoyarsk".
    timezone: Mapped[str] = mapped_column(String(64), default="UTC")
    sleep_goal_minutes: Mapped[int] = mapped_column(default=480)
    bedtime: Mapped[dt.time] = mapped_column(default=dt.time(23, 0))
    wind_down_minutes: Mapped[int] = mapped_column(default=120)
    # None means the reminder is turned off.
    morning_reminder: Mapped[dt.time | None] = mapped_column(default=dt.time(9, 0))
    evening_reminder: Mapped[dt.time | None] = mapped_column(default=dt.time(21, 0))
    share_notes_with_ai: Mapped[bool] = mapped_column(default=False)