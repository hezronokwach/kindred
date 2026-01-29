BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "alert" (
    "id" bigserial PRIMARY KEY,
    "type" text NOT NULL,
    "threshold" double precision NOT NULL,
    "comparison" text NOT NULL,
    "productFilter" text,
    "isActive" boolean NOT NULL,
    "message" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shortcut" (
    "id" bigserial PRIMARY KEY,
    "triggerPhrase" text NOT NULL,
    "actions" json NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "trigger_phrase_idx" ON "shortcut" USING btree ("triggerPhrase");


--
-- MIGRATION VERSION FOR kindred_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kindred_butler', '20260129084122725', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129084122725', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
