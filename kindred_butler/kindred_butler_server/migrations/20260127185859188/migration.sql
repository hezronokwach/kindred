BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account" (
    "id" bigserial PRIMARY KEY,
    "balance" double precision NOT NULL DEFAULT 10000.0,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "expenses" (
    "id" bigserial PRIMARY KEY,
    "category" text NOT NULL,
    "amount" double precision NOT NULL,
    "date" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "expense_category_idx" ON "expenses" USING btree ("category");
CREATE INDEX "expense_date_idx" ON "expenses" USING btree ("date");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "products" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "stockCount" bigint NOT NULL,
    "price" double precision NOT NULL,
    "imageUrl" text,
    "category" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_name_idx" ON "products" USING btree ("name");
CREATE INDEX "product_category_idx" ON "products" USING btree ("category");
CREATE INDEX "product_stock_idx" ON "products" USING btree ("stockCount");


--
-- MIGRATION VERSION FOR kindred_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kindred_butler', '20260127185859188', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127185859188', "timestamp" = now();

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


--
-- MIGRATION VERSION FOR 'morphic_butler'
--
DELETE FROM "serverpod_migrations"WHERE "module" IN ('morphic_butler');

COMMIT;
