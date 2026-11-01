BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_audit_log" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text,
    "action" text NOT NULL,
    "resource" text,
    "permissionCodename" text,
    "roleName" text,
    "allowed" boolean NOT NULL,
    "scope" text,
    "objectId" text,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_rbac_audit_user_idx" ON "serverpod_rbac_audit_log" USING btree ("userIdentifier");
CREATE INDEX "serverpod_rbac_audit_created_idx" ON "serverpod_rbac_audit_log" USING btree ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_object_permission" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text,
    "roleId" bigint,
    "permissionId" bigint NOT NULL,
    "resource" text NOT NULL,
    "objectId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_rbac_obj_perm_lookup_idx" ON "serverpod_rbac_object_permission" USING btree ("resource", "objectId");
CREATE INDEX "serverpod_rbac_obj_perm_user_idx" ON "serverpod_rbac_object_permission" USING btree ("userIdentifier", "resource", "objectId");
CREATE INDEX "serverpod_rbac_obj_perm_role_idx" ON "serverpod_rbac_object_permission" USING btree ("roleId", "resource", "objectId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_permission" (
    "id" bigserial PRIMARY KEY,
    "resource" text NOT NULL,
    "codename" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_rbac_perm_res_code_idx" ON "serverpod_rbac_permission" USING btree ("resource", "codename");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_role" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "isSuperuser" boolean NOT NULL DEFAULT false,
    "isSystemRole" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_rbac_role__name__unique_idx" ON "serverpod_rbac_role" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_role_permission" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "permissionId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_rbac_role_perm_idx" ON "serverpod_rbac_role_permission" USING btree ("roleId", "permissionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_user_permission" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "permissionId" bigint NOT NULL,
    "isGranted" boolean NOT NULL DEFAULT true,
    "scope" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_rbac_user_perm_scope_idx" ON "serverpod_rbac_user_permission" USING btree ("userIdentifier", "permissionId", "scope") NULLS NOT DISTINCT;
CREATE INDEX "serverpod_rbac_user_perm_user_idx" ON "serverpod_rbac_user_permission" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_rbac_user_role" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "roleId" bigint NOT NULL,
    "scope" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_rbac_user_role_scope_idx" ON "serverpod_rbac_user_role" USING btree ("userIdentifier", "roleId", "scope") NULLS NOT DISTINCT;
CREATE INDEX "serverpod_rbac_user_role_user_idx" ON "serverpod_rbac_user_role" USING btree ("userIdentifier");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_object_permission"
    ADD CONSTRAINT "serverpod_rbac_object_permission_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_rbac_object_permission"
    ADD CONSTRAINT "serverpod_rbac_object_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "serverpod_rbac_permission"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_role_permission"
    ADD CONSTRAINT "serverpod_rbac_role_permission_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_rbac_role_permission"
    ADD CONSTRAINT "serverpod_rbac_role_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "serverpod_rbac_permission"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_user_permission"
    ADD CONSTRAINT "serverpod_rbac_user_permission_fk_0"
    FOREIGN KEY("permissionId")
    REFERENCES "serverpod_rbac_permission"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_rbac_user_role"
    ADD CONSTRAINT "serverpod_rbac_user_role_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "serverpod_rbac_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_rbac
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_rbac', '20261013052535884', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013052535884', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
