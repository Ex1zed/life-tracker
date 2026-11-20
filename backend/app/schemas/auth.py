from pydantic import BaseModel, EmailStr, Field


class EmailCodeRequest(BaseModel):
    email: EmailStr = Field(description="Email to send the sign-in code to")


class EmailCodeVerify(BaseModel):
    email: EmailStr = Field(description="Email the code was sent to")
    code: str = Field(pattern=r"^\d{6}$", description="6-digit code from the email")


class TokenResponse(BaseModel):
    access_token: str = Field(description="JWT to send as 'Authorization: Bearer <token>'")
    token_type: str = Field(default="bearer", description="Always 'bearer'")


class MessageResponse(BaseModel):
    detail: str = Field(description="Human-readable result message")