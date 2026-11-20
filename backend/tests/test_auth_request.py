from sqlalchemy import select

from app.models import AuthCode

URL = "/api/v1/auth/email/request"


def test_request_stores_hashed_code_and_sends_it(client, db_session, capsys):
    response = client.post(URL, json={"email": "Egor@Gmail.com"})

    assert response.status_code == 202
    codes = db_session.scalars(select(AuthCode)).all()
    assert len(codes) == 1
    assert codes[0].email == "egor@gmail.com"

    sent_code = capsys.readouterr().out.strip().split()[-1]
    assert len(sent_code) == 6 and sent_code.isdigit()
    assert codes[0].code_hash != sent_code  # only the hash is stored


def test_second_request_within_a_minute_is_rejected(client):
    client.post(URL, json={"email": "egor@gmail.com"})
    response = client.post(URL, json={"email": "egor@gmail.com"})

    assert response.status_code == 429


def test_invalid_email_is_rejected(client):
    response = client.post(URL, json={"email": "not-an-email"})

    assert response.status_code == 422