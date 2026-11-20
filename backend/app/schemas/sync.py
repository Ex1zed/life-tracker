import datetime as dt

from pydantic import AwareDatetime, BaseModel, Field


class CheckinIn(BaseModel):
    """A daily check-in as the device sends it."""

    id: str = Field(min_length=36, max_length=36, description="UUID generated on the device")
    date: dt.date = Field(description="Local calendar date of the check-in")
    mood: int = Field(ge=1, le=10, description="Mood, 1-10")
    energy: int = Field(ge=1, le=10, description="Energy, 1-10")
    productivity: int = Field(ge=1, le=10, description="Productivity, 1-10")
    note: str | None = Field(default=None, max_length=5000, description="Optional note")
    created_at: AwareDatetime = Field(description="When created on the device (with timezone)")
    updated_at: AwareDatetime = Field(description="Last change on the device; latest wins")
    deleted_at: AwareDatetime | None = Field(default=None, description="Set if deleted")


class CheckinOut(BaseModel):
    """A daily check-in as the server returns it. Times are UTC."""

    id: str = Field(description="Server id of the check-in")
    date: dt.date = Field(description="Local calendar date of the check-in")
    mood: int = Field(description="Mood, 1-10")
    energy: int = Field(description="Energy, 1-10")
    productivity: int = Field(description="Productivity, 1-10")
    note: str | None = Field(description="Optional note")
    created_at: AwareDatetime = Field(description="When created, UTC")
    updated_at: AwareDatetime = Field(description="Last change, UTC")
    deleted_at: AwareDatetime | None = Field(description="Set if deleted, UTC")


class SyncPushRequest(BaseModel):
    checkins: list[CheckinIn] = Field(
        default_factory=list, max_length=500, description="Changed check-ins"
    )


class SyncPushResult(BaseModel):
    applied: int = Field(description="Records saved on the server")
    skipped: int = Field(description="Records ignored: the server already has a newer version")


class SyncPullResult(BaseModel):
    checkins: list[CheckinOut] = Field(description="Check-ins changed after `since`")
    cursor: AwareDatetime | None = Field(
        description="Send as `since` next time; null if there is nothing yet"
    )
    has_more: bool = Field(description="True if there are more changes: pull again with the cursor")