import datetime as dt

from sqlalchemy import select

from app.models import DailyCheckin

URL = "/api/v1/sync/push"
ID = "11111111-1111-1111-1111-111111111111"
OTHER_DEVICE_ID = "22222222-2222-2222-2222-222222222222"


def checkin(**overrides) -> dict:
    data = {
        "id": ID,
        "date": "2026-11-20",
        "mood": 7,
        "energy": 5,
        "productivity": 8,
        "note": None,
        "created_at": "2026-11-20T10:00:00Z",
        "updated_at": "2026-11-20T10:00:00Z",
        "deleted_at": None,
    }
    data.update(overrides)
    return data


def push(client, headers, *items):
    return client.post(URL, json={"checkins": list(items)}, headers=headers)


def saved(db_session) -> list[DailyCheckin]:
    return db_session.scalars(select(DailyCheckin)).all()


def test_new_checkin_is_saved_for_the_user(client, db_session, user, auth_headers):
    response = push(client, auth_headers, checkin())

    assert response.json() == {"applied": 1, "skipped": 0}
    row = saved(db_session)[0]
    assert row.user_id == user.id
    assert row.date == dt.date(2026, 11, 20)
    assert row.mood == 7


def test_older_change_is_skipped(client, db_session, auth_headers):
    push(client, auth_headers, checkin(mood=7, updated_at="2026-11-20T12:00:00Z"))

    response = push(client, auth_headers, checkin(mood=3, updated_at="2026-11-20T11:00:00Z"))

    assert response.json() == {"applied": 0, "skipped": 1}
    assert saved(db_session)[0].mood == 7


def test_same_date_from_another_device_updates_one_row(client, db_session, auth_headers):
    push(client, auth_headers, checkin(mood=7))

    response = push(
        client,
        auth_headers,
        checkin(id=OTHER_DEVICE_ID, mood=4, updated_at="2026-11-20T15:00:00Z"),
    )

    assert response.json() == {"applied": 1, "skipped": 0}
    rows = saved(db_session)
    assert len(rows) == 1
    assert rows[0].id == ID  # the server keeps its id
    assert rows[0].mood == 4


def test_deletion_is_synced(client, db_session, auth_headers):
    push(client, auth_headers, checkin())

    push(
        client,
        auth_headers,
        checkin(updated_at="2026-11-20T13:00:00Z", deleted_at="2026-11-20T13:00:00Z"),
    )

    assert saved(db_session)[0].deleted_at is not None


def test_times_are_stored_in_utc(client, db_session, auth_headers):
    # 17:00 in Krasnoyarsk (+07:00) is 10:00 UTC.
    push(client, auth_headers, checkin(updated_at="2026-11-20T17:00:00+07:00"))

    assert saved(db_session)[0].updated_at == dt.datetime(2026, 11, 20, 10, 0)


def test_push_requires_sign_in(client):
    assert push(client, {}, checkin()).status_code == 401