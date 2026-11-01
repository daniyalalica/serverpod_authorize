BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_domain_rule" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "resource" text NOT NULL,
    "filterExpression" text NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_rbac_domain_rule_role_resource_idx" ON "serverpod_rbac_domain_rule" USING btree ("roleId", "resource");
CREATE INDEX "serverpod_rbac_domain_rule_resource_idx" ON "serverpod_rbac_domain_rule" USING btree ("resource");

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_user_role_user_role_domain_idx";
DROP INDEX "serverpod_rbac_user_role_domain_idx";
ALTER TABLE "serverpod_rbac_user_role" DROP COLUMN "domain";
CREATE UNIQUE INDEX "serverpod_rbac_user_role_user_role_idx" ON "serverpod_rbac_user_role" USING btree ("userIdentifier", "roleId");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_domain_rule"
    ADD CONSTRAINT "serverpod_rbac_domain_rule_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261101085856321', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101085856321', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
