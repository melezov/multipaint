/*MIGRATION_DESCRIPTION
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
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'Security') THEN
		CREATE SCHEMA "Security";
		COMMENT ON SCHEMA "Security" IS 'NGS generated';
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

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		INSERT INTO "Security"."Role"("Name") 
		SELECT 'Artist'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Artist');
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		INSERT INTO "Security"."Role"("Name") 
		SELECT 'Guest'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Guest');
	END IF;
END $$ LANGUAGE plpgsql;
UPDATE "Security"."User" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."User" SET "PasswordHash" = '' WHERE "PasswordHash" IS NULL;
UPDATE "Security"."User" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;
UPDATE "Security"."Role" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."InheritedRole" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."InheritedRole" SET "ParentName" = '' WHERE "ParentName" IS NULL;
UPDATE "Security"."GlobalPermission" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."GlobalPermission" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;
UPDATE "Security"."RolePermission" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."RolePermission" SET "RoleID" = '' WHERE "RoleID" IS NULL;
UPDATE "Security"."RolePermission" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;

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

SELECT "-NGS-".Persist_Concepts('"D:\\Code\\multipaint\\dsl\\Security\\Security.dsl"=>"module Security
{
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
","D:\\Code\\multipaint\\dsl\\Security\\SecurityHelper.dsl"=>"server code <#
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