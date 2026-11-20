from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class UserOut(BaseModel):
    # from_attributes: build the schema straight from a SQLAlchemy object.
    model_config = ConfigDict(from_attributes=True)

    id: str = Field(description="User id (UUID)")
    email: str | None = Field(description="User email, if known")
    created_at: datetime = Field(description="When the account was created, UTC")