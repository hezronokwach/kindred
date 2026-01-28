BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "expenses" ADD COLUMN "type" text NOT NULL DEFAULT 'expense'::text;
ALTER TABLE "expenses" ADD COLUMN "paymentMethod" text DEFAULT 'Cash'::text;
ALTER TABLE "expenses" ADD COLUMN "taxAmount" double precision NOT NULL DEFAULT 0.0;
CREATE INDEX "expense_type_idx" ON "expenses" USING btree ("type");
--
-- ACTION DROP TABLE
--
DROP TABLE "products" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "products" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "stockCount" bigint NOT NULL,
    "sellingPrice" double precision NOT NULL,
    "costPrice" double precision NOT NULL,
    "brand" text NOT NULL,
    "sku" text,
    "unit" text NOT NULL DEFAULT 'pair'::text,
    "minStockThreshold" bigint NOT NULL DEFAULT 5,
    "imageUrl" text,
    "category" text,
    "supplierId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_name_idx" ON "products" USING btree ("name");
CREATE INDEX "product_category_idx" ON "products" USING btree ("category");
CREATE INDEX "product_stock_idx" ON "products" USING btree ("stockCount");
CREATE INDEX "product_brand_idx" ON "products" USING btree ("brand");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "suppliers" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "contactPerson" text,
    "email" text,
    "phone" text,
    "leadTimeDays" bigint NOT NULL DEFAULT 3
);

-- Indexes
CREATE INDEX "supplier_name_idx" ON "suppliers" USING btree ("name");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "products"
    ADD CONSTRAINT "products_fk_0"
    FOREIGN KEY("supplierId")
    REFERENCES "suppliers"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR kindred_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('kindred_butler', '20260128172540324', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260128172540324', "timestamp" = now();

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
