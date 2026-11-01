BEGIN;

-- Collapse scoped assignments into global assignments. When duplicate user
-- grants/denials exist, keep the most recently created row.
WITH ranked_permissions AS (
    SELECT "id",
           ROW_NUMBER() OVER (
               PARTITION BY "userIdentifier", "permissionId"
               ORDER BY "createdAt" DESC, "id" DESC
           ) AS row_number
    FROM "serverpod_rbac_user_permission"
)
DELETE FROM "serverpod_rbac_user_permission" AS permissions
USING ranked_permissions
WHERE permissions."id" = ranked_permissions."id"
  AND ranked_permissions.row_number > 1;

WITH ranked_roles AS (
    SELECT "id",
           ROW_NUMBER() OVER (
               PARTITION BY "userIdentifier", "roleId"
               ORDER BY "createdAt" DESC, "id" DESC
           ) AS row_number
    FROM "serverpod_rbac_user_role"
)
DELETE FROM "serverpod_rbac_user_role" AS roles
USING ranked_roles
WHERE roles."id" = ranked_roles."id"
  AND ranked_roles.row_number > 1;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_rbac_object_permission" CASCADE;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_rbac_audit_log" DROP COLUMN "scope";
ALTER TABLE "serverpod_rbac_audit_log" DROP COLUMN "objectId";
--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_user_perm_scope_idx";
ALTER TABLE "serverpod_rbac_user_permission" DROP COLUMN "scope";
CREATE UNIQUE INDEX "serverpod_rbac_user_perm_user_perm_idx" ON "serverpod_rbac_user_permission" USING btree ("userIdentifier", "permissionId");
--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_user_role_scope_idx";
ALTER TABLE "serverpod_rbac_user_role" DROP COLUMN "scope";
CREATE UNIQUE INDEX "serverpod_rbac_user_role_user_role_idx" ON "serverpod_rbac_user_role" USING btree ("userIdentifier", "roleId");

--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261015050330456-remove-scopes-object-permissions', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015050330456-remove-scopes-object-permissions', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
