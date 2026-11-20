from pydantic import BaseModel, EmailStr, Field


class EmailCodeRequest(BaseModel):
    email: EmailStr = Field(description="Email to send the sign-in code to")


class MessageResponse(BaseModel):
    detail: str = Field(description="Human-readable result message")