-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "top_artists" (
    "id" TEXT   NOT NULL,
    "name" TEXT   NOT NULL,
    "followers" INTEGER   NOT NULL,
    "popularity" SMALLINT   NOT NULL,
    CONSTRAINT "pk_top_artists" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "artist_genre" (
    "id" TEXT   NOT NULL,
    "name" TEXT   NOT NULL,
    "genres" TEXT
);

CREATE TABLE "top_tracks" (
    "id" TEXT   NOT NULL,
    "name" TEXT   NOT NULL,
    "popularity" SMALLINT   NOT NULL,
    "duration_ms" INTEGER   NOT NULL,
    "explicit" SMALLINT   NOT NULL,
    "release_date" DATE   NOT NULL,
    "danceability" REAL   NOT NULL,
    "energy" REAL   NOT NULL,
    "key" SMALLINT   NOT NULL,
    "loudness" REAL   NOT NULL,
    "mode" SMALLINT   NOT NULL,
    "speechiness" REAL   NOT NULL,
    "acousticness" REAL   NOT NULL,
    "instrumentalness" REAL   NOT NULL,
    "liveness" REAL   NOT NULL,
    "valence" REAL   NOT NULL,
    "tempo" REAL   NOT NULL,
    "time_signature" SMALLINT   NOT NULL,
    CONSTRAINT "pk_top_tracks" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "artist_track" (
    "id_artists" TEXT   NOT NULL,
    "artists" TEXT   NOT NULL,
    "id_tracks" TEXT   NOT NULL,
    "tracks" TEXT   NOT NULL
);

ALTER TABLE "artist_genre" ADD CONSTRAINT "fk_artist_genre_id" FOREIGN KEY("id")
REFERENCES "top_artists" ("id");

ALTER TABLE "artist_track" ADD CONSTRAINT "fk_artist_track_id_artists" FOREIGN KEY("id_artists")
REFERENCES "top_artists" ("id");

ALTER TABLE "artist_track" ADD CONSTRAINT "fk_artist_track_id_tracks" FOREIGN KEY("id_tracks")
REFERENCES "top_tracks" ("id");

