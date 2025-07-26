from fastapi import FastAPI, Request
from pydantic import BaseModel

from hash import create_hash

app = FastAPI()


class TrackQuery(BaseModel):
    title: str
    artists: list[str]
    album: str
    with_help: bool = False


class TrackHit(BaseModel):
    album: str
    artist: list[str]
    title: str


class RadioResponse(BaseModel):
    albums: list[str]
    artists: list[str]
    tracks: list[str]
    hits: list[TrackHit]


@app.get("/")
async def read_root():
    return {"message": "Hello, world!"}


@app.post("/radio")
async def create_radio(input: list[TrackQuery]):
    weakhash = create_hash('Dark Shines', 'Muse')
    return RadioResponse(
        albums=[],
        artists=[],
        tracks=[weakhash],
        hits=[]
    )

