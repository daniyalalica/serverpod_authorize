BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_domain_rule_role_resource_idx";
ALTER TABLE "serverpod_rbac_domain_rule" ADD COLUMN "permission" text;
CREATE INDEX "serverpod_rbac_domain_rule_role_resource_idx" ON "serverpod_rbac_domain_rule" USING btree ("roleId", "resource", "permission");

--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261101094317198-permission-scoped-domains', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101094317198-permission-scoped-domains', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
