BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "expenses" ADD COLUMN "productName" text;
ALTER TABLE "expenses" ADD COLUMN "description" text;
CREATE INDEX "expense_product_idx" ON "expenses" USING btree ("productName");

--
-- MIGRATION VERSION FOR kindred_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kindred_butler', '20260128151737129', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260128151737129', "timestamp" = now();

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
