/*MIGRATION_DESCRIPTION
--REMOVE: MultiPaint-Brush-Index
Property Index will be removed from object Brush in schema MultiPaint
--REMOVE: MultiPaint-Brush-ArtistName
Property ArtistName will be removed from object Brush in schema MultiPaint
--REMOVE: MultiPaint-ChangeBrush-BrushURI
Property BrushURI will be removed from object ChangeBrush in schema MultiPaint
--CREATE: MultiPaint-Brush-ID
New property ID will be created for Brush in MultiPaint
--CREATE: MultiPaint-Brush-LastPosition
New property LastPosition will be created for Brush in MultiPaint
--CREATE: MultiPaint-ChangeBrush-BrushID
New property BrushID will be created for ChangeBrush in MultiPaint
--CREATE: MultiPaint-Position
New object Position will be created in schema MultiPaint
--CREATE: MultiPaint-Position-X
New property X will be created for Position in MultiPaint
--CREATE: MultiPaint-Position-Y
New property Y will be created for Position in MultiPaint
--CREATE: MultiPaint-MouseState
New object MouseState will be created in schema MultiPaint
--CREATE: MultiPaint-MouseState-Move
New enum label Move will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseState-Press
New enum label Press will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseState-Drag
New enum label Drag will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseState-Release
New enum label Release will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseAction
New object MouseAction will be created in schema MultiPaint
--CREATE: MultiPaint-MouseAction-BrushID
New property BrushID will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-Index
New property Index will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-State
New property State will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-Position
New property Position will be created for MouseAction in MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Brushes' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Brush" DROP CONSTRAINT "fk_Brushes";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Artist' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Brush" DROP CONSTRAINT "fk_Artist";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_Brush' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Brush" DROP CONSTRAINT "pk_Brush";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_Brush_ArtistName' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."ix_Brush_ArtistName";
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-") RETURNS "Security"."RolePermission_entity" AS $$ SELECT $1::text::"Security"."RolePermission_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity") RETURNS "Security"."-ngs_RolePermission_type-" AS $$ SELECT $1::text::"Security"."-ngs_RolePermission_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-") RETURNS "Security"."InheritedRole_entity" AS $$ SELECT $1::text::"Security"."InheritedRole_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity") RETURNS "Security"."-ngs_InheritedRole_type-" AS $$ SELECT $1::text::"Security"."-ngs_InheritedRole_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-") RETURNS "Security"."Role_entity" AS $$ SELECT $1::text::"Security"."Role_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."Role_entity") RETURNS "Security"."-ngs_Role_type-" AS $$ SELECT $1::text::"Security"."-ngs_Role_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."-ngs_User_type-") RETURNS "Security"."User_entity" AS $$ SELECT $1::text::"Security"."User_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."User_entity") RETURNS "Security"."-ngs_User_type-" AS $$ SELECT $1::text::"Security"."-ngs_User_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-") RETURNS "MultiPaint"."Brush_entity" AS $$ SELECT $1::text::"MultiPaint"."Brush_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity") RETURNS "MultiPaint"."-ngs_Brush_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Brush_type-" $$ IMMUTABLE LANGUAGE sql;

DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-insert1044030127<";
DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-update1044030127<";
DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-delete1044030127<";;
DROP FUNCTION IF EXISTS "Artist"("MultiPaint"."Brush_entity");
DROP FUNCTION IF EXISTS "User"("MultiPaint"."Artist_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_unprocessed_events";

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist"("MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[]);
DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist_internal"(int, int);
DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-insert<";
DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-update<";
DROP TABLE IF EXISTS "MultiPaint".">tmp-Artist-delete<";;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity");
DROP CAST IF EXISTS ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity");
DROP FUNCTION IF EXISTS "Role"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."RolePermission_unprocessed_events";

DROP FUNCTION IF EXISTS "Security"."persist_RolePermission"("Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_RolePermission_type-" AS "Security"."RolePermission_entity");
DROP CAST IF EXISTS ("Security"."RolePermission_entity" AS "Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity");
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
DROP FUNCTION IF EXISTS "MultiPaint"."submit_ChangeBrush"("MultiPaint"."ChangeBrush_event"[]);

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Brush_type-" AS "MultiPaint"."Brush_entity");
DROP CAST IF EXISTS ("MultiPaint"."Brush_entity" AS "MultiPaint"."-ngs_Brush_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_entity";
DROP VIEW IF EXISTS "Security"."RolePermission_entity";
DROP VIEW IF EXISTS "Security"."InheritedRole_entity";
DROP VIEW IF EXISTS "Security"."Role_entity";
DROP VIEW IF EXISTS "Security"."User_entity";
DROP VIEW IF EXISTS "MultiPaint"."ChangeBrush_event";
DROP VIEW IF EXISTS "MultiPaint"."Brush_entity";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'Brushes' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE "Brushes";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'Index' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN "Index";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'Index' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE "Index";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ArtistName' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN "ArtistName";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ArtistName' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE "ArtistName";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."ChangeBrush" DROP COLUMN IF EXISTS "BrushURI";
ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE IF EXISTS "BrushesURI";

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush') THEN
		TRUNCATE TABLE "MultiPaint"."Brush";
	END IF;
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ID') THEN
		CREATE TEMP SEQUENCE _tmp_seq;
		ALTER TABLE "MultiPaint"."Brush" ADD COLUMN _tmp_key_seq BIGINT DEFAULT nextval('_tmp_seq');
		ALTER TABLE "MultiPaint"."Brush" ADD "ID" BIGINT;
		UPDATE "MultiPaint"."Brush" SET "ID" = _tmp_key_seq;
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN _temp_key_seq;
		DROP SEQUENCE _tmp_seq CASCADE;
		COMMENT ON COLUMN "MultiPaint"."Brush"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush_sequence') THEN
		CREATE SEQUENCE "MultiPaint"."Brush_sequence";
		COMMENT ON SEQUENCE "MultiPaint"."Brush_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Position_type-') THEN	
		CREATE TYPE "MultiPaint"."-ngs_Position_type-" AS ();
		COMMENT ON TYPE "MultiPaint"."-ngs_Position_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'Position') THEN	
		CREATE TYPE "MultiPaint"."Position" AS ();
		COMMENT ON TYPE "MultiPaint"."Position" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState') THEN	
		CREATE TYPE "MultiPaint"."MouseState" AS ENUM ('Move', 'Press', 'Drag', 'Release');
		COMMENT ON TYPE "MultiPaint"."MouseState" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'MouseAction') THEN	
		CREATE TABLE "MultiPaint"."MouseAction" 
		(
			event_id BIGSERIAL PRIMARY KEY,
			queued_at TIMESTAMPTZ NOT NULL DEFAULT(NOW()),
			processed_at TIMESTAMPTZ
		);
		COMMENT ON TABLE "MultiPaint"."MouseAction" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ID') THEN
		ALTER TABLE "MultiPaint"."Brush" ADD COLUMN "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."Brush"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'LastPosition') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "LastPosition" "MultiPaint"."-ngs_Position_type-";
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."LastPosition" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'LastPosition') THEN
		ALTER TABLE "MultiPaint"."Brush" ADD COLUMN "LastPosition" "MultiPaint"."Position";
		COMMENT ON COLUMN "MultiPaint"."Brush"."LastPosition" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'ChangeBrush' AND column_name = 'BrushID') THEN
		ALTER TABLE "MultiPaint"."ChangeBrush" ADD COLUMN "BrushID" BIGINT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."Position") RETURNS "MultiPaint"."-ngs_Position_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Position_type-" $$ IMMUTABLE LANGUAGE sql COST 1;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."-ngs_Position_type-") RETURNS "MultiPaint"."Position" AS $$ SELECT $1::text::"MultiPaint"."Position" $$ IMMUTABLE LANGUAGE sql COST 1;
CREATE OR REPLACE FUNCTION cast_to_text("MultiPaint"."Position") RETURNS text AS $$ SELECT $1::VARCHAR $$ IMMUTABLE LANGUAGE sql COST 1;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Position' AND t.typname = '-ngs_Position_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Position_type-" AS "MultiPaint"."Position") WITH FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."-ngs_Position_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Position" AS "MultiPaint"."-ngs_Position_type-") WITH FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."Position") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Position" AS text) WITH FUNCTION cast_to_text("MultiPaint"."Position") AS ASSIGNMENT;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Position_type-' AND column_name = 'X') THEN
		ALTER TYPE "MultiPaint"."-ngs_Position_type-" ADD ATTRIBUTE "X" INT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Position_type-"."X" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Position' AND column_name = 'X') THEN
		ALTER TYPE "MultiPaint"."Position" ADD ATTRIBUTE "X" INT;
		COMMENT ON COLUMN "MultiPaint"."Position"."X" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Position_type-' AND column_name = 'Y') THEN
		ALTER TYPE "MultiPaint"."-ngs_Position_type-" ADD ATTRIBUTE "Y" INT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Position_type-"."Y" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Position' AND column_name = 'Y') THEN
		ALTER TYPE "MultiPaint"."Position" ADD ATTRIBUTE "Y" INT;
		COMMENT ON COLUMN "MultiPaint"."Position"."Y" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND e.enumlabel = 'Move') THEN
		--ALTER TYPE "MultiPaint"."MouseState" ADD VALUE IF NOT EXISTS 'Move'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Move', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND e.enumlabel = 'Press') THEN
		--ALTER TYPE "MultiPaint"."MouseState" ADD VALUE IF NOT EXISTS 'Press'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Press', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND e.enumlabel = 'Drag') THEN
		--ALTER TYPE "MultiPaint"."MouseState" ADD VALUE IF NOT EXISTS 'Drag'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Drag', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND e.enumlabel = 'Release') THEN
		--ALTER TYPE "MultiPaint"."MouseState" ADD VALUE IF NOT EXISTS 'Release'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Release', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'MouseAction' AND column_name = 'BrushID') THEN
		ALTER TABLE "MultiPaint"."MouseAction" ADD COLUMN "BrushID" BIGINT;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'MouseAction' AND column_name = 'Index') THEN
		ALTER TABLE "MultiPaint"."MouseAction" ADD COLUMN "Index" INT;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'MouseAction' AND column_name = 'State') THEN
		ALTER TABLE "MultiPaint"."MouseAction" ADD COLUMN "State" "MultiPaint"."MouseState";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'MouseAction' AND column_name = 'Position') THEN
		ALTER TABLE "MultiPaint"."MouseAction" ADD COLUMN "Position" "MultiPaint"."-ngs_Position_type-";
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "MultiPaint"."Artist_entity" AS
SELECT CAST(_entity."Name" as TEXT) AS "URI" , _entity."Name", CAST(_entity."Name" as TEXT) AS "UserURI", _entity."CreatedAt", _entity."LastActiveAt"
FROM
	"MultiPaint"."Artist" _entity
	;
COMMENT ON VIEW "MultiPaint"."Artist_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "MultiPaint"."Brush_entity" AS
SELECT CAST(_entity."ID" as TEXT) AS "URI" , _entity."ID", CAST(_entity."ArtistID" as TEXT) AS "ArtistURI", _entity."ArtistID", _entity."Color", _entity."Thickness", _entity."LastPosition"
FROM
	"MultiPaint"."Brush" _entity
	;
COMMENT ON VIEW "MultiPaint"."Brush_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "MultiPaint"."ChangeBrush_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."Color", _event."Thickness", _event."BrushID"
FROM
	"MultiPaint"."ChangeBrush" _event
;

CREATE OR REPLACE VIEW "MultiPaint"."MouseAction_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."BrushID", _event."Index", _event."State", _event."Position"
FROM
	"MultiPaint"."MouseAction" _event
;

CREATE OR REPLACE VIEW "Security"."User_entity" AS
SELECT CAST(_entity."Name" as TEXT) AS "URI" , _entity."Name", CAST(_entity."Name" as TEXT) AS "RoleURI", _entity."PasswordHash", _entity."IsAllowed"
FROM
	"Security"."User" _entity
	;
COMMENT ON VIEW "Security"."User_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "Security"."Role_entity" AS
SELECT CAST(_entity."Name" as TEXT) AS "URI" , _entity."Name"
FROM
	"Security"."Role" _entity
	;
COMMENT ON VIEW "Security"."Role_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "Security"."InheritedRole_entity" AS
SELECT "-NGS-".Generate_Uri2(CAST(_entity."Name" as TEXT), CAST(_entity."ParentName" as TEXT)) AS "URI" , _entity."Name", CAST(_entity."Name" as TEXT) AS "RoleURI", _entity."ParentName", CAST(_entity."ParentName" as TEXT) AS "ParentRoleURI"
FROM
	"Security"."InheritedRole" _entity
	;
COMMENT ON VIEW "Security"."InheritedRole_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "Security"."RolePermission_entity" AS
SELECT "-NGS-".Generate_Uri2(CAST(_entity."Name" as TEXT), CAST(_entity."RoleID" as TEXT)) AS "URI" , _entity."Name", CAST(_entity."RoleID" as TEXT) AS "RoleURI", _entity."RoleID", _entity."IsAllowed"
FROM
	"Security"."RolePermission" _entity
	;
COMMENT ON VIEW "Security"."RolePermission_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "MultiPaint"."mark_MouseAction"(_events BIGINT[])
	RETURNS VOID AS
$$
BEGIN
	UPDATE "MultiPaint"."MouseAction" SET processed_at = now() WHERE event_id = ANY(_events) AND processed_at IS NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Artist_entity' AND t.typname = '-ngs_Artist_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity") WITH FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-") WITH FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."persist_Artist"(
IN _inserted "MultiPaint"."Artist_entity"[], IN _updated_original "MultiPaint"."Artist_entity"[], IN _updated_new "MultiPaint"."Artist_entity"[], IN _deleted "MultiPaint"."Artist_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "MultiPaint"."Artist" ("Name", "CreatedAt", "LastActiveAt")
	SELECT _i."Name", _i."CreatedAt", _i."LastActiveAt" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "MultiPaint"."Artist" as tbl SET 
		"Name" = _updated_new[_i]."Name", "CreatedAt" = _updated_new[_i]."CreatedAt", "LastActiveAt" = _updated_new[_i]."LastActiveAt"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "MultiPaint"."Artist"
	WHERE ("Name") IN (SELECT _d."Name" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "MultiPaint"."Artist_unprocessed_events" AS
SELECT _aggregate."Name"
FROM
	"MultiPaint"."Artist_entity" _aggregate
;
COMMENT ON VIEW "MultiPaint"."Artist_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "User"("MultiPaint"."Artist_entity") RETURNS "Security"."User_entity" AS $$ 
SELECT r FROM "Security"."User_entity" r WHERE r."Name" = $1."Name"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-") RETURNS "MultiPaint"."Brush_entity" AS $$ SELECT $1::text::"MultiPaint"."Brush_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity") RETURNS "MultiPaint"."-ngs_Brush_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Brush_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Brush_entity' AND t.typname = '-ngs_Brush_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Brush_type-" AS "MultiPaint"."Brush_entity") WITH FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Brush_entity" AS "MultiPaint"."-ngs_Brush_type-") WITH FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."persist_Brush"(
IN _inserted "MultiPaint"."Brush_entity"[], IN _updated_original "MultiPaint"."Brush_entity"[], IN _updated_new "MultiPaint"."Brush_entity"[], IN _deleted "MultiPaint"."Brush_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "MultiPaint"."Brush" ("ID", "ArtistID", "Color", "Thickness", "LastPosition")
	SELECT _i."ID", _i."ArtistID", _i."Color", _i."Thickness", _i."LastPosition" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "MultiPaint"."Brush" as tbl SET 
		"ID" = _updated_new[_i]."ID", "ArtistID" = _updated_new[_i]."ArtistID", "Color" = _updated_new[_i]."Color", "Thickness" = _updated_new[_i]."Thickness", "LastPosition" = _updated_new[_i]."LastPosition"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."ID" = _updated_original[_i]."ID";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "MultiPaint"."Brush"
	WHERE ("ID") IN (SELECT _d."ID" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Brush', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Brush', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Brush', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Brush', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "MultiPaint"."Brush_unprocessed_events" AS
SELECT _aggregate."ID"
FROM
	"MultiPaint"."Brush_entity" _aggregate
;
COMMENT ON VIEW "MultiPaint"."Brush_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Artist"("MultiPaint"."Brush_entity") RETURNS "MultiPaint"."Artist_entity" AS $$ 
SELECT r FROM "MultiPaint"."Artist_entity" r WHERE r."Name" = $1."ArtistID"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_ChangeBrush"(IN events "MultiPaint"."ChangeBrush_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."ChangeBrush" (queued_at, processed_at, "Color", "Thickness", "BrushID")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Color", i."Thickness", i."BrushID"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.ChangeBrush', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_MouseAction"(IN events "MultiPaint"."MouseAction_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."MouseAction" (queued_at, processed_at, "BrushID", "Index", "State", "Position")
		SELECT i."QueuedAt", i."ProcessedAt" , i."BrushID", i."Index", i."State", i."Position"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.MouseAction', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."-ngs_User_type-") RETURNS "Security"."User_entity" AS $$ SELECT $1::text::"Security"."User_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_User_to_type"("Security"."User_entity") RETURNS "Security"."-ngs_User_type-" AS $$ SELECT $1::text::"Security"."-ngs_User_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'Security' AND s.typname = 'User_entity' AND t.typname = '-ngs_User_type-') THEN
		CREATE CAST ("Security"."-ngs_User_type-" AS "Security"."User_entity") WITH FUNCTION "Security"."cast_User_to_type"("Security"."-ngs_User_type-") AS IMPLICIT;
		CREATE CAST ("Security"."User_entity" AS "Security"."-ngs_User_type-") WITH FUNCTION "Security"."cast_User_to_type"("Security"."User_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_User"(
IN _inserted "Security"."User_entity"[], IN _updated_original "Security"."User_entity"[], IN _updated_new "Security"."User_entity"[], IN _deleted "Security"."User_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."User" ("Name", "PasswordHash", "IsAllowed")
	SELECT _i."Name", _i."PasswordHash", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "Security"."User" as tbl SET 
		"Name" = _updated_new[_i]."Name", "PasswordHash" = _updated_new[_i]."PasswordHash", "IsAllowed" = _updated_new[_i]."IsAllowed"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "Security"."User"
	WHERE ("Name") IN (SELECT _d."Name" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."User_unprocessed_events" AS
SELECT _aggregate."Name"
FROM
	"Security"."User_entity" _aggregate
;
COMMENT ON VIEW "Security"."User_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Role"("Security"."User_entity") RETURNS "Security"."Role_entity" AS $$ 
SELECT r FROM "Security"."Role_entity" r WHERE r."Name" = $1."Name"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-") RETURNS "Security"."Role_entity" AS $$ SELECT $1::text::"Security"."Role_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_Role_to_type"("Security"."Role_entity") RETURNS "Security"."-ngs_Role_type-" AS $$ SELECT $1::text::"Security"."-ngs_Role_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'Security' AND s.typname = 'Role_entity' AND t.typname = '-ngs_Role_type-') THEN
		CREATE CAST ("Security"."-ngs_Role_type-" AS "Security"."Role_entity") WITH FUNCTION "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-") AS IMPLICIT;
		CREATE CAST ("Security"."Role_entity" AS "Security"."-ngs_Role_type-") WITH FUNCTION "Security"."cast_Role_to_type"("Security"."Role_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_Role"(
IN _inserted "Security"."Role_entity"[], IN _updated_original "Security"."Role_entity"[], IN _updated_new "Security"."Role_entity"[], IN _deleted "Security"."Role_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."Role" ("Name")
	SELECT _i."Name" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "Security"."Role" as tbl SET 
		"Name" = _updated_new[_i]."Name"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "Security"."Role"
	WHERE ("Name") IN (SELECT _d."Name" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."Role_unprocessed_events" AS
SELECT _aggregate."Name"
FROM
	"Security"."Role_entity" _aggregate
;
COMMENT ON VIEW "Security"."Role_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-") RETURNS "Security"."InheritedRole_entity" AS $$ SELECT $1::text::"Security"."InheritedRole_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity") RETURNS "Security"."-ngs_InheritedRole_type-" AS $$ SELECT $1::text::"Security"."-ngs_InheritedRole_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'Security' AND s.typname = 'InheritedRole_entity' AND t.typname = '-ngs_InheritedRole_type-') THEN
		CREATE CAST ("Security"."-ngs_InheritedRole_type-" AS "Security"."InheritedRole_entity") WITH FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-") AS IMPLICIT;
		CREATE CAST ("Security"."InheritedRole_entity" AS "Security"."-ngs_InheritedRole_type-") WITH FUNCTION "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_InheritedRole"(
IN _inserted "Security"."InheritedRole_entity"[], IN _updated_original "Security"."InheritedRole_entity"[], IN _updated_new "Security"."InheritedRole_entity"[], IN _deleted "Security"."InheritedRole_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."InheritedRole" ("Name", "ParentName")
	SELECT _i."Name", _i."ParentName" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "Security"."InheritedRole" as tbl SET 
		"Name" = _updated_new[_i]."Name", "ParentName" = _updated_new[_i]."ParentName"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name" AND tbl."ParentName" = _updated_original[_i]."ParentName";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "Security"."InheritedRole"
	WHERE ("Name", "ParentName") IN (SELECT _d."Name", _d."ParentName" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."InheritedRole_unprocessed_events" AS
SELECT _aggregate."Name", _aggregate."ParentName"
FROM
	"Security"."InheritedRole_entity" _aggregate
;
COMMENT ON VIEW "Security"."InheritedRole_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Role"("Security"."InheritedRole_entity") RETURNS "Security"."Role_entity" AS $$ 
SELECT r FROM "Security"."Role_entity" r WHERE r."Name" = $1."Name"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "ParentRole"("Security"."InheritedRole_entity") RETURNS "Security"."Role_entity" AS $$ 
SELECT r FROM "Security"."Role_entity" r WHERE r."Name" = $1."ParentName"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-") RETURNS "Security"."RolePermission_entity" AS $$ SELECT $1::text::"Security"."RolePermission_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity") RETURNS "Security"."-ngs_RolePermission_type-" AS $$ SELECT $1::text::"Security"."-ngs_RolePermission_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'Security' AND s.typname = 'RolePermission_entity' AND t.typname = '-ngs_RolePermission_type-') THEN
		CREATE CAST ("Security"."-ngs_RolePermission_type-" AS "Security"."RolePermission_entity") WITH FUNCTION "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-") AS IMPLICIT;
		CREATE CAST ("Security"."RolePermission_entity" AS "Security"."-ngs_RolePermission_type-") WITH FUNCTION "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_RolePermission"(
IN _inserted "Security"."RolePermission_entity"[], IN _updated_original "Security"."RolePermission_entity"[], IN _updated_new "Security"."RolePermission_entity"[], IN _deleted "Security"."RolePermission_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."RolePermission" ("Name", "RoleID", "IsAllowed")
	SELECT _i."Name", _i."RoleID", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "Security"."RolePermission" as tbl SET 
		"Name" = _updated_new[_i]."Name", "RoleID" = _updated_new[_i]."RoleID", "IsAllowed" = _updated_new[_i]."IsAllowed"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name" AND tbl."RoleID" = _updated_original[_i]."RoleID";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "Security"."RolePermission"
	WHERE ("Name", "RoleID") IN (SELECT _d."Name", _d."RoleID" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."RolePermission_unprocessed_events" AS
SELECT _aggregate."Name", _aggregate."RoleID"
FROM
	"Security"."RolePermission_entity" _aggregate
;
COMMENT ON VIEW "Security"."RolePermission_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Role"("Security"."RolePermission_entity") RETURNS "Security"."Role_entity" AS $$ 
SELECT r FROM "Security"."Role_entity" r WHERE r."Name" = $1."RoleID"
$$ LANGUAGE SQL;
COMMENT ON VIEW "MultiPaint"."ChangeBrush_event" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Position_to_type"("MultiPaint"."-ngs_Position_type-")', 'MultiPaint', '-ngs_Position_type-', 'Position');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Position_to_type"("MultiPaint"."Position")', 'MultiPaint', 'Position', '-ngs_Position_type-');
COMMENT ON VIEW "MultiPaint"."MouseAction_event" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-")', 'MultiPaint', '-ngs_Artist_type-', 'Artist_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity")', 'MultiPaint', 'Artist_entity', '-ngs_Artist_type-');

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-")', 'MultiPaint', '-ngs_Brush_type-', 'Brush_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity")', 'MultiPaint', 'Brush_entity', '-ngs_Brush_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_User_to_type"("Security"."-ngs_User_type-")', 'Security', '-ngs_User_type-', 'User_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_User_to_type"("Security"."User_entity")', 'Security', 'User_entity', '-ngs_User_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_Role_to_type"("Security"."-ngs_Role_type-")', 'Security', '-ngs_Role_type-', 'Role_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_Role_to_type"("Security"."Role_entity")', 'Security', 'Role_entity', '-ngs_Role_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-")', 'Security', '-ngs_InheritedRole_type-', 'InheritedRole_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity")', 'Security', 'InheritedRole_entity', '-ngs_InheritedRole_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-")', 'Security', '-ngs_RolePermission_type-', 'RolePermission_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity")', 'Security', 'RolePermission_entity', '-ngs_RolePermission_type-');
UPDATE "MultiPaint"."Brush" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "MultiPaint"."Brush" SET "LastPosition" = ROW(NULL,NULL) WHERE "LastPosition"::TEXT IS NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_MouseAction') THEN
		CREATE INDEX "ix_unprocessed_events_MultiPaint_MouseAction" ON "MultiPaint"."MouseAction" (event_id) WHERE processed_at IS NULL;
		COMMENT ON INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_MouseAction" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'MultiPaint' AND c.relname = 'Brush') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"MultiPaint"."Brush"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('ID' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table MultiPaint.Brush. Expected primary key: ID. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "MultiPaint"."Brush" ADD CONSTRAINT "pk_Brush" PRIMARY KEY("ID");
		COMMENT ON CONSTRAINT "pk_Brush" ON "MultiPaint"."Brush" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Brush" ALTER "ID" SET NOT NULL;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush_ID_seq' AND c.relkind = 'S') THEN
		CREATE SEQUENCE "MultiPaint"."Brush_ID_seq";
		ALTER TABLE "MultiPaint"."Brush"	ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"MultiPaint"."Brush_ID_seq"');
		PERFORM SETVAL('"MultiPaint"."Brush_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "MultiPaint"."Brush";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Artist' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush') THEN	
		ALTER TABLE "MultiPaint"."Brush" 
			ADD CONSTRAINT "fk_Artist"
				FOREIGN KEY ("ArtistID") REFERENCES "MultiPaint"."Artist" ("Name")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Artist" ON "MultiPaint"."Brush" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Brush" ALTER "LastPosition" SET NOT NULL;

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
	/* Each visitor creates a new Artist */
	aggregate Artist(Name) {
		String(100)          Name;
		Security.User(Name)  *User;

		Timestamp  CreatedAt { sequence; }
		Timestamp  LastActiveAt { versioning; }
	}
	
	/* Artists create Brushes in order to draw */
	big aggregate Brush {
		Artist    *Artist;
		String    Color;
		Int       Thickness;
		Position  LastPosition;
	}

	/* request for a new brush */
	event ChangeBrush {
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

*/
	enum MouseState {
		Move; Press; Drag; Release;
	}

	/* mouse actions create brush segments */
	event MouseAction {
		Long        BrushID;
		Int         Index;
		MouseState  State;
		Position    Position;
	}
}
","d:\\Code\\multipaint\\dsl\\Security.dsl"=>"module Security
{
	permissions
	{
		filter Role	''it => it.Name == Thread.CurrentPrincipal.Identity.Name'' except Administrator;
		filter User	''it => it.Name == Thread.CurrentPrincipal.Identity.Name'' except Administrator;
	} 

	role Administrator;
	role Artist;
	role Guest;
	
	aggregate User(Name) {
		String(100)  Name;
		Role(Name)   *Role;
		Binary       PasswordHash;
		Boolean      IsAllowed;
		implements server ''Revenj.Security.IUser, Revenj.Security'';
	}

	aggregate Role(Name) {
		String(100)  Name;
		static Artist ''Artist'';
	}

	aggregate InheritedRole(Name, ParentName) {
		String(100)       Name;
		Role(Name)        *Role;
		String(100)       ParentName;
		Role(ParentName)  *ParentRole;
		implements server ''Revenj.Security.IUserRoles, Revenj.Security'';
	}

	aggregate GlobalPermission(Name) {
		String(200)  Name;
		bool         IsAllowed;
		implements server ''Revenj.Security.IGlobalPermission, Revenj.Security'';
	}

	aggregate RolePermission(Name, RoleID) {
		String(200)  Name;
		Role         *Role;
		bool         IsAllowed;
		implements server ''Revenj.Security.IRolePermission, Revenj.Security'';
	}
}

server code <#
namespace Revenj
{
	using System;
	using Revenj.DomainPatterns;
	using Revenj.Extensibility;
	using System.ComponentModel.Composition;
	using SecUser = global::Security.User;

	[Export(typeof(ISystemAspect))]
	internal class SecurityHelperInitializer : ISystemAspect
	{
		public void Initialize(IObjectFactory factory)
		{
			SecurityHelper.Repository = new Lazy<IDataCache<SecUser>>(() => factory.Resolve<IDataCache<SecUser>>());
		}
	}

	public static partial class SecurityHelper
	{
		internal static Lazy<IDataCache<SecUser>> Repository;

		public static SecUser GetUser(this System.Security.Principal.IPrincipal principal)
		{
			return Repository.Value.Find(principal.Identity.Name);
		}
	}
}
#>;
"', '\x','1.0.3.34768')