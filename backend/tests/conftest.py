import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app import models  # noqa: F401  registers all tables on Base.metadata
from app.db import Base, get_db
from app.main import app


@pytest.fixture
def db_session():
    """A fresh in-memory SQLite database for every test: fast, no Docker needed."""
    # StaticPool keeps a single connection, so all sessions see the same memory DB.
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(engine)
    testing_session = sessionmaker(bind=engine, autoflush=False, expire_on_commit=False)
    with testing_session() as session:
        yield session
    engine.dispose()


@pytest.fixture
def client(db_session):
    """Test client whose endpoints use the in-memory database."""
    app.dependency_overrides[get_db] = lambda: db_session
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()