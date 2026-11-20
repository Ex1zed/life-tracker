from datetime import timedelta

import jwt
import pytest
from sqlalchemy import select

from app.config import get_settings
from app.models import AuthCode, AuthIdentity, User
from app.models.common import utc_now
from app.services import auth as auth_service

REQUEST_URL = "/api/v1/auth/email/request"
VERIFY_URL = "/api/v1/auth/email/verify"
EMAIL = "egor@gmail.com"


@pytest.fixture(autouse=True)
def no_resend_limit(monkeypatch):
    """Tests request several codes in a row; skip the one-minute limit."""
    monkeypatch.setattr(auth_service, "RESEND_INTERVAL", timedelta(0))


def request_code(client, capsys) -> str:
    client.post(REQUEST_URL, json={"email": EMAIL})
    return capsys.readouterr().out.strip().split()[-1]


def test_correct_code_creates_user_and_returns_token(client, db_session, capsys):
    code = request_code(client, capsys)

    response = client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    assert response.status_code == 200
    user = db_session.scalars(select(User)).one()
    assert user.email == EMAIL
    assert db_session.scalars(select(AuthIdentity)).one().user_id == user.id

    token = response.json()["access_token"]
    payload = jwt.decode(token, get_settings().secret_key, algorithms=["HS256"])
    assert payload["sub"] == user.id


def test_second_sign_in_reuses_the_same_user(client, db_session, capsys):
    for _ in range(2):
        code = request_code(client, capsys)
        client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    assert len(db_session.scalars(select(User)).all()) == 1


def test_wrong_code_is_rejected_and_counted(client, db_session, capsys):
    code = request_code(client, capsys)
    wrong = "000000" if code != "000000" else "111111"

    response = client.post(VERIFY_URL, json={"email": EMAIL, "code": wrong})

    assert response.status_code == 400
    assert db_session.scalars(select(AuthCode)).one().attempts == 1


def test_code_is_blocked_after_too_many_attempts(client, capsys):
    code = request_code(client, capsys)
    wrong = "000000" if code != "000000" else "111111"
    for _ in range(auth_service.MAX_ATTEMPTS):
        client.post(VERIFY_URL, json={"email": EMAIL, "code": wrong})

    # Even the right code doesn't help now.
    response = client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    assert response.status_code == 429


def test_code_works_only_once(client, capsys):
    code = request_code(client, capsys)
    client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    response = client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    assert response.status_code == 400


def test_expired_code_is_rejected(client, db_session, capsys):
    code = request_code(client, capsys)
    auth_code = db_session.scalars(select(AuthCode)).one()
    auth_code.expires_at = utc_now() - timedelta(minutes=1)
    db_session.commit()

    response = client.post(VERIFY_URL, json={"email": EMAIL, "code": code})

    assert response.status_code == 400