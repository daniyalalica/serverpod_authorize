BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_rbac_role_permission" DROP CONSTRAINT IF EXISTS "serverpod_rbac_role_permission_fk_2";
ALTER TABLE "serverpod_rbac_role_permission" DROP CONSTRAINT IF EXISTS "serverpod_rbac_role_permission_fk_3";
ALTER TABLE "serverpod_rbac_role_permission" DROP COLUMN "_serverpodRbacPermissionRolesServerpodRbacPermissionId";
ALTER TABLE "serverpod_rbac_role_permission" DROP COLUMN "_serverpodRbacRolePermissionsServerpodRbacRoleId";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_rbac_user_role" DROP CONSTRAINT IF EXISTS "serverpod_rbac_user_role_fk_1";
ALTER TABLE "serverpod_rbac_user_role" DROP COLUMN "_serverpodRbacRoleUserrolesServerpodRbacRoleId";

--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261101073328762', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101073328762', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
