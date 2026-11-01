BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_rbac_user_permission" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_rbac_audit_log" CASCADE;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_rbac_role_permission" ADD COLUMN "_serverpodRbacPermissionRolesServerpodRbacPermissionId" bigint;
ALTER TABLE "serverpod_rbac_role_permission" ADD COLUMN "_serverpodRbacRolePermissionsServerpodRbacRoleId" bigint;
--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_user_role_user_role_idx";
ALTER TABLE "serverpod_rbac_user_role" ADD COLUMN "domain" text;
ALTER TABLE "serverpod_rbac_user_role" ADD COLUMN "_serverpodRbacRoleUserrolesServerpodRbacRoleId" bigint;
CREATE UNIQUE INDEX "serverpod_rbac_user_role_user_role_domain_idx" ON "serverpod_rbac_user_role" USING btree ("userIdentifier", "roleId", "domain") NULLS NOT DISTINCT;
CREATE INDEX "serverpod_rbac_user_role_domain_idx" ON "serverpod_rbac_user_role" USING btree ("domain");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_role_permission"
    ADD CONSTRAINT "serverpod_rbac_role_permission_fk_2"
    FOREIGN KEY("_serverpodRbacPermissionRolesServerpodRbacPermissionId")
    REFERENCES "serverpod_rbac_permission"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_rbac_role_permission"
    ADD CONSTRAINT "serverpod_rbac_role_permission_fk_3"
    FOREIGN KEY("_serverpodRbacRolePermissionsServerpodRbacRoleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_user_role"
    ADD CONSTRAINT "serverpod_rbac_user_role_fk_1"
    FOREIGN KEY("_serverpodRbacRoleUserrolesServerpodRbacRoleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261101073051460', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101073051460', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
