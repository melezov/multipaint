/*MIGRATION_DESCRIPTION
--REMOVE: Security-RolePermission-IsAllowed
Property IsAllowed will be removed from object RolePermission in schema Security
--REMOVE: Security-RolePermission-RoleID
Property RoleID will be removed from object RolePermission in schema Security
--REMOVE: Security-RolePermission-Name
Property Name will be removed from object RolePermission in schema Security
--REMOVE: Security-RolePermission
Object RolePermission will be removed from schema Security
--REMOVE: Security-GlobalPermission-IsAllowed
Property IsAllowed will be removed from object GlobalPermission in schema Security
--REMOVE: Security-GlobalPermission-Name
Property Name will be removed from object GlobalPermission in schema Security
--REMOVE: Security-GlobalPermission
Object GlobalPermission will be removed from schema Security
--REMOVE: Security-InheritedRole-ParentName
Property ParentName will be removed from object InheritedRole in schema Security
--REMOVE: Security-InheritedRole-Name
Property Name will be removed from object InheritedRole in schema Security
--REMOVE: Security-InheritedRole
Object InheritedRole will be removed from schema Security
--REMOVE: Security-Role-Name
Property Name will be removed from object Role in schema Security
--REMOVE: Security-Role
Object Role will be removed from schema Security
--REMOVE: Security-User-IsAllowed
Property IsAllowed will be removed from object User in schema Security
--REMOVE: Security-User-PasswordHash
Property PasswordHash will be removed from object User in schema Security
--REMOVE: Security-User-Name
Property Name will be removed from object User in schema Security
--REMOVE: Security-User
Object User will be removed from schema Security
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'RolePermission' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."RolePermission" DROP CONSTRAINT "fk_Role";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_ParentRole' AND n.nspname = 'Security' AND r.relname = 'InheritedRole' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."InheritedRole" DROP CONSTRAINT "fk_ParentRole";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'InheritedRole' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."InheritedRole" DROP CONSTRAINT "fk_Role";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'User' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."User" DROP CONSTRAINT "fk_Role";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_RolePermission' AND n.nspname = 'Security' AND r.relname = 'RolePermission' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."RolePermission" DROP CONSTRAINT "pk_RolePermission";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_GlobalPermission' AND n.nspname = 'Security' AND r.relname = 'GlobalPermission' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."GlobalPermission" DROP CONSTRAINT "pk_GlobalPermission";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_InheritedRole' AND n.nspname = 'Security' AND r.relname = 'InheritedRole' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."InheritedRole" DROP CONSTRAINT "pk_InheritedRole";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_Role' AND n.nspname = 'Security' AND r.relname = 'Role' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."Role" DROP CONSTRAINT "pk_Role";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_User' AND n.nspname = 'Security' AND r.relname = 'User' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "Security"."User" DROP CONSTRAINT "pk_User";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		DELETE FROM "Security"."Role" WHERE "Name" = 'Administrator';
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-") RETURNS "Security"."RolePermission_entity" AS $$ SELECT $1::text::"Security"."RolePermission_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity") RETURNS "Security"."-ngs_RolePermission_type-" AS $$ SELECT $1::text::"Security"."-ngs_RolePermission_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-") RETURNS "Security"."GlobalPermission_entity" AS $$ SELECT $1::text::"Security"."GlobalPermission_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity") RETURNS "Security"."-ngs_GlobalPermission_type-" AS $$ SELECT $1::text::"Security"."-ngs_GlobalPermission_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-") RETURNS "Security"."InheritedRole_entity" AS $$ SELECT $1::text::"Security"."InheritedRole_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity") RETURNS "Security"."-ngs_InheritedRole_type-" AS $$ SELECT $1::text::"Security"."-ngs_InheritedRole_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-") RETURNS "Security"."Role_entity" AS $$ SELECT $1::text::"Security"."Role_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."Role_entity") RETURNS "Security"."-ngs_Role_type-" AS $$ SELECT $1::text::"Security"."-ngs_Role_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."-ngs_User_type-") RETURNS "Security"."User_entity" AS $$ SELECT $1::text::"Security"."User_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."User_entity") RETURNS "Security"."-ngs_User_type-" AS $$ SELECT $1::text::"Security"."-ngs_User_type-" $$ IMMUTABLE LANGUAGE sql;
DROP FUNCTION IF EXISTS "Role"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."RolePermission_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_RolePermission"("Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_RolePermission_type-" AS "Security"."RolePermission_entity");
DROP CAST IF EXISTS ("Security"."RolePermission_entity" AS "Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."GlobalPermission_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_GlobalPermission"("Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_GlobalPermission_type-" AS "Security"."GlobalPermission_entity");
DROP CAST IF EXISTS ("Security"."GlobalPermission_entity" AS "Security"."-ngs_GlobalPermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity");
DROP FUNCTION IF EXISTS "ParentRole"("Security"."InheritedRole_entity");
DROP FUNCTION IF EXISTS "Role"("Security"."InheritedRole_entity");
DROP VIEW IF EXISTS "Security"."InheritedRole_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_InheritedRole"("Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_InheritedRole_type-" AS "Security"."InheritedRole_entity");
DROP CAST IF EXISTS ("Security"."InheritedRole_entity" AS "Security"."-ngs_InheritedRole_type-");
DROP FUNCTION IF EXISTS "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-");
DROP FUNCTION IF EXISTS "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity");
DROP VIEW IF EXISTS "Security"."Role_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_Role"("Security"."Role_entity"[], "Security"."Role_entity"[], "Security"."Role_entity"[], "Security"."Role_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_Role_type-" AS "Security"."Role_entity");
DROP CAST IF EXISTS ("Security"."Role_entity" AS "Security"."-ngs_Role_type-");
DROP FUNCTION IF EXISTS "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-");
DROP FUNCTION IF EXISTS "Security"."cast_Role_to_type"("Security"."Role_entity");
DROP FUNCTION IF EXISTS "Role"("Security"."User_entity");
DROP VIEW IF EXISTS "Security"."User_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_User"("Security"."User_entity"[], "Security"."User_entity"[], "Security"."User_entity"[], "Security"."User_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_User_type-" AS "Security"."User_entity");
DROP CAST IF EXISTS ("Security"."User_entity" AS "Security"."-ngs_User_type-");
DROP FUNCTION IF EXISTS "Security"."cast_User_to_type"("Security"."-ngs_User_type-");
DROP FUNCTION IF EXISTS "Security"."cast_User_to_type"("Security"."User_entity");
DROP VIEW IF EXISTS "Security"."RolePermission_entity";
DROP VIEW IF EXISTS "Security"."GlobalPermission_entity";
DROP VIEW IF EXISTS "Security"."InheritedRole_entity";
DROP VIEW IF EXISTS "Security"."Role_entity";
DROP VIEW IF EXISTS "Security"."User_entity";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."RolePermission" DROP COLUMN "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'RoleID' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."RolePermission" DROP COLUMN "RoleID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'RoleID' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE "RoleID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE IF EXISTS "RoleURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."RolePermission" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'GlobalPermission' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."GlobalPermission" DROP COLUMN "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_GlobalPermission_type-' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" DROP ATTRIBUTE "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'GlobalPermission' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."GlobalPermission" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_GlobalPermission_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_GlobalPermission_type-" DROP ATTRIBUTE IF EXISTS "URI";
ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE IF EXISTS "ParentRoleURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'InheritedRole' AND column_name = 'ParentName' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."InheritedRole" DROP COLUMN "ParentName";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'ParentName' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE "ParentName";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE IF EXISTS "RoleURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'InheritedRole' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."InheritedRole" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."Role" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_Role_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_Role_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_Role_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."User" DROP COLUMN "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'IsAllowed' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE "IsAllowed";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'PasswordHash' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."User" DROP COLUMN "PasswordHash";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'PasswordHash' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE "PasswordHash";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE IF EXISTS "RoleURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "Security"."User" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'RolePermission_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "Security"."RolePermission_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'RolePermission' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "Security"."RolePermission";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND t.typname = '-ngs_RolePermission_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "Security"."-ngs_RolePermission_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'GlobalPermission_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "Security"."GlobalPermission_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'GlobalPermission' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "Security"."GlobalPermission";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND t.typname = '-ngs_GlobalPermission_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "Security"."-ngs_GlobalPermission_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'InheritedRole_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "Security"."InheritedRole_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'InheritedRole' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "Security"."InheritedRole";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND t.typname = '-ngs_InheritedRole_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "Security"."-ngs_InheritedRole_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'Role_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "Security"."Role_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'Role' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "Security"."Role";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND t.typname = '-ngs_Role_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "Security"."-ngs_Role_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'User_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "Security"."User_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND c.relname = 'User' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "Security"."User";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'Security' AND t.typname = '-ngs_User_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "Security"."-ngs_User_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_namespace n JOIN pg_description d ON d.objoid = n.oid WHERE n.nspname = 'Security' AND d.description LIKE 'NGS generated%') THEN
		DROP SCHEMA "Security";
	END IF;
END $$ LANGUAGE plpgsql;

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
	/* private artist information */
	big aggregate Artist {
		String     Name;
		Guid       Session { Index; }
		Timestamp  CreatedAt { sequence; }

		specification GetArtistBySession ''it => it.Session == Session'' {
			Guid Session;
		}
	}

	/* brushes are public and authors are known
	big aggregate Brush {
		Artist  *Artist;
		String  Color;
		Int     Thickness;
	}

	/* request for a new brush 
	event ChangeBrush {
		Guid    Session; // authorization
		String  Color;
		Int     Thickness;
		Long?   BrushID; // output
	}

	value Position {
		Int  X;
		Int  Y;
	}

	/* one segment of a brush path 
	big aggregate Segment {
		Brush       *Brush;
		Int         Index;
		MouseState  State;
		Position    Position;
		Timestamp   OccurredAt;
	}

	snowflake<Segment> Drawing {
		ID;
		Brush.Color as Color;
		BrushID;
		Index;
		State;
		Position;

		specification GetFromID ''it => it.ID > fromID'' {
			Long fromID;
		}

		order by BrushID, Index;
	}

	enum MouseState {
		Press; Drag; Release;
	}

	/* mouse actions create brush segments 
	event MouseAction {
		Guid        Session; // authorization
		Long        BrushID;
		Int         Index;
		MouseState  State;
		Position    Position;
	}
	*/
}
","d:\\Code\\multipaint\\dsl\\Security.dsl"=>""', '\x','1.0.3.34768')