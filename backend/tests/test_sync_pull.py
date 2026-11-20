from app.models import DailyCheckin, User
from app.models.common import utc_now
from app.services import sync as sync_service

PUSH_URL = "/api/v1/sync/push"
PULL_URL = "/api/v1/sync/pull"


def checkin(day: int, **overrides) -> dict:
    data = {
        "id": f"00000000-0000-0000-0000-0000000000{day:02d}",
        "date": f"2026-11-{day:02d}",
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
    client.post(PUSH_URL, json={"checkins": list(items)}, headers=headers)


def pull(client, headers, since=None):
    params = {"since": since} if since else {}
    return client.get(PULL_URL, params=params, headers=headers).json()


def test_first_pull_returns_everything(client, auth_headers):
    push(client, auth_headers, checkin(1), checkin(2))

    body = pull(client, auth_headers)

    assert [c["date"] for c in body["checkins"]] == ["2026-11-01", "2026-11-02"]
    assert body["cursor"] is not None
    assert body["has_more"] is False


def test_pull_with_cursor_returns_only_newer_changes(client, auth_headers):
    push(client, auth_headers, checkin(1))
    cursor = pull(client, auth_headers)["cursor"]

    push(client, auth_headers, checkin(2))
    body = pull(client, auth_headers, since=cursor)

    assert [c["date"] for c in body["checkins"]] == ["2026-11-02"]


def test_nothing_new_keeps_the_same_cursor(client, auth_headers):
    push(client, auth_headers, checkin(1))
    cursor = pull(client, auth_headers)["cursor"]

    body = pull(client, auth_headers, since=cursor)

    assert body["checkins"] == []
    assert body["cursor"] == cursor


def test_deletions_are_pulled(client, auth_headers):
    push(client, auth_headers, checkin(1, deleted_at="2026-11-20T10:00:00Z"))

    body = pull(client, auth_headers)

    assert body["checkins"][0]["deleted_at"] is not None


def test_other_users_checkins_are_not_returned(client, db_session, auth_headers):
    stranger = User(email="stranger@gmail.com")
    db_session.add(stranger)
    db_session.flush()
    now = utc_now()
    db_session.add(
        DailyCheckin(
            user_id=stranger.id,
            date=now.date(),
            mood=1,
            energy=1,
            productivity=1,
            created_at=now,
            updated_at=now,
        )
    )
    db_session.commit()

    assert pull(client, auth_headers)["checkins"] == []


def test_large_pull_is_split_into_pages(client, auth_headers, monkeypatch):
    monkeypatch.setattr(sync_service, "PULL_LIMIT", 2)
    push(client, auth_headers, checkin(1), checkin(2), checkin(3))

    first = pull(client, auth_headers)
    second = pull(client, auth_headers, since=first["cursor"])

    assert len(first["checkins"]) == 2 and first["has_more"] is True
    assert len(second["checkins"]) == 1 and second["has_more"] is False


def test_pull_requires_sign_in(client):
    assert client.get(PULL_URL).status_code == 401