from fastapi import FastAPI

from app.routers import auth, health, me

app = FastAPI(title="Life Tracker API", version="0.1.0")

# All endpoints live under /api/v1, as in the spec.
app.include_router(health.router, prefix="/api/v1")
app.include_router(auth.router, prefix="/api/v1")
app.include_router(me.router, prefix="/api/v1")