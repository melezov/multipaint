/*MIGRATION_DESCRIPTION
--CREATE: MultiPaint-Artist
New object Artist will be created in schema MultiPaint
--CREATE: MultiPaint-Artist-ID
New property ID will be created for Artist in MultiPaint
--CREATE: MultiPaint-Artist-Name
New property Name will be created for Artist in MultiPaint
--CREATE: MultiPaint-Artist-Session
New property Session will be created for Artist in MultiPaint
--CREATE: MultiPaint-Artist-CreatedAt
New property CreatedAt will be created for Artist in MultiPaint
--CREATE: MultiPaint-Brush
New object Brush will be created in schema MultiPaint
--CREATE: MultiPaint-Brush-ID
New property ID will be created for Brush in MultiPaint
--CREATE: MultiPaint-Brush-ArtistID
New property ArtistID will be created for Brush in MultiPaint
--CREATE: MultiPaint-Brush-Color
New property Color will be created for Brush in MultiPaint
--CREATE: MultiPaint-ChangeBrush
New object ChangeBrush will be created in schema MultiPaint
--CREATE: MultiPaint-ChangeBrush-Session
New property Session will be created for ChangeBrush in MultiPaint
--CREATE: MultiPaint-ChangeBrush-Color
New property Color will be created for ChangeBrush in MultiPaint
--CREATE: MultiPaint-ChangeBrush-BrushID
New property BrushID will be created for ChangeBrush in MultiPaint
--CREATE: MultiPaint-Position
New object Position will be created in schema MultiPaint
--CREATE: MultiPaint-Position-X
New property X will be created for Position in MultiPaint
--CREATE: MultiPaint-Position-Y
New property Y will be created for Position in MultiPaint
--CREATE: MultiPaint-Segment
New object Segment will be created in schema MultiPaint
--CREATE: MultiPaint-Segment-ID
New property ID will be created for Segment in MultiPaint
--CREATE: MultiPaint-Segment-BrushID
New property BrushID will be created for Segment in MultiPaint
--CREATE: MultiPaint-Segment-Index
New property Index will be created for Segment in MultiPaint
--CREATE: MultiPaint-Segment-State
New property State will be created for Segment in MultiPaint
--CREATE: MultiPaint-Segment-Position
New property Position will be created for Segment in MultiPaint
--CREATE: MultiPaint-Segment-OccurredAt
New property OccurredAt will be created for Segment in MultiPaint
--CREATE: MultiPaint-MouseState
New object MouseState will be created in schema MultiPaint
--CREATE: MultiPaint-MouseState-Press
New enum label Press will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseState-Drag
New enum label Drag will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseState-Release
New enum label Release will be added to enum object MouseState in schema MultiPaint
--CREATE: MultiPaint-MouseAction
New object MouseAction will be created in schema MultiPaint
--CREATE: MultiPaint-MouseAction-Session
New property Session will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-BrushID
New property BrushID will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-Index
New property Index will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-State
New property State will be created for MouseAction in MultiPaint
--CREATE: MultiPaint-MouseAction-Position
New property Position will be created for MouseAction in MultiPaint
--CREATE: Security-User
New object User will be created in schema Security
--CREATE: Security-User-Name
New property Name will be created for User in Security
--CREATE: Security-User-PasswordHash
New property PasswordHash will be created for User in Security
--CREATE: Security-User-IsAllowed
New property IsAllowed will be created for User in Security
--CREATE: Security-Role
New object Role will be created in schema Security
--CREATE: Security-Role-Name
New property Name will be created for Role in Security
--CREATE: Security-InheritedRole
New object InheritedRole will be created in schema Security
--CREATE: Security-InheritedRole-Name
New property Name will be created for InheritedRole in Security
--CREATE: Security-InheritedRole-ParentName
New property ParentName will be created for InheritedRole in Security
--CREATE: Security-GlobalPermission
New object GlobalPermission will be created in schema Security
--CREATE: Security-GlobalPermission-Name
New property Name will be created for GlobalPermission in Security
--CREATE: Security-GlobalPermission-IsAllowed
New property IsAllowed will be created for GlobalPermission in Security
--CREATE: Security-RolePermission
New object RolePermission will be created in schema Security
--CREATE: Security-RolePermission-Name
New property Name will be created for RolePermission in Security
--CREATE: Security-RolePermission-RoleID
New property RoleID will be created for RolePermission in Security
--CREATE: Security-RolePermission-IsAllowed
New property IsAllowed will be created for RolePermission in Security
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$
DECLARE script VARCHAR;
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = '-NGS-') THEN
		CREATE SCHEMA "-NGS-";
		COMMENT ON SCHEMA "-NGS-" IS 'NGS generated';
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'public') THEN
		CREATE SCHEMA public;
		COMMENT ON SCHEMA public IS 'NGS generated';
	END IF;
	SELECT array_to_string(array_agg('DROP VIEW IF EXISTS ' || quote_ident(n.nspname) || '.' || quote_ident(cl.relname) || ' CASCADE;'), '')
	INTO script
	FROM pg_class cl
	INNER JOIN pg_namespace n ON cl.relnamespace = n.oid
	INNER JOIN pg_description d ON d.objoid = cl.oid
	WHERE cl.relkind = 'v' AND d.description LIKE 'NGS volatile%';
	IF length(script) > 0 THEN
		EXECUTE script;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS "-NGS-".Database_Migration
(
	Ordinal SERIAL PRIMARY KEY,
	Dsls TEXT,
	Implementations BYTEA,
	Version VARCHAR,
	Applied_At TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP)
);

CREATE OR REPLACE FUNCTION "-NGS-".Load_Last_Migration()
RETURNS "-NGS-".Database_Migration AS
$$
SELECT m FROM "-NGS-".Database_Migration m
ORDER BY Ordinal DESC 
LIMIT 1
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Persist_Concepts(dsls TEXT, implementations BYTEA, version VARCHAR)
  RETURNS void AS
$$
BEGIN
	INSERT INTO "-NGS-".Database_Migration(Dsls, Implementations, Version) VALUES(dsls, implementations, version);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "-NGS-".Generate_Uri2(text, text) RETURNS text AS 
$$
BEGIN
	RETURN replace(replace($1, '\','\\'), '/', '\/')||'/'||replace(replace($2, '\','\\'), '/', '\/');
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Generate_Uri3(text, text, text) RETURNS text AS 
$$
BEGIN
	RETURN replace(replace($1, '\','\\'), '/', '\/')||'/'||replace(replace($2, '\','\\'), '/', '\/')||'/'||replace(replace($3, '\','\\'), '/', '\/');
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Generate_Uri4(text, text, text, text) RETURNS text AS 
$$
BEGIN
	RETURN replace(replace($1, '\','\\'), '/', '\/')||'/'||replace(replace($2, '\','\\'), '/', '\/')||'/'||replace(replace($3, '\','\\'), '/', '\/')||'/'||replace(replace($4, '\','\\'), '/', '\/');
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Generate_Uri5(text, text, text, text, text) RETURNS text AS 
$$
BEGIN
	RETURN replace(replace($1, '\','\\'), '/', '\/')||'/'||replace(replace($2, '\','\\'), '/', '\/')||'/'||replace(replace($3, '\','\\'), '/', '\/')||'/'||replace(replace($4, '\','\\'), '/', '\/')||'/'||replace(replace($5, '\','\\'), '/', '\/');
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Generate_Uri(text[]) RETURNS text AS 
$$
BEGIN
	RETURN (SELECT array_to_string(array_agg(replace(replace(u, '\','\\'), '/', '\/')), '/') FROM unnest($1) u);
END;
$$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Safe_Notify(target varchar, name varchar, operation varchar, uris varchar[]) RETURNS VOID AS
$$
DECLARE message VARCHAR;
DECLARE array_size INT;
BEGIN
	array_size = array_upper(uris, 1);
	message = name || ':' || operation || ':' || uris::TEXT;
	IF (array_size > 0 and length(message) < 8000) THEN 
		PERFORM pg_notify(target, message);
	ELSEIF (array_size > 1) THEN
		PERFORM "-NGS-".Safe_Notify(target, name, operation, (SELECT array_agg(uris[i]) FROM generate_series(1, (array_size+1)/2) i));
		PERFORM "-NGS-".Safe_Notify(target, name, operation, (SELECT array_agg(uris[i]) FROM generate_series(array_size/2+1, array_size) i));
	ELSEIF (array_size = 1) THEN
		RAISE EXCEPTION 'uri can''t be longer than 8000 characters';
	END IF;	
END
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "-NGS-".Split_Uri(s text) RETURNS TEXT[] AS
$$
DECLARE i int;
DECLARE pos int;
DECLARE len int;
DECLARE res TEXT[];
DECLARE cur TEXT;
DECLARE c CHAR(1);
BEGIN
	pos = 0;
	i = 1;
	cur = '';
	len = length(s);
	LOOP
		pos = pos + 1;
		EXIT WHEN pos > len;
		c = substr(s, pos, 1);
		IF c = '/' THEN
			res[i] = cur;
			i = i + 1;
			cur = '';
		ELSE
			IF c = '\' THEN
				pos = pos + 1;
				c = substr(s, pos, 1);
			END IF;		
			cur = cur || c;
		END IF;
	END LOOP;
	res[i] = cur;
	return res;
END
$$ LANGUAGE plpgsql SECURITY DEFINER IMMUTABLE;

CREATE OR REPLACE FUNCTION "-NGS-".Load_Type_Info(
	OUT type_schema character varying, 
	OUT type_name character varying, 
	OUT column_name character varying, 
	OUT column_schema character varying,
	OUT column_type character varying, 
	OUT column_index smallint, 
	OUT is_not_null boolean,
	OUT is_ngs_generated boolean)
  RETURNS SETOF record AS
$BODY$
SELECT 
	ns.nspname::varchar, 
	cl.relname::varchar, 
	atr.attname::varchar, 
	ns_ref.nspname::varchar,
	typ.typname::varchar, 
	(SELECT COUNT(*) + 1
	FROM pg_attribute atr_ord
	WHERE 
		atr.attrelid = atr_ord.attrelid
		AND atr_ord.attisdropped = false
		AND atr_ord.attnum > 0
		AND atr_ord.attnum < atr.attnum)::smallint, 
	atr.attnotnull,
	coalesce(d.description LIKE 'NGS generated%', false)
FROM 
	pg_attribute atr
	INNER JOIN pg_class cl ON atr.attrelid = cl.oid
	INNER JOIN pg_namespace ns ON cl.relnamespace = ns.oid
	INNER JOIN pg_type typ ON atr.atttypid = typ.oid
	INNER JOIN pg_namespace ns_ref ON typ.typnamespace = ns_ref.oid
	LEFT JOIN pg_description d ON d.objoid = cl.oid
								AND d.objsubid = atr.attnum
WHERE
	(cl.relkind = 'r' OR cl.relkind = 'v' OR cl.relkind = 'c')
	AND ns.nspname NOT LIKE 'pg_%'
	AND ns.nspname != 'information_schema'
	AND atr.attnum > 0
	AND atr.attisdropped = FALSE
ORDER BY 1, 2, 6
$BODY$
  LANGUAGE SQL STABLE;

CREATE TABLE IF NOT EXISTS "-NGS-".Database_Setting
(
	Key VARCHAR PRIMARY KEY,
	Value TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION "-NGS-".Create_Type_Cast(function VARCHAR, schema VARCHAR, from_name VARCHAR, to_name VARCHAR)
RETURNS void
AS
$$
DECLARE header VARCHAR;
DECLARE source VARCHAR;
DECLARE footer VARCHAR;
DECLARE col_name VARCHAR;
DECLARE type VARCHAR = '"' || schema || '"."' || to_name || '"';
BEGIN
	header = 'CREATE OR REPLACE FUNCTION ' || function || '
RETURNS ' || type || '
AS
$BODY$
SELECT ROW(';
	footer = ')::' || type || '
$BODY$ IMMUTABLE LANGUAGE sql;';
	source = '';
	FOR col_name IN 
		SELECT 
			CASE WHEN 
				EXISTS (SELECT * FROM "-NGS-".Load_Type_Info() f 
					WHERE f.type_schema = schema AND f.type_name = from_name AND f.column_name = t.column_name)
				OR EXISTS(SELECT * FROM pg_proc p JOIN pg_type t_in ON p.proargtypes[0] = t_in.oid 
					JOIN pg_namespace n_in ON t_in.typnamespace = n_in.oid JOIN pg_namespace n ON p.pronamespace = n.oid
					WHERE array_upper(p.proargtypes, 1) = 0 AND n.nspname = 'public' AND t_in.typname = from_name AND p.proname = t.column_name) THEN t.column_name
				ELSE null
			END
		FROM "-NGS-".Load_Type_Info() t
		WHERE 
			t.type_schema = schema 
			AND t.type_name = to_name
		ORDER BY t.column_index 
	LOOP
		IF col_name IS NULL THEN
			source = source || 'null, ';
		ELSE
			source = source || '$1."' || col_name || '", ';
		END IF;
	END LOOP;
	IF (LENGTH(source) > 0) THEN 
		source = SUBSTRING(source, 1, LENGTH(source) - 2);
	END IF;
	EXECUTE (header || source || footer);
END
$$ LANGUAGE plpgsql;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'MultiPaint') THEN
		CREATE SCHEMA "MultiPaint";
		COMMENT ON SCHEMA "MultiPaint" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'Security') THEN
		CREATE SCHEMA "Security";
		COMMENT ON SCHEMA "Security" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Artist_type-') THEN	
		CREATE TYPE "MultiPaint"."-ngs_Artist_type-" AS ();
		COMMENT ON TYPE "MultiPaint"."-ngs_Artist_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist') THEN	
		CREATE TABLE "MultiPaint"."Artist" ();
		COMMENT ON TABLE "MultiPaint"."Artist" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist_sequence') THEN
		CREATE SEQUENCE "MultiPaint"."Artist_sequence";
		COMMENT ON SEQUENCE "MultiPaint"."Artist_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Brush_type-') THEN	
		CREATE TYPE "MultiPaint"."-ngs_Brush_type-" AS ();
		COMMENT ON TYPE "MultiPaint"."-ngs_Brush_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush') THEN	
		CREATE TABLE "MultiPaint"."Brush" ();
		COMMENT ON TABLE "MultiPaint"."Brush" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush_sequence') THEN
		CREATE SEQUENCE "MultiPaint"."Brush_sequence";
		COMMENT ON SEQUENCE "MultiPaint"."Brush_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'ChangeBrush') THEN	
		CREATE TABLE "MultiPaint"."ChangeBrush" 
		(
			event_id BIGSERIAL PRIMARY KEY,
			queued_at TIMESTAMPTZ NOT NULL DEFAULT(NOW()),
			processed_at TIMESTAMPTZ
		);
		COMMENT ON TABLE "MultiPaint"."ChangeBrush" IS 'NGS generated';
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
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Segment_type-') THEN	
		CREATE TYPE "MultiPaint"."-ngs_Segment_type-" AS ();
		COMMENT ON TYPE "MultiPaint"."-ngs_Segment_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Segment') THEN	
		CREATE TABLE "MultiPaint"."Segment" ();
		COMMENT ON TABLE "MultiPaint"."Segment" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'Segment_sequence') THEN
		CREATE SEQUENCE "MultiPaint"."Segment_sequence";
		COMMENT ON SEQUENCE "MultiPaint"."Segment_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Drawing_type-') THEN	
		CREATE TYPE "MultiPaint"."-ngs_Drawing_type-" AS ();
		COMMENT ON TYPE "MultiPaint"."-ngs_Drawing_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState') THEN	
		CREATE TYPE "MultiPaint"."MouseState" AS ENUM ('Press', 'Drag', 'Release');
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
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_User_type-') THEN	
		CREATE TYPE "Security"."-ngs_User_type-" AS ();
		COMMENT ON TYPE "Security"."-ngs_User_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'User') THEN	
		CREATE TABLE "Security"."User" ();
		COMMENT ON TABLE "Security"."User" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'User_sequence') THEN
		CREATE SEQUENCE "Security"."User_sequence";
		COMMENT ON SEQUENCE "Security"."User_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_Role_type-') THEN	
		CREATE TYPE "Security"."-ngs_Role_type-" AS ();
		COMMENT ON TYPE "Security"."-ngs_Role_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'Role') THEN	
		CREATE TABLE "Security"."Role" ();
		COMMENT ON TABLE "Security"."Role" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'Role_sequence') THEN
		CREATE SEQUENCE "Security"."Role_sequence";
		COMMENT ON SEQUENCE "Security"."Role_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_InheritedRole_type-') THEN	
		CREATE TYPE "Security"."-ngs_InheritedRole_type-" AS ();
		COMMENT ON TYPE "Security"."-ngs_InheritedRole_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'InheritedRole') THEN	
		CREATE TABLE "Security"."InheritedRole" ();
		COMMENT ON TABLE "Security"."InheritedRole" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'InheritedRole_sequence') THEN
		CREATE SEQUENCE "Security"."InheritedRole_sequence";
		COMMENT ON SEQUENCE "Security"."InheritedRole_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_GlobalPermission_type-') THEN	
		CREATE TYPE "Security"."-ngs_GlobalPermission_type-" AS ();
		COMMENT ON TYPE "Security"."-ngs_GlobalPermission_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'GlobalPermission') THEN	
		CREATE TABLE "Security"."GlobalPermission" ();
		COMMENT ON TABLE "Security"."GlobalPermission" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'GlobalPermission_sequence') THEN
		CREATE SEQUENCE "Security"."GlobalPermission_sequence";
		COMMENT ON SEQUENCE "Security"."GlobalPermission_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_RolePermission_type-') THEN	
		CREATE TYPE "Security"."-ngs_RolePermission_type-" AS ();
		COMMENT ON TYPE "Security"."-ngs_RolePermission_type-" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'RolePermission') THEN	
		CREATE TABLE "Security"."RolePermission" ();
		COMMENT ON TABLE "Security"."RolePermission" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'Security' AND c.relname = 'RolePermission_sequence') THEN
		CREATE SEQUENCE "Security"."RolePermission_sequence";
		COMMENT ON SEQUENCE "Security"."RolePermission_sequence" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'URI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Artist_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'ID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" ADD ATTRIBUTE "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Artist_type-"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'ID') THEN
		ALTER TABLE "MultiPaint"."Artist" ADD COLUMN "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."Artist"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'Name') THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" ADD ATTRIBUTE "Name" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Artist_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'Name') THEN
		ALTER TABLE "MultiPaint"."Artist" ADD COLUMN "Name" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."Artist"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'Session') THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" ADD ATTRIBUTE "Session" UUID;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Artist_type-"."Session" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'Session') THEN
		ALTER TABLE "MultiPaint"."Artist" ADD COLUMN "Session" UUID;
		COMMENT ON COLUMN "MultiPaint"."Artist"."Session" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'CreatedAt') THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" ADD ATTRIBUTE "CreatedAt" TIMESTAMPTZ;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Artist_type-"."CreatedAt" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'CreatedAt') THEN
		ALTER TABLE "MultiPaint"."Artist" ADD COLUMN "CreatedAt" TIMESTAMPTZ;
		COMMENT ON COLUMN "MultiPaint"."Artist"."CreatedAt" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'URI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."URI" IS 'NGS generated';
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
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ArtistURI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "ArtistURI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."ArtistURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'ArtistID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "ArtistID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."ArtistID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'ArtistID') THEN
		ALTER TABLE "MultiPaint"."Brush" ADD COLUMN "ArtistID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."Brush"."ArtistID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Brush_type-' AND column_name = 'Color') THEN
		ALTER TYPE "MultiPaint"."-ngs_Brush_type-" ADD ATTRIBUTE "Color" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Brush_type-"."Color" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Brush' AND column_name = 'Color') THEN
		ALTER TABLE "MultiPaint"."Brush" ADD COLUMN "Color" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."Brush"."Color" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'ChangeBrush' AND column_name = 'Session') THEN
		ALTER TABLE "MultiPaint"."ChangeBrush" ADD COLUMN "Session" UUID;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'ChangeBrush' AND column_name = 'Color') THEN
		ALTER TABLE "MultiPaint"."ChangeBrush" ADD COLUMN "Color" VARCHAR;
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

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'URI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'ID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'ID') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."Segment"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'BrushURI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "BrushURI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."BrushURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'BrushID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "BrushID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."BrushID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'BrushID') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "BrushID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."Segment"."BrushID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'Index') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "Index" INT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."Index" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'Index') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "Index" INT;
		COMMENT ON COLUMN "MultiPaint"."Segment"."Index" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'State') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "State" "MultiPaint"."MouseState";
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."State" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'State') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "State" "MultiPaint"."MouseState";
		COMMENT ON COLUMN "MultiPaint"."Segment"."State" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'Position') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "Position" "MultiPaint"."-ngs_Position_type-";
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."Position" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'Position') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "Position" "MultiPaint"."Position";
		COMMENT ON COLUMN "MultiPaint"."Segment"."Position" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Segment_type-' AND column_name = 'OccurredAt') THEN
		ALTER TYPE "MultiPaint"."-ngs_Segment_type-" ADD ATTRIBUTE "OccurredAt" TIMESTAMPTZ;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Segment_type-"."OccurredAt" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Segment' AND column_name = 'OccurredAt') THEN
		ALTER TABLE "MultiPaint"."Segment" ADD COLUMN "OccurredAt" TIMESTAMPTZ;
		COMMENT ON COLUMN "MultiPaint"."Segment"."OccurredAt" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'URI') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'ID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "ID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."ID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'Color') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "Color" VARCHAR;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."Color" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'BrushID') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "BrushID" BIGINT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."BrushID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'Index') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "Index" INT;
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."Index" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'State') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "State" "MultiPaint"."MouseState";
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."State" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Drawing_type-' AND column_name = 'Position') THEN
		ALTER TYPE "MultiPaint"."-ngs_Drawing_type-" ADD ATTRIBUTE "Position" "MultiPaint"."-ngs_Position_type-";
		COMMENT ON COLUMN "MultiPaint"."-ngs_Drawing_type-"."Position" IS 'NGS generated';
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
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'MouseAction' AND column_name = 'Session') THEN
		ALTER TABLE "MultiPaint"."MouseAction" ADD COLUMN "Session" UUID;
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

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'URI') THEN
		ALTER TYPE "Security"."-ngs_User_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_User_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'Name') THEN
		ALTER TYPE "Security"."-ngs_User_type-" ADD ATTRIBUTE "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."-ngs_User_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'Name') THEN
		ALTER TABLE "Security"."User" ADD COLUMN "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."User"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'RoleURI') THEN
		ALTER TYPE "Security"."-ngs_User_type-" ADD ATTRIBUTE "RoleURI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_User_type-"."RoleURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'PasswordHash') THEN
		ALTER TYPE "Security"."-ngs_User_type-" ADD ATTRIBUTE "PasswordHash" BYTEA;
		COMMENT ON COLUMN "Security"."-ngs_User_type-"."PasswordHash" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'PasswordHash') THEN
		ALTER TABLE "Security"."User" ADD COLUMN "PasswordHash" BYTEA;
		COMMENT ON COLUMN "Security"."User"."PasswordHash" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_User_type-' AND column_name = 'IsAllowed') THEN
		ALTER TYPE "Security"."-ngs_User_type-" ADD ATTRIBUTE "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."-ngs_User_type-"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'User' AND column_name = 'IsAllowed') THEN
		ALTER TABLE "Security"."User" ADD COLUMN "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."User"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_Role_type-' AND column_name = 'URI') THEN
		ALTER TYPE "Security"."-ngs_Role_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_Role_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_Role_type-' AND column_name = 'Name') THEN
		ALTER TYPE "Security"."-ngs_Role_type-" ADD ATTRIBUTE "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."-ngs_Role_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role' AND column_name = 'Name') THEN
		ALTER TABLE "Security"."Role" ADD COLUMN "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."Role"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'URI') THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_InheritedRole_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'Name') THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" ADD ATTRIBUTE "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."-ngs_InheritedRole_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'InheritedRole' AND column_name = 'Name') THEN
		ALTER TABLE "Security"."InheritedRole" ADD COLUMN "Name" VARCHAR(100);
		COMMENT ON COLUMN "Security"."InheritedRole"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'RoleURI') THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" ADD ATTRIBUTE "RoleURI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_InheritedRole_type-"."RoleURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'ParentName') THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" ADD ATTRIBUTE "ParentName" VARCHAR(100);
		COMMENT ON COLUMN "Security"."-ngs_InheritedRole_type-"."ParentName" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'InheritedRole' AND column_name = 'ParentName') THEN
		ALTER TABLE "Security"."InheritedRole" ADD COLUMN "ParentName" VARCHAR(100);
		COMMENT ON COLUMN "Security"."InheritedRole"."ParentName" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_InheritedRole_type-' AND column_name = 'ParentRoleURI') THEN
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" ADD ATTRIBUTE "ParentRoleURI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_InheritedRole_type-"."ParentRoleURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_GlobalPermission_type-' AND column_name = 'URI') THEN
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_GlobalPermission_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_GlobalPermission_type-' AND column_name = 'Name') THEN
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" ADD ATTRIBUTE "Name" VARCHAR(200);
		COMMENT ON COLUMN "Security"."-ngs_GlobalPermission_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'GlobalPermission' AND column_name = 'Name') THEN
		ALTER TABLE "Security"."GlobalPermission" ADD COLUMN "Name" VARCHAR(200);
		COMMENT ON COLUMN "Security"."GlobalPermission"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_GlobalPermission_type-' AND column_name = 'IsAllowed') THEN
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" ADD ATTRIBUTE "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."-ngs_GlobalPermission_type-"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'GlobalPermission' AND column_name = 'IsAllowed') THEN
		ALTER TABLE "Security"."GlobalPermission" ADD COLUMN "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."GlobalPermission"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'URI') THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" ADD ATTRIBUTE "URI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_RolePermission_type-"."URI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'Name') THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" ADD ATTRIBUTE "Name" VARCHAR(200);
		COMMENT ON COLUMN "Security"."-ngs_RolePermission_type-"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'Name') THEN
		ALTER TABLE "Security"."RolePermission" ADD COLUMN "Name" VARCHAR(200);
		COMMENT ON COLUMN "Security"."RolePermission"."Name" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'RoleURI') THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" ADD ATTRIBUTE "RoleURI" VARCHAR;
		COMMENT ON COLUMN "Security"."-ngs_RolePermission_type-"."RoleURI" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'RoleID') THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" ADD ATTRIBUTE "RoleID" VARCHAR(100);
		COMMENT ON COLUMN "Security"."-ngs_RolePermission_type-"."RoleID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'RoleID') THEN
		ALTER TABLE "Security"."RolePermission" ADD COLUMN "RoleID" VARCHAR(100);
		COMMENT ON COLUMN "Security"."RolePermission"."RoleID" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '-ngs_RolePermission_type-' AND column_name = 'IsAllowed') THEN
		ALTER TYPE "Security"."-ngs_RolePermission_type-" ADD ATTRIBUTE "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."-ngs_RolePermission_type-"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'RolePermission' AND column_name = 'IsAllowed') THEN
		ALTER TABLE "Security"."RolePermission" ADD COLUMN "IsAllowed" BOOL;
		COMMENT ON COLUMN "Security"."RolePermission"."IsAllowed" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "MultiPaint"."Artist_entity" AS
SELECT CAST(_entity."ID" as TEXT) AS "URI" , _entity."ID", _entity."Name", _entity."Session", _entity."CreatedAt"
FROM
	"MultiPaint"."Artist" _entity
	;
COMMENT ON VIEW "MultiPaint"."Artist_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "MultiPaint"."Brush_entity" AS
SELECT CAST(_entity."ID" as TEXT) AS "URI" , _entity."ID", CAST(_entity."ArtistID" as TEXT) AS "ArtistURI", _entity."ArtistID", _entity."Color"
FROM
	"MultiPaint"."Brush" _entity
	;
COMMENT ON VIEW "MultiPaint"."Brush_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "MultiPaint"."ChangeBrush_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."Session", _event."Color", _event."BrushID"
FROM
	"MultiPaint"."ChangeBrush" _event
;

CREATE OR REPLACE VIEW "MultiPaint"."Segment_entity" AS
SELECT CAST(_entity."ID" as TEXT) AS "URI" , _entity."ID", CAST(_entity."BrushID" as TEXT) AS "BrushURI", _entity."BrushID", _entity."Index", _entity."State", _entity."Position", _entity."OccurredAt"
FROM
	"MultiPaint"."Segment" _entity
	;
COMMENT ON VIEW "MultiPaint"."Segment_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "MultiPaint"."MouseAction_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."Session", _event."BrushID", _event."Index", _event."State", _event."Position"
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

CREATE OR REPLACE VIEW "Security"."GlobalPermission_entity" AS
SELECT CAST(_entity."Name" as TEXT) AS "URI" , _entity."Name", _entity."IsAllowed"
FROM
	"Security"."GlobalPermission" _entity
	;
COMMENT ON VIEW "Security"."GlobalPermission_entity" IS 'NGS volatile';

CREATE OR REPLACE VIEW "Security"."RolePermission_entity" AS
SELECT "-NGS-".Generate_Uri2(CAST(_entity."Name" as TEXT), CAST(_entity."RoleID" as TEXT)) AS "URI" , _entity."Name", CAST(_entity."RoleID" as TEXT) AS "RoleURI", _entity."RoleID", _entity."IsAllowed"
FROM
	"Security"."RolePermission" _entity
	;
COMMENT ON VIEW "Security"."RolePermission_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "MultiPaint"."mark_ChangeBrush"(_events BIGINT[])
	RETURNS VOID AS
$$
BEGIN
	UPDATE "MultiPaint"."ChangeBrush" SET processed_at = now() WHERE event_id = ANY(_events) AND processed_at IS NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

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

	

	INSERT INTO "MultiPaint"."Brush" ("ID", "ArtistID", "Color")
	SELECT _i."ID", _i."ArtistID", _i."Color" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "MultiPaint"."Brush" as tbl SET 
		"ID" = _updated_new[_i]."ID", "ArtistID" = _updated_new[_i]."ArtistID", "Color" = _updated_new[_i]."Color"
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
SELECT r FROM "MultiPaint"."Artist_entity" r WHERE r."ID" = $1."ArtistID"
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
		INSERT INTO "MultiPaint"."ChangeBrush" (queued_at, processed_at, "Session", "Color", "BrushID")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Session", i."Color", i."BrushID"
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

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."-ngs_Segment_type-") RETURNS "MultiPaint"."Segment_entity" AS $$ SELECT $1::text::"MultiPaint"."Segment_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."Segment_entity") RETURNS "MultiPaint"."-ngs_Segment_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Segment_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Segment_entity' AND t.typname = '-ngs_Segment_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Segment_type-" AS "MultiPaint"."Segment_entity") WITH FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."-ngs_Segment_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Segment_entity" AS "MultiPaint"."-ngs_Segment_type-") WITH FUNCTION "MultiPaint"."cast_Segment_to_type"("MultiPaint"."Segment_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."persist_Segment"(
IN _inserted "MultiPaint"."Segment_entity"[], IN _updated_original "MultiPaint"."Segment_entity"[], IN _updated_new "MultiPaint"."Segment_entity"[], IN _deleted "MultiPaint"."Segment_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "MultiPaint"."Segment" ("ID", "BrushID", "Index", "State", "Position", "OccurredAt")
	SELECT _i."ID", _i."BrushID", _i."Index", _i."State", _i."Position", _i."OccurredAt" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "MultiPaint"."Segment" as tbl SET 
		"ID" = _updated_new[_i]."ID", "BrushID" = _updated_new[_i]."BrushID", "Index" = _updated_new[_i]."Index", "State" = _updated_new[_i]."State", "Position" = _updated_new[_i]."Position", "OccurredAt" = _updated_new[_i]."OccurredAt"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."ID" = _updated_original[_i]."ID";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "MultiPaint"."Segment"
	WHERE ("ID") IN (SELECT _d."ID" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Segment', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Segment', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Segment', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Segment', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "MultiPaint"."Segment_unprocessed_events" AS
SELECT _aggregate."ID"
FROM
	"MultiPaint"."Segment_entity" _aggregate
;
COMMENT ON VIEW "MultiPaint"."Segment_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Brush"("MultiPaint"."Segment_entity") RETURNS "MultiPaint"."Brush_entity" AS $$ 
SELECT r FROM "MultiPaint"."Brush_entity" r WHERE r."ID" = $1."BrushID"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_MouseAction"(IN events "MultiPaint"."MouseAction_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."MouseAction" (queued_at, processed_at, "Session", "BrushID", "Index", "State", "Position")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Session", i."BrushID", i."Index", i."State", i."Position"
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

CREATE OR REPLACE FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-") RETURNS "Security"."GlobalPermission_entity" AS $$ SELECT $1::text::"Security"."GlobalPermission_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity") RETURNS "Security"."-ngs_GlobalPermission_type-" AS $$ SELECT $1::text::"Security"."-ngs_GlobalPermission_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'Security' AND s.typname = 'GlobalPermission_entity' AND t.typname = '-ngs_GlobalPermission_type-') THEN
		CREATE CAST ("Security"."-ngs_GlobalPermission_type-" AS "Security"."GlobalPermission_entity") WITH FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-") AS IMPLICIT;
		CREATE CAST ("Security"."GlobalPermission_entity" AS "Security"."-ngs_GlobalPermission_type-") WITH FUNCTION "Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_GlobalPermission"(
IN _inserted "Security"."GlobalPermission_entity"[], IN _updated_original "Security"."GlobalPermission_entity"[], IN _updated_new "Security"."GlobalPermission_entity"[], IN _deleted "Security"."GlobalPermission_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_new, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."GlobalPermission" ("Name", "IsAllowed")
	SELECT _i."Name", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

		
	UPDATE "Security"."GlobalPermission" as tbl SET 
		"Name" = _updated_new[_i]."Name", "IsAllowed" = _updated_new[_i]."IsAllowed"
	FROM generate_series(1, _update_count) _i
	WHERE
		tbl."Name" = _updated_original[_i]."Name";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "Security"."GlobalPermission"
	WHERE ("Name") IN (SELECT _d."Name" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Insert', (SELECT array_agg("URI") FROM unnest(_inserted)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Update', (SELECT array_agg("URI") FROM unnest(_updated_original)));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Change', (SELECT array_agg(_updated_new[_i]."URI") FROM generate_series(1, _update_count) _i WHERE _updated_original[_i]."URI" != _updated_new[_i]."URI"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Delete', (SELECT array_agg("URI") FROM unnest(_deleted)));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."GlobalPermission_unprocessed_events" AS
SELECT _aggregate."Name"
FROM
	"Security"."GlobalPermission_entity" _aggregate
;
COMMENT ON VIEW "Security"."GlobalPermission_unprocessed_events" IS 'NGS volatile';

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

CREATE OR REPLACE VIEW "MultiPaint"."Drawing_snowflake" AS
SELECT CAST(_entity."ID" as TEXT) as "URI" , ("_entity")."ID" AS "ID", ("_entity_Brush")."Color" AS "Color", ("_entity")."BrushID" AS "BrushID", ("_entity")."Index" AS "Index", ("_entity")."State" AS "State", ("_entity")."Position" AS "Position"
FROM
	"MultiPaint"."Segment_entity" _entity
	
	
	INNER JOIN "MultiPaint"."Brush_entity" "_entity_Brush" ON "_entity_Brush"."ID" = "_entity"."BrushID";
COMMENT ON VIEW "MultiPaint"."Drawing_snowflake" IS 'NGS volatile';
COMMENT ON VIEW "MultiPaint"."MouseAction_event" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-")', 'MultiPaint', '-ngs_Artist_type-', 'Artist_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity")', 'MultiPaint', 'Artist_entity', '-ngs_Artist_type-');
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.GetArtistBySession"("it" "MultiPaint"."Artist_entity", "Session" UUID) RETURNS BOOL AS 
$$
	SELECT 	 ((("it"))."Session" = "Artist.GetArtistBySession"."Session") 
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.GetArtistBySession"("Session" UUID) RETURNS SETOF "MultiPaint"."Artist_entity" AS 
$$SELECT * FROM "MultiPaint"."Artist_entity" "it"  WHERE 	 ((("it"))."Session" = "Artist.GetArtistBySession"."Session") 
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Brush_to_type"("MultiPaint"."-ngs_Brush_type-")', 'MultiPaint', '-ngs_Brush_type-', 'Brush_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Brush_to_type"("MultiPaint"."Brush_entity")', 'MultiPaint', 'Brush_entity', '-ngs_Brush_type-');

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Segment_to_type"("MultiPaint"."-ngs_Segment_type-")', 'MultiPaint', '-ngs_Segment_type-', 'Segment_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Segment_to_type"("MultiPaint"."Segment_entity")', 'MultiPaint', 'Segment_entity', '-ngs_Segment_type-');

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."Drawing_snowflake") RETURNS "MultiPaint"."-ngs_Drawing_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Drawing_type-" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."-ngs_Drawing_type-") RETURNS "MultiPaint"."Drawing_snowflake" AS $$ SELECT $1::text::"MultiPaint"."Drawing_snowflake" $$ IMMUTABLE LANGUAGE sql;

DO $$
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Drawing_snowflake' AND t.typname = '-ngs_Drawing_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Drawing_type-" AS "MultiPaint"."Drawing_snowflake") WITH FUNCTION "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."-ngs_Drawing_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Drawing_snowflake" AS "MultiPaint"."-ngs_Drawing_type-") WITH FUNCTION "MultiPaint"."cast_Drawing_to_type"("MultiPaint"."Drawing_snowflake") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Drawing_to_type"("MultiPaint"."Drawing_snowflake")', 'MultiPaint', 'Drawing_snowflake', '-ngs_Drawing_type-');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Drawing_to_type"("MultiPaint"."-ngs_Drawing_type-")', 'MultiPaint', '-ngs_Drawing_type-', 'Drawing_snowflake');

CREATE OR REPLACE FUNCTION "MultiPaint"."compare_Segment_snowflake_and_entity"
("MultiPaint"."Drawing_snowflake", "MultiPaint"."Segment_entity")
RETURNS bool AS
$$
SELECT $1."URI" = $2."URI"
$$ IMMUTABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION "MultiPaint"."compare_Segment_entity_and_snowflake"
("MultiPaint"."Segment_entity", "MultiPaint"."Drawing_snowflake")
RETURNS bool AS
$$
SELECT $1."URI" = $2."URI"
$$ IMMUTABLE LANGUAGE sql;

DO $$
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_operator o JOIN pg_type l ON o.oprleft = l.oid JOIN pg_type r ON o.oprright = r.oid JOIN pg_namespace n ON n.oid = l.typnamespace AND n.oid = r.typnamespace
					WHERE o.oprname = '=' AND n.nspname = 'MultiPaint' AND l.typname = 'Drawing_snowflake' AND r.typname = 'Segment_entity') THEN
		CREATE OPERATOR =
		(
			leftarg = "MultiPaint"."Drawing_snowflake", 
			rightarg = "MultiPaint"."Segment_entity", 
			procedure = "MultiPaint"."compare_Segment_snowflake_and_entity",
			commutator = =
		);

		CREATE OPERATOR =
		(
			leftarg = "MultiPaint"."Segment_entity", 
			rightarg = "MultiPaint"."Drawing_snowflake", 
			procedure = "MultiPaint"."compare_Segment_entity_and_snowflake",
			commutator = =
		);
	END IF;
END $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION "MultiPaint"."Drawing.GetFromID"("it" "MultiPaint"."Drawing_snowflake", "fromID" BIGINT) RETURNS BOOL AS 
$$SELECT 	 ((("it"))."ID" > "Drawing.GetFromID"."fromID") 
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;
CREATE OR REPLACE FUNCTION "MultiPaint"."Drawing.GetFromID"("fromID" BIGINT) RETURNS SETOF "MultiPaint"."Drawing_snowflake" AS 
$$SELECT * FROM "MultiPaint"."Drawing_snowflake" "it"  WHERE 	 ((("it"))."ID" > "Drawing.GetFromID"."fromID") 
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_User_to_type"("Security"."-ngs_User_type-")', 'Security', '-ngs_User_type-', 'User_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_User_to_type"("Security"."User_entity")', 'Security', 'User_entity', '-ngs_User_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_Role_to_type"("Security"."-ngs_Role_type-")', 'Security', '-ngs_Role_type-', 'Role_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_Role_to_type"("Security"."Role_entity")', 'Security', 'Role_entity', '-ngs_Role_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-")', 'Security', '-ngs_InheritedRole_type-', 'InheritedRole_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity")', 'Security', 'InheritedRole_entity', '-ngs_InheritedRole_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-")', 'Security', '-ngs_GlobalPermission_type-', 'GlobalPermission_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity")', 'Security', 'GlobalPermission_entity', '-ngs_GlobalPermission_type-');

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-")', 'Security', '-ngs_RolePermission_type-', 'RolePermission_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity")', 'Security', 'RolePermission_entity', '-ngs_RolePermission_type-');
UPDATE "MultiPaint"."Artist" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "MultiPaint"."Artist" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "MultiPaint"."Artist" SET "Session" = '00000000-0000-0000-0000-000000000000' WHERE "Session" IS NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_Artist_Session') THEN
		CREATE INDEX "ix_Artist_Session" ON "MultiPaint"."Artist" ("Session");
		COMMENT ON INDEX "MultiPaint"."ix_Artist_Session" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
UPDATE "MultiPaint"."Artist" SET "CreatedAt" = CURRENT_TIMESTAMP WHERE "CreatedAt" IS NULL;
UPDATE "MultiPaint"."Brush" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "MultiPaint"."Brush" SET "ArtistID" = 0 WHERE "ArtistID" IS NULL;
UPDATE "MultiPaint"."Brush" SET "Color" = '' WHERE "Color" IS NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_ChangeBrush') THEN
		CREATE INDEX "ix_unprocessed_events_MultiPaint_ChangeBrush" ON "MultiPaint"."ChangeBrush" (event_id) WHERE processed_at IS NULL;
		COMMENT ON INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_ChangeBrush" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
UPDATE "MultiPaint"."Segment" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "MultiPaint"."Segment" SET "BrushID" = 0 WHERE "BrushID" IS NULL;
UPDATE "MultiPaint"."Segment" SET "Index" = 0 WHERE "Index" IS NULL;
UPDATE "MultiPaint"."Segment" SET "State" = 'Press' WHERE "State" IS NULL;
UPDATE "MultiPaint"."Segment" SET "Position" = ROW(NULL,NULL) WHERE "Position"::TEXT IS NULL;
UPDATE "MultiPaint"."Segment" SET "OccurredAt" = CURRENT_TIMESTAMP WHERE "OccurredAt" IS NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_MouseAction') THEN
		CREATE INDEX "ix_unprocessed_events_MultiPaint_MouseAction" ON "MultiPaint"."MouseAction" (event_id) WHERE processed_at IS NULL;
		COMMENT ON INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_MouseAction" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
UPDATE "Security"."User" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."User" SET "PasswordHash" = '' WHERE "PasswordHash" IS NULL;
UPDATE "Security"."User" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;
UPDATE "Security"."Role" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."InheritedRole" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."InheritedRole" SET "ParentName" = '' WHERE "ParentName" IS NULL;

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		INSERT INTO "Security"."Role"("Name") 
		SELECT 'Administrator'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Administrator');
	END IF;
END $$ LANGUAGE plpgsql;
UPDATE "Security"."GlobalPermission" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."GlobalPermission" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;
UPDATE "Security"."RolePermission" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."RolePermission" SET "RoleID" = '' WHERE "RoleID" IS NULL;
UPDATE "Security"."RolePermission" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'MultiPaint' AND c.relname = 'Artist') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"MultiPaint"."Artist"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('ID' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table MultiPaint.Artist. Expected primary key: ID. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "MultiPaint"."Artist" ADD CONSTRAINT "pk_Artist" PRIMARY KEY("ID");
		COMMENT ON CONSTRAINT "pk_Artist" ON "MultiPaint"."Artist" IS 'NGS generated';
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

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'MultiPaint' AND c.relname = 'Segment') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"MultiPaint"."Segment"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('ID' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table MultiPaint.Segment. Expected primary key: ID. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "MultiPaint"."Segment" ADD CONSTRAINT "pk_Segment" PRIMARY KEY("ID");
		COMMENT ON CONSTRAINT "pk_Segment" ON "MultiPaint"."Segment" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'Security' AND c.relname = 'User') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"Security"."User"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('Name' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table Security.User. Expected primary key: Name. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "Security"."User" ADD CONSTRAINT "pk_User" PRIMARY KEY("Name");
		COMMENT ON CONSTRAINT "pk_User" ON "Security"."User" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'Security' AND c.relname = 'Role') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"Security"."Role"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('Name' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table Security.Role. Expected primary key: Name. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "Security"."Role" ADD CONSTRAINT "pk_Role" PRIMARY KEY("Name");
		COMMENT ON CONSTRAINT "pk_Role" ON "Security"."Role" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'Security' AND c.relname = 'InheritedRole') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"Security"."InheritedRole"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('Name, ParentName' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table Security.InheritedRole. Expected primary key: Name, ParentName. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "Security"."InheritedRole" ADD CONSTRAINT "pk_InheritedRole" PRIMARY KEY("Name","ParentName");
		COMMENT ON CONSTRAINT "pk_InheritedRole" ON "Security"."InheritedRole" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'Security' AND c.relname = 'GlobalPermission') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"Security"."GlobalPermission"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('Name' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table Security.GlobalPermission. Expected primary key: Name. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "Security"."GlobalPermission" ADD CONSTRAINT "pk_GlobalPermission" PRIMARY KEY("Name");
		COMMENT ON CONSTRAINT "pk_GlobalPermission" ON "Security"."GlobalPermission" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
DECLARE _pk VARCHAR;
BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'Security' AND c.relname = 'RolePermission') THEN
		SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
		FROM
		(
			SELECT atr.attname
			FROM pg_index i
			JOIN pg_class c ON i.indrelid = c.oid 
			JOIN pg_attribute atr ON atr.attrelid = c.oid 
			WHERE 
				c.oid = '"Security"."RolePermission"'::regclass
				AND atr.attnum = any(i.indkey)
				AND indisprimary
			ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
		) sq;
		IF ('Name, RoleID' != _pk) THEN
			RAISE EXCEPTION 'Different primary key defined for table Security.RolePermission. Expected primary key: Name, RoleID. Found: %', _pk;
		END IF;
	ELSE
		ALTER TABLE "Security"."RolePermission" ADD CONSTRAINT "pk_RolePermission" PRIMARY KEY("Name","RoleID");
		COMMENT ON CONSTRAINT "pk_RolePermission" ON "Security"."RolePermission" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Artist" ALTER "ID" SET NOT NULL;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist_ID_seq' AND c.relkind = 'S') THEN
		CREATE SEQUENCE "MultiPaint"."Artist_ID_seq";
		ALTER TABLE "MultiPaint"."Artist"	ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"MultiPaint"."Artist_ID_seq"');
		PERFORM SETVAL('"MultiPaint"."Artist_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "MultiPaint"."Artist";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Artist" ALTER "Name" SET NOT NULL;
ALTER TABLE "MultiPaint"."Artist" ALTER "Session" SET NOT NULL;
ALTER TABLE "MultiPaint"."Artist" ALTER "CreatedAt" SET NOT NULL;
ALTER TABLE "MultiPaint"."Brush" ALTER "ID" SET NOT NULL;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'MultiPaint' AND c.relname = 'Brush_ID_seq' AND c.relkind = 'S') THEN
		CREATE SEQUENCE "MultiPaint"."Brush_ID_seq";
		ALTER TABLE "MultiPaint"."Brush"	ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"MultiPaint"."Brush_ID_seq"');
		PERFORM SETVAL('"MultiPaint"."Brush_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "MultiPaint"."Brush";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Brush" ALTER "ArtistID" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Artist' AND n.nspname = 'MultiPaint' AND r.relname = 'Brush') THEN	
		ALTER TABLE "MultiPaint"."Brush" 
			ADD CONSTRAINT "fk_Artist"
				FOREIGN KEY ("ArtistID") REFERENCES "MultiPaint"."Artist" ("ID")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Artist" ON "MultiPaint"."Brush" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Brush" ALTER "Color" SET NOT NULL;
ALTER TABLE "MultiPaint"."Segment" ALTER "ID" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indexrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'MultiPaint' AND c.relname = 'uq_ngs_uri_Segment') THEN
		CREATE UNIQUE INDEX "uq_ngs_uri_Segment" ON "MultiPaint"."Segment" (CAST("ID" as TEXT));
		COMMENT ON INDEX "MultiPaint"."uq_ngs_uri_Segment" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'MultiPaint' AND c.relname = 'Segment_ID_seq' AND c.relkind = 'S') THEN
		CREATE SEQUENCE "MultiPaint"."Segment_ID_seq";
		ALTER TABLE "MultiPaint"."Segment"	ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"MultiPaint"."Segment_ID_seq"');
		PERFORM SETVAL('"MultiPaint"."Segment_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "MultiPaint"."Segment";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Segment" ALTER "BrushID" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Brush' AND n.nspname = 'MultiPaint' AND r.relname = 'Segment') THEN	
		ALTER TABLE "MultiPaint"."Segment" 
			ADD CONSTRAINT "fk_Brush"
				FOREIGN KEY ("BrushID") REFERENCES "MultiPaint"."Brush" ("ID")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Brush" ON "MultiPaint"."Segment" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."Segment" ALTER "Index" SET NOT NULL;
ALTER TABLE "MultiPaint"."Segment" ALTER "State" SET NOT NULL;
ALTER TABLE "MultiPaint"."Segment" ALTER "Position" SET NOT NULL;
ALTER TABLE "MultiPaint"."Segment" ALTER "OccurredAt" SET NOT NULL;
ALTER TABLE "Security"."User" ALTER "Name" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'User') THEN	
		ALTER TABLE "Security"."User" 
			ADD CONSTRAINT "fk_Role"
				FOREIGN KEY ("Name") REFERENCES "Security"."Role" ("Name")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Role" ON "Security"."User" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "Security"."User" ALTER "PasswordHash" SET NOT NULL;
ALTER TABLE "Security"."User" ALTER "IsAllowed" SET NOT NULL;
ALTER TABLE "Security"."Role" ALTER "Name" SET NOT NULL;
ALTER TABLE "Security"."InheritedRole" ALTER "Name" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'InheritedRole') THEN	
		ALTER TABLE "Security"."InheritedRole" 
			ADD CONSTRAINT "fk_Role"
				FOREIGN KEY ("Name") REFERENCES "Security"."Role" ("Name")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Role" ON "Security"."InheritedRole" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "Security"."InheritedRole" ALTER "ParentName" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_ParentRole' AND n.nspname = 'Security' AND r.relname = 'InheritedRole') THEN	
		ALTER TABLE "Security"."InheritedRole" 
			ADD CONSTRAINT "fk_ParentRole"
				FOREIGN KEY ("ParentName") REFERENCES "Security"."Role" ("Name")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_ParentRole" ON "Security"."InheritedRole" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "Security"."GlobalPermission" ALTER "Name" SET NOT NULL;
ALTER TABLE "Security"."GlobalPermission" ALTER "IsAllowed" SET NOT NULL;
ALTER TABLE "Security"."RolePermission" ALTER "Name" SET NOT NULL;
ALTER TABLE "Security"."RolePermission" ALTER "RoleID" SET NOT NULL;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_Role' AND n.nspname = 'Security' AND r.relname = 'RolePermission') THEN	
		ALTER TABLE "Security"."RolePermission" 
			ADD CONSTRAINT "fk_Role"
				FOREIGN KEY ("RoleID") REFERENCES "Security"."Role" ("Name")
				ON UPDATE CASCADE ;
		COMMENT ON CONSTRAINT "fk_Role" ON "Security"."RolePermission" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "Security"."RolePermission" ALTER "IsAllowed" SET NOT NULL;

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

	/* brushes are public and authors are known */
	big aggregate Brush {
		Artist  *Artist;
		String  Color;
	}

	/* request for a new brush */
	event ChangeBrush {
		Guid   Session; // authorization
		String Color;
		Long?  BrushID; // output
	}

	value Position {
		Int  X;
		Int  Y;
	}

	/* one segment of a brush path */
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

	/* mouse actions create brush segments */
	event MouseAction {
		Guid        Session; // authorization
		Long        BrushID;
		Int         Index;
		MouseState  State;
		Position    Position;
	}
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