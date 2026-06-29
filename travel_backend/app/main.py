from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.places import router as places_router
from app.api.visits import router as visits_router

from app.api.companion import router as companion_router
from app.api.map import router as map_router

from app.api.imports import router as import_router



app = FastAPI(
    title="Atlas API",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(places_router)
app.include_router(visits_router)
app.include_router(companion_router)
app.include_router(map_router)
app.include_router(import_router)


@app.get("/")
async def root():
    return {"status": "ok"}


@app.get("/api/v1/health")
async def health():
    return {"status": "healthy"}
    