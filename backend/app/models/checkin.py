import datetime as dt

from sqlalchemy import CheckConstraint, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base
from app.models.common import SyncMixin


class DailyCheckin(SyncMixin, Base):
    __tablename__ = "daily_checkins"
    __table_args__ = (
        UniqueConstraint("user_id", "date"),
        CheckConstraint("mood BETWEEN 1 AND 10", name="mood_range"),
        CheckConstraint("energy BETWEEN 1 AND 10", name="energy_range"),
        CheckConstraint("productivity BETWEEN 1 AND 10", name="productivity_range"),
    )

    # Local calendar date in the user's timezone, not UTC.
    date: Mapped[dt.date] = mapped_column()
    mood: Mapped[int] = mapped_column()
    energy: Mapped[int] = mapped_column()
    productivity: Mapped[int] = mapped_column()
    note: Mapped[str | None] = mapped_column(Text)