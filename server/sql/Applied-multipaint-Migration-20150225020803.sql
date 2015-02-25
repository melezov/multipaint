/*MIGRATION_DESCRIPTION
--REMOVE: MultiPaint-MouseAction-Position
Property Position will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseAction-State
Property State will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseAction-Index
Property Index will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseAction-BrushID
Property BrushID will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseAction-Session
Property Session will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseAction
Object MouseAction will be removed from schema MultiPaint
--REMOVE: MultiPaint-MouseState-Release
Enum label Release will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Drag
Enum label Drag will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Press
Enum label Press will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState
Object MouseState will be removed from schema MultiPaint
--REMOVE: MultiPaint-Segment-OccurredAt
Property OccurredAt will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment-Position
Property Position will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment-State
Property State will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment-Index
Property Index will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment-BrushID
Property BrushID will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment-ID
Property ID will be removed from object Segment in schema MultiPaint
--REMOVE: MultiPaint-Segment
Object Segment will be removed from schema MultiPaint
--REMOVE: MultiPaint-Position-Y
Property Y will be removed from object Position in schema MultiPaint
--REMOVE: MultiPaint-Position-X
Property X will be removed from object Position in schema MultiPaint
--REMOVE: MultiPaint-Position
Object Position will be removed from schema MultiPaint
--REMOVE: MultiPaint-ChangeBrush-BrushID
Property BrushID will be removed from object ChangeBrush in schema MultiPaint
--REMOVE: MultiPaint-ChangeBrush-Color
Property Color will be removed from object ChangeBrush in schema MultiPaint
--REMOVE: MultiPaint-ChangeBrush-Session
Property Session will be removed from object ChangeBrush in schema MultiPaint
--REMOVE: MultiPaint-ChangeBrush
Object ChangeBrush will be removed from schema MultiPaint
--REMOVE: MultiPaint-Brush-Color
Property Color will be removed from object Brush in schema MultiPaint
--REMOVE: MultiPaint-Brush-ArtistID
Property ArtistID will be removed from object Brush in schema MultiPaint
--REMOVE: MultiPaint-Brush-ID
Property ID will be removed from object Brush in schema MultiPaint
--REMOVE: MultiPaint-Brush
Object Brush will be removed from schema MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Brush' AND n.nspname = 'MultiPaint' AND r.relname = 'Segment' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Segment" DROP CONSTRAINT "fk_Brush";
	END IF;
END $$ LANGUAGE plpgsql;

ALTER TABLE "MultiPaint"."Segment"	ALTER COLUMN "ID" SET DEFAULT NULL;
DROP SEQUENCE IF EXISTS "MultiPaint"."Segment_ID_seq";;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'uq_ngs_uri_Segment' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."uq_ngs_uri_Segment";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'fk_Artist' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Brush" DROP CONSTRAINT "fk_Artist";
	END IF;
END $$ LANGUAGE plpgsql;

ALTER TABLE "MultiPaint"."Brush"	ALTER COLUMN "ID" SET DEFAULT NULL;
DROP SEQUENCE IF EXISTS "MultiPaint"."Brush_ID_seq";;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_Segment' AND n.nspname = 'MultiPaint' AND r.relname = 'Segment' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Segment" DROP CONSTRAINT "pk_Segment";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_Brush' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Brush" DROP CONSTRAINT "pk_Brush";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_MouseAction' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_MouseAction";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_ChangeBrush' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_ChangeBrush";
	END IF;
END $$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS "MultiPaint"."Drawing.GetFromID"(BIGINT);
DROP FUNCTION IF EXISTS "MultiPaint"."Drawing.GetFromID"("MultiPaint"."Drawing_snowflake", BIGINT);

DROP OPERATOR IF EXISTS = ("MultiPaint"."Drawing_snowflake", "MultiPaint"."Segment_entity");
DROP OPERATOR IF EXISTS = ("MultiPaint"."Segment_entity", "MultiPaint"."Drawing_snowflake");

DROP FUNCTION IF EXISTS "MultiPaint"."compare_Segment_snowflake_and_entity"("MultiPaint"."Drawing_snowflake", "MultiPaint"."Segment_entity");
DROP FUNCTION IF EXISTS "MultiPaint"."compare_Segment_entity_and_snowflake"("MultiPaint"."Segment_entity", "MultiPaint"."Drawing_snowflake");

DROP CAST IF EXISTS ("MultiPaint"."Drawing_snowflake" AS "MultiPaint"."-ngs_Drawing_type-");
DROP CAST IF EXISTS ("MultiPaint"."-ngs_Drawing_type-" AS "MultiPaint"."Drawing_snowflake");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."-ngs_Drawing_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."Drawing_snowflake");

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."-ngs_Segment_type-") RETURNS "MultiPaint"."Segment_entity" AS $$ SELECT $1::text::"MultiPaint"."Segment_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."Segment_entity") RETURNS "MultiPaint"."-ngs_Segment_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Segment_type-" $$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-") RETURNS "MultiPaint"."Brush_entity" AS $$ SELECT $1::text::"MultiPaint"."Brush_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity") RETURNS "MultiPaint"."-ngs_Brush_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Brush_type-" $$ IMMUTABLE LANGUAGE sql;

DROP FUNCTION IF EXISTS "MultiPaint"."Artist.GetArtistBySession"(UUID);
DROP FUNCTION IF EXISTS "MultiPaint"."Artist.GetArtistBySession"("MultiPaint"."Artist_entity", UUID);

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;
DROP VIEW IF EXISTS "MultiPaint"."Drawing_snowflake";

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."Position") RETURNS "MultiPaint"."-ngs_Position_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Position_type-" $$ IMMUTABLE LANGUAGE sql COST 1;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Position_to_type"("MultiPaint"."-ngs_Position_type-") RETURNS "MultiPaint"."Position" AS $$ SELECT $1::text::"MultiPaint"."Position" $$ IMMUTABLE LANGUAGE sql COST 1;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_MouseAction"("MultiPaint"."MouseAction_event"[]);
DROP FUNCTION IF EXISTS "Brush"("MultiPaint"."Segment_entity");
DROP VIEW IF EXISTS "MultiPaint"."Segment_unprocessed_events";

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Segment"("MultiPaint"."Segment_entity"[], "MultiPaint"."Segment_entity"[], "MultiPaint"."Segment_entity"[], "MultiPaint"."Segment_entity"[]);;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Segment_type-" AS "MultiPaint"."Segment_entity");
DROP CAST IF EXISTS ("MultiPaint"."Segment_entity" AS "MultiPaint"."-ngs_Segment_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Segment_to_type"("MultiPaint"."-ngs_Segment_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Segment_to_type"("MultiPaint"."Segment_entity");
DROP FUNCTION IF EXISTS "MultiPaint"."submit_ChangeBrush"("MultiPaint"."ChangeBrush_event"[]);
DROP FUNCTION IF EXISTS "Artist"("MultiPaint"."Brush_entity");
DROP VIEW IF EXISTS "MultiPaint"."Brush_unprocessed_events";

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Brush"("MultiPaint"."Brush_entity"[], "MultiPaint"."Brush_entity"[], "MultiPaint"."Brush_entity"[], "MultiPaint"."Brush_entity"[]);;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Brush_type-" AS "MultiPaint"."Brush_entity");
DROP CAST IF EXISTS ("MultiPaint"."Brush_entity" AS "MultiPaint"."-ngs_Brush_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_unprocessed_events";

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist"("MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[]);;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity");
DROP CAST IF EXISTS ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity");
DROP FUNCTION IF EXISTS "MultiPaint"."mark_MouseAction"(BIGINT[]);
DROP FUNCTION IF EXISTS "MultiPaint"."mark_ChangeBrush"(BIGINT[]);
DROP VIEW IF EXISTS "MultiPaint"."MouseAction_event";
DROP VIEW IF EXISTS "MultiPaint"."Segment_entity";
DROP VIEW IF EXISTS "MultiPaint"."ChangeBrush_event";
DROP VIEW IF EXISTS "MultiPaint"."Brush_entity";
DROP VIEW IF EXISTS "MultiPaint"."Artist_entity";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "Position";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "State";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "Index";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "BrushID";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "Session";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "Position";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "State";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "Index";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "BrushID";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "Color";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "ID";
ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'OccurredAt' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "OccurredAt";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'OccurredAt' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "OccurredAt";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'Position' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "Position";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'Position' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "Position";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'State' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "State";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'State' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "State";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'Index' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "Index";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'Index' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "Index";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'BrushID' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "BrushID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'BrushID' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "BrushID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE IF EXISTS "BrushURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Segment" DROP COLUMN "ID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE "ID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "MultiPaint"."-ngs_Segment_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Position' AND column_name = 'Y' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."Position" DROP ATTRIBUTE "Y";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Position_type-' AND column_name = 'Y' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Position_type-" DROP ATTRIBUTE "Y";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Position' AND column_name = 'X' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."Position" DROP ATTRIBUTE "X";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Position_type-' AND column_name = 'X' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Position_type-" DROP ATTRIBUTE "X";
	END IF;
END $$ LANGUAGE plpgsql;

DROP CAST IF EXISTS ("MultiPaint"."Position" AS text);
DROP CAST IF EXISTS ("MultiPaint"."Position" AS "MultiPaint"."-ngs_Position_type-");
DROP CAST IF EXISTS ("MultiPaint"."-ngs_Position_type-" AS "MultiPaint"."Position");
DROP FUNCTION IF EXISTS cast_to_text("MultiPaint"."Position");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Position_to_type"("MultiPaint"."Position");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Position_to_type"("MultiPaint"."-ngs_Position_type-");
ALTER TABLE "MultiPaint"."ChangeBrush" DROP COLUMN IF EXISTS "BrushID";
ALTER TABLE "MultiPaint"."ChangeBrush" DROP COLUMN IF EXISTS "Color";
ALTER TABLE "MultiPaint"."ChangeBrush" DROP COLUMN IF EXISTS "Session";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'Color' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN "Color";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'Color' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE "Color";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ArtistID' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN "ArtistID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ArtistID' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE "ArtistID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE IF EXISTS "ArtistURI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Brush" DROP COLUMN "ID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE "ID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "MultiPaint"."-ngs_Brush_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'MouseAction' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."MouseAction";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."MouseState";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Drawing_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."-ngs_Drawing_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Segment_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "MultiPaint"."Segment_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Segment' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."Segment";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Segment_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."-ngs_Segment_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = 'Position' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."Position";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Position_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."-ngs_Position_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'ChangeBrush' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."ChangeBrush";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "MultiPaint"."Brush_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."Brush";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Brush_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."-ngs_Brush_type-";
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "MultiPaint"."Artist_entity" AS
SELECT CAST(_entity."ID" as TEXT) AS "URI" , _entity."ID", _entity."Name", _entity."Session", _entity."CreatedAt"
FROM
	"MultiPaint"."Artist" _entity
	;
COMMENT ON VIEW "MultiPaint"."Artist_entity" IS 'NGS volatile';

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

	

	INSERT INTO "MultiPaint"."Artist" ("ID", "Name", "Session", "CreatedAt")
	SELECT _i."ID", _i."Name", _i."Session", _i."CreatedAt" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "MultiPaint"."Artist" as tbl SET 
		"ID" = _updated_new[_i]."ID", "Name" = _updated_new[_i]."Name", "Session" = _updated_new[_i]."Session", "CreatedAt" = _updated_new[_i]."CreatedAt"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."ID" = _updated_original[_i]."ID";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "MultiPaint"."Artist"
	WHERE ("ID") IN (SELECT _d."ID" FROM unnest(_deleted) _d);

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
SELECT _aggregate."ID"
FROM
	"MultiPaint"."Artist_entity" _aggregate
;
COMMENT ON VIEW "MultiPaint"."Artist_unprocessed_events" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-")', 'MultiPaint', '-ngs_Artist_type-', 'Artist_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity")', 'MultiPaint', 'Artist_entity', '-ngs_Artist_type-');
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.GetArtistBySession"("it" "MultiPaint"."Artist_entity", "Session" UUID) RETURNS BOOL AS 
$$
	SELECT 	 ((("it"))."Session" = "Artist.GetArtistBySession"."Session") 
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.GetArtistBySession"("Session" UUID) RETURNS SETOF "MultiPaint"."Artist_entity" AS 
$$SELECT * FROM "MultiPaint"."Artist_entity" "it"  WHERE 	 ((("it"))."Session" = "Artist.GetArtistBySession"."Session") 
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

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
","d:\\Code\\multipaint\\dsl\\Security.dsl"=>"module Security
{
	aggregate User(Name) {
		String(100)  Name;
		Role(Name)   *Role;
		Binary       PasswordHash;
		Boolean      IsAllowed;
		implements server ''Revenj.Security.IUser, Revenj.Security'';
	}

	aggregate Role(Name) {
		String(100)  Name;
	}

	aggregate InheritedRole(Name, ParentName) {
		String(100)       Name;
		Role(Name)        *Role;
		String(100)       ParentName;
		Role(ParentName)  *ParentRole;
		implements server ''Revenj.Security.IUserRoles, Revenj.Security'';
	}

	role Administrator;

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