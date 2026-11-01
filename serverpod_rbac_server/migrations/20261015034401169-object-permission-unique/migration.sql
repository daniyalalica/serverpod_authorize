BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_rbac_obj_perm_user_idx";
DROP INDEX "serverpod_rbac_obj_perm_role_idx";
CREATE UNIQUE INDEX "serverpod_rbac_obj_perm_user_idx" ON "serverpod_rbac_object_permission" USING btree ("userIdentifier", "resource", "objectId", "permissionId", "scope", "roleId") NULLS NOT DISTINCT;
CREATE UNIQUE INDEX "serverpod_rbac_obj_perm_role_idx" ON "serverpod_rbac_object_permission" USING btree ("roleId", "resource", "objectId", "permissionId", "scope", "userIdentifier") NULLS NOT DISTINCT;

--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261015034401169-object-permission-unique', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015034401169-object-permission-unique', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
