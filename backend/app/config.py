from functools import lru_cache
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy import URL

# .env lives in the repo root and is shared with docker-compose.
ENV_FILE = Path(__file__).resolve().parents[2] / ".env"


class Settings(BaseSettings):
    # extra="ignore": .env also has vars the backend doesn't need (root password).
    model_config = SettingsConfigDict(env_file=ENV_FILE, extra="ignore")

    mysql_host: str = "127.0.0.1"
    mysql_port: int = 3306
    mysql_database: str
    mysql_user: str
    mysql_password: str

    @property
    def database_url(self) -> URL:
        # URL.create escapes special characters in the password for us.
        return URL.create(
            "mysql+pymysql",
            username=self.mysql_user,
            password=self.mysql_password,
            host=self.mysql_host,
            port=self.mysql_port,
            database=self.mysql_database,
        )


@lru_cache
def get_settings() -> Settings:
    """Read settings once and reuse them everywhere."""
    return Settings()