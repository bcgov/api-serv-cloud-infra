from fastapi import FastAPI, HTTPException
import gzip
import json
import logging
import os

app = FastAPI()

cacheFile = os.environ.get('CACHE_FILE')

@app.get("/{entity}")
def fetch_list(entity: str):
  try:
    a_file = gzip.open(cacheFile, "rb")
    contents = json.loads(a_file.read())
    return { "next":None, "data":contents[entity] }
  except Exception as err:
    logging.critical(f"Unexpected {err}, {type(err)}")
    raise HTTPException(status_code=400, detail="Ooops somethings went wrong.")
