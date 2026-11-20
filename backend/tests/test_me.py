from datetime import UTC, datetime, timedelta

import jwt

from app.config import get_settings
from app.services.security import ALGORITHM, create_access_token

ME_URL = "/api/v1/me"
EMAIL = "egor@gmail.com"


def sign_in(client, capsys) -> str:
    client.post("/api/v1/auth/email/request", json={"email": EMAIL})
    code = capsys.readouterr().out.strip().split()[-1]
    response = client.post(
        "/api/v1/auth/email/verify", json={"email": EMAIL, "code": code}
    )
    return response.json()["access_token"]


def auth_header(token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"}


def test_me_returns_signed_in_user(client, capsys):
    token = sign_in(client, capsys)

    response = client.get(ME_URL, headers=auth_header(token))

    assert response.status_code == 200
    assert response.json()["email"] == EMAIL


def test_me_without_token_is_unauthorized(client):
    assert client.get(ME_URL).status_code == 401


def test_me_with_garbage_token_is_unauthorized(client):
    response = client.get(ME_URL, headers=auth_header("not-a-jwt"))
    assert response.status_code == 401


def test_me_with_expired_token_is_unauthorized(client):
    past = datetime.now(UTC) - timedelta(days=1)
    token = jwt.encode(
        {"sub": "some-id", "iat": past, "exp": past},
        get_settings().secret_key,
        algorithm=ALGORITHM,
    )
    response = client.get(ME_URL, headers=auth_header(token))
    assert response.status_code == 401


def test_me_with_token_of_unknown_user_is_unauthorized(client):
    token = create_access_token("no-such-user")
    response = client.get(ME_URL, headers=auth_header(token))
    assert response.status_code == 401