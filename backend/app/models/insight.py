import datetime as dt
from enum import StrEnum

from sqlalchemy import Enum, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base
from app.models.common import UtcDateTime, new_uuid, utc_now


class InsightKind(StrEnum):
    STATS = "stats"
    LLM = "llm"


class Insight(Base):
    """Generated on the server; the phone reads it via GET /insights, not sync."""

    __tablename__ = "insights"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=new_uuid)
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    period_start: Mapped[dt.date] = mapped_column()
    period_end: Mapped[dt.date] = mapped_column()
    kind: Mapped[InsightKind] = mapped_column(
        Enum(InsightKind, values_callable=lambda e: [m.value for m in e])
    )
    title: Mapped[str] = mapped_column(String(255))
    body: Mapped[str] = mapped_column(Text)
    created_at: Mapped[dt.datetime] = mapped_column(UtcDateTime, default=utc_now)