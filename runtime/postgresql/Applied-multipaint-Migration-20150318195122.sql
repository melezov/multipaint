
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Artist_type-') THEN	
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_User_type-') THEN	
		ALTER TYPE "Security"."-ngs_User_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_Role_type-') THEN	
		ALTER TYPE "Security"."-ngs_Role_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_InheritedRole_type-') THEN	
		ALTER TYPE "Security"."-ngs_InheritedRole_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_GlobalPermission_type-') THEN	
		ALTER TYPE "Security"."-ngs_GlobalPermission_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '-ngs_RolePermission_type-') THEN	
		ALTER TYPE "Security"."-ngs_RolePermission_type-" DROP ATTRIBUTE IF EXISTS "URI";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'MultiPaint' AND p.proname = 'persist_Artist') THEN	
		DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist"("MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '>update-Artist-pair<') THEN
		CREATE TYPE "MultiPaint".">update-Artist-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'Security' AND p.proname = 'persist_User') THEN	
		DROP FUNCTION IF EXISTS "Security"."persist_User"("Security"."User_entity"[], "Security"."User_entity"[], "Security"."User_entity"[], "Security"."User_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-User-pair<') THEN
		CREATE TYPE "Security".">update-User-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'Security' AND p.proname = 'persist_Role') THEN	
		DROP FUNCTION IF EXISTS "Security"."persist_Role"("Security"."Role_entity"[], "Security"."Role_entity"[], "Security"."Role_entity"[], "Security"."Role_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-Role-pair<') THEN
		CREATE TYPE "Security".">update-Role-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'Security' AND p.proname = 'persist_InheritedRole') THEN	
		DROP FUNCTION IF EXISTS "Security"."persist_InheritedRole"("Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[], "Security"."InheritedRole_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-InheritedRole-pair<') THEN
		CREATE TYPE "Security".">update-InheritedRole-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'Security' AND p.proname = 'persist_GlobalPermission') THEN	
		DROP FUNCTION IF EXISTS "Security"."persist_GlobalPermission"("Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[], "Security"."GlobalPermission_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-GlobalPermission-pair<') THEN
		CREATE TYPE "Security".">update-GlobalPermission-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'Security' AND p.proname = 'persist_RolePermission') THEN	
		DROP FUNCTION IF EXISTS "Security"."persist_RolePermission"("Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[], "Security"."RolePermission_entity"[]);
	END IF;
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-RolePermission-pair<') THEN
		CREATE TYPE "Security".">update-RolePermission-pair<" AS ();
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'RegisterArtist' AND column_name = 'event_id') THEN
		ALTER TABLE "MultiPaint"."RegisterArtist" RENAME "event_id" TO "_event_id";
		ALTER TABLE "MultiPaint"."RegisterArtist" RENAME "queued_at" TO "_queued_at";
		ALTER TABLE "MultiPaint"."RegisterArtist" RENAME "processed_at" TO "_processed_at";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'ChangeArtistName' AND column_name = 'event_id') THEN
		ALTER TABLE "MultiPaint"."ChangeArtistName" RENAME "event_id" TO "_event_id";
		ALTER TABLE "MultiPaint"."ChangeArtistName" RENAME "queued_at" TO "_queued_at";
		ALTER TABLE "MultiPaint"."ChangeArtistName" RENAME "processed_at" TO "_processed_at";
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

DROP FUNCTION IF EXISTS "MultiPaint"."Artist.ActiveUsers"(TIMESTAMPTZ);
DROP FUNCTION IF EXISTS "MultiPaint"."Artist.ActiveUsers"("MultiPaint"."Artist_entity", TIMESTAMPTZ);

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;
DROP FUNCTION IF EXISTS "Role"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."RolePermission_unprocessed_events";
DROP FUNCTION IF EXISTS "Security"."update_RolePermission"("Security"."RolePermission_entity"[],"Security"."RolePermission_entity"[]);;

DROP FUNCTION IF EXISTS "Security"."persist_RolePermission"("Security"."RolePermission_entity"[], "Security".">update-RolePermission-pair<"[], "Security"."RolePermission_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-RolePermission-pair<') THEN
		DROP TYPE "Security".">update-RolePermission-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "Security"."insert_RolePermission"("Security"."RolePermission_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_RolePermission_type-" AS "Security"."RolePermission_entity");
DROP CAST IF EXISTS ("Security"."RolePermission_entity" AS "Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."-ngs_RolePermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_RolePermission_to_type"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."GlobalPermission_unprocessed_events";
DROP FUNCTION IF EXISTS "Security"."update_GlobalPermission"("Security"."GlobalPermission_entity"[],"Security"."GlobalPermission_entity"[]);;

DROP FUNCTION IF EXISTS "Security"."persist_GlobalPermission"("Security"."GlobalPermission_entity"[], "Security".">update-GlobalPermission-pair<"[], "Security"."GlobalPermission_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-GlobalPermission-pair<') THEN
		DROP TYPE "Security".">update-GlobalPermission-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "Security"."insert_GlobalPermission"("Security"."GlobalPermission_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_GlobalPermission_type-" AS "Security"."GlobalPermission_entity");
DROP CAST IF EXISTS ("Security"."GlobalPermission_entity" AS "Security"."-ngs_GlobalPermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-");
DROP FUNCTION IF EXISTS "Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity");
DROP FUNCTION IF EXISTS "ParentRole"("Security"."InheritedRole_entity");
DROP FUNCTION IF EXISTS "Role"("Security"."InheritedRole_entity");
DROP VIEW IF EXISTS "Security"."InheritedRole_unprocessed_events";
DROP FUNCTION IF EXISTS "Security"."update_InheritedRole"("Security"."InheritedRole_entity"[],"Security"."InheritedRole_entity"[]);;

DROP FUNCTION IF EXISTS "Security"."persist_InheritedRole"("Security"."InheritedRole_entity"[], "Security".">update-InheritedRole-pair<"[], "Security"."InheritedRole_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-InheritedRole-pair<') THEN
		DROP TYPE "Security".">update-InheritedRole-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "Security"."insert_InheritedRole"("Security"."InheritedRole_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_InheritedRole_type-" AS "Security"."InheritedRole_entity");
DROP CAST IF EXISTS ("Security"."InheritedRole_entity" AS "Security"."-ngs_InheritedRole_type-");
DROP FUNCTION IF EXISTS "Security"."cast_InheritedRole_to_type"("Security"."-ngs_InheritedRole_type-");
DROP FUNCTION IF EXISTS "Security"."cast_InheritedRole_to_type"("Security"."InheritedRole_entity");
DROP VIEW IF EXISTS "Security"."Role_unprocessed_events";
DROP FUNCTION IF EXISTS "Security"."update_Role"("Security"."Role_entity"[],"Security"."Role_entity"[]);;

DROP FUNCTION IF EXISTS "Security"."persist_Role"("Security"."Role_entity"[], "Security".">update-Role-pair<"[], "Security"."Role_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-Role-pair<') THEN
		DROP TYPE "Security".">update-Role-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "Security"."insert_Role"("Security"."Role_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_Role_type-" AS "Security"."Role_entity");
DROP CAST IF EXISTS ("Security"."Role_entity" AS "Security"."-ngs_Role_type-");
DROP FUNCTION IF EXISTS "Security"."cast_Role_to_type"("Security"."-ngs_Role_type-");
DROP FUNCTION IF EXISTS "Security"."cast_Role_to_type"("Security"."Role_entity");
DROP FUNCTION IF EXISTS "Role"("Security"."User_entity");
DROP VIEW IF EXISTS "Security"."User_unprocessed_events";
DROP FUNCTION IF EXISTS "Security"."update_User"("Security"."User_entity"[],"Security"."User_entity"[]);;

DROP FUNCTION IF EXISTS "Security"."persist_User"("Security"."User_entity"[], "Security".">update-User-pair<"[], "Security"."User_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'Security' AND t.typname = '>update-User-pair<') THEN
		DROP TYPE "Security".">update-User-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "Security"."insert_User"("Security"."User_entity"[]);;

DROP CAST IF EXISTS ("Security"."-ngs_User_type-" AS "Security"."User_entity");
DROP CAST IF EXISTS ("Security"."User_entity" AS "Security"."-ngs_User_type-");
DROP FUNCTION IF EXISTS "Security"."cast_User_to_type"("Security"."-ngs_User_type-");
DROP FUNCTION IF EXISTS "Security"."cast_User_to_type"("Security"."User_entity");
DROP FUNCTION IF EXISTS "MultiPaint"."submit_ChangeArtistName"("MultiPaint"."ChangeArtistName_event"[]);
DROP FUNCTION IF EXISTS "MultiPaint"."submit_RegisterArtist"("MultiPaint"."RegisterArtist_event"[]);
DROP FUNCTION IF EXISTS "User"("MultiPaint"."Artist_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_unprocessed_events";
DROP FUNCTION IF EXISTS "MultiPaint"."update_Artist"("MultiPaint"."Artist_entity"[],"MultiPaint"."Artist_entity"[]);;

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist"("MultiPaint"."Artist_entity"[], "MultiPaint".">update-Artist-pair<"[], "MultiPaint"."Artist_entity"[]);
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = '>update-Artist-pair<') THEN
		DROP TYPE "MultiPaint".">update-Artist-pair<";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."insert_Artist"("MultiPaint"."Artist_entity"[]);;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity");
DROP CAST IF EXISTS ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity");
DROP FUNCTION IF EXISTS "URI"("Security"."RolePermission_entity");
DROP VIEW IF EXISTS "Security"."RolePermission_entity";
DROP FUNCTION IF EXISTS "URI"("Security"."GlobalPermission_entity");
DROP VIEW IF EXISTS "Security"."GlobalPermission_entity";
DROP FUNCTION IF EXISTS "URI"("Security"."InheritedRole_entity");
DROP VIEW IF EXISTS "Security"."InheritedRole_entity";
DROP FUNCTION IF EXISTS "URI"("Security"."Role_entity");
DROP VIEW IF EXISTS "Security"."Role_entity";
DROP FUNCTION IF EXISTS "URI"("Security"."User_entity");
DROP VIEW IF EXISTS "Security"."User_entity";
DROP FUNCTION IF EXISTS "URI"("MultiPaint"."ChangeArtistName_event");
DROP VIEW IF EXISTS "MultiPaint"."ChangeArtistName_event";
DROP FUNCTION IF EXISTS "URI"("MultiPaint"."RegisterArtist_event");
DROP VIEW IF EXISTS "MultiPaint"."RegisterArtist_event";
DROP FUNCTION IF EXISTS "URI"("MultiPaint"."Artist_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_entity";

CREATE OR REPLACE VIEW "MultiPaint"."Artist_entity" AS
SELECT CAST(_entity."UserID" as TEXT) AS "UserURI", _entity."UserID", _entity."Name", _entity."CreatedAt", _entity."LastActiveAt"
FROM
	"MultiPaint"."Artist" _entity
	;
COMMENT ON VIEW "MultiPaint"."Artist_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("MultiPaint"."Artist_entity") RETURNS TEXT AS $$
SELECT CAST($1."UserID" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "MultiPaint"."RegisterArtist_event" AS
SELECT _event._event_id, _event._queued_at AS "QueuedAt", _event._processed_at AS "ProcessedAt" , _event."Name", _event."UserID", _event."Password"
FROM
	"MultiPaint"."RegisterArtist" _event
;

CREATE OR REPLACE FUNCTION "URI"("MultiPaint"."RegisterArtist_event") RETURNS TEXT AS $$
SELECT $1._event_id::text
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "MultiPaint"."ChangeArtistName_event" AS
SELECT _event._event_id, _event._queued_at AS "QueuedAt", _event._processed_at AS "ProcessedAt" , _event."NewName"
FROM
	"MultiPaint"."ChangeArtistName" _event
;

CREATE OR REPLACE FUNCTION "URI"("MultiPaint"."ChangeArtistName_event") RETURNS TEXT AS $$
SELECT $1._event_id::text
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."User_entity" AS
SELECT _entity."Name", CAST(_entity."Name" as TEXT) AS "RoleURI", _entity."PasswordHash", _entity."IsAllowed"
FROM
	"Security"."User" _entity
	;
COMMENT ON VIEW "Security"."User_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("Security"."User_entity") RETURNS TEXT AS $$
SELECT CAST($1."Name" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."Role_entity" AS
SELECT _entity."Name"
FROM
	"Security"."Role" _entity
	;
COMMENT ON VIEW "Security"."Role_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("Security"."Role_entity") RETURNS TEXT AS $$
SELECT CAST($1."Name" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."InheritedRole_entity" AS
SELECT _entity."Name", CAST(_entity."Name" as TEXT) AS "RoleURI", _entity."ParentName", CAST(_entity."ParentName" as TEXT) AS "ParentRoleURI"
FROM
	"Security"."InheritedRole" _entity
	;
COMMENT ON VIEW "Security"."InheritedRole_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("Security"."InheritedRole_entity") RETURNS TEXT AS $$
SELECT "-NGS-".Generate_Uri2(CAST($1."Name" as TEXT), CAST($1."ParentName" as TEXT))
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."GlobalPermission_entity" AS
SELECT _entity."Name", _entity."IsAllowed"
FROM
	"Security"."GlobalPermission" _entity
	;
COMMENT ON VIEW "Security"."GlobalPermission_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("Security"."GlobalPermission_entity") RETURNS TEXT AS $$
SELECT CAST($1."Name" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "Security"."RolePermission_entity" AS
SELECT _entity."Name", CAST(_entity."RoleID" as TEXT) AS "RoleURI", _entity."RoleID", _entity."IsAllowed"
FROM
	"Security"."RolePermission" _entity
	;
COMMENT ON VIEW "Security"."RolePermission_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("Security"."RolePermission_entity") RETURNS TEXT AS $$
SELECT "-NGS-".Generate_Uri2(CAST($1."Name" as TEXT), CAST($1."RoleID" as TEXT))
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
					WHERE n.nspname = 'MultiPaint' AND s.typname = 'Artist_entity' AND t.typname = '-ngs_Artist_type-') THEN
		CREATE CAST ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity") WITH FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") AS IMPLICIT;
		CREATE CAST ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-") WITH FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") AS IMPLICIT;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."insert_Artist"(IN _inserted "MultiPaint"."Artist_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "MultiPaint"."Artist" ("UserID", "Name", "CreatedAt", "LastActiveAt") VALUES(_inserted[1]."UserID", _inserted[1]."Name", _inserted[1]."CreatedAt", _inserted[1]."LastActiveAt");
	
	PERFORM pg_notify('aggregate_roots', 'MultiPaint.Artist:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '>update-Artist-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "MultiPaint".">update-Artist-pair<";
		CREATE TYPE "MultiPaint".">update-Artist-pair<" AS (original "MultiPaint"."Artist_entity", changed "MultiPaint"."Artist_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "MultiPaint"."persist_Artist"(
IN _inserted "MultiPaint"."Artist_entity"[], IN _updated "MultiPaint".">update-Artist-pair<"[], IN _deleted "MultiPaint"."Artist_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "MultiPaint"."Artist" ("UserID", "Name", "CreatedAt", "LastActiveAt")
	SELECT _i."UserID", _i."Name", _i."CreatedAt", _i."LastActiveAt" 
	FROM unnest(_inserted) _i;

	

	UPDATE "MultiPaint"."Artist" as _tbl SET "UserID" = (_u.changed)."UserID", "Name" = (_u.changed)."Name", "CreatedAt" = (_u.changed)."CreatedAt", "LastActiveAt" = (_u.changed)."LastActiveAt"
	FROM unnest(_updated) _u
	WHERE _tbl."UserID" = (_u.original)."UserID";

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _update_count THEN 
		RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
	END IF;

	

	DELETE FROM "MultiPaint"."Artist"
	WHERE ("UserID") IN (SELECT _d."UserID" FROM unnest(_deleted) _d);

	GET DIAGNOSTICS cnt = ROW_COUNT;
	IF cnt != _delete_count THEN 
		RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
	END IF;

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."UserID" != (_u.original)."UserID"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'MultiPaint.Artist', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."update_Artist"(IN _original "MultiPaint"."Artist_entity"[], IN _updated "MultiPaint"."Artist_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "MultiPaint"."Artist" AS _tab SET "UserID" = _updated[1]."UserID", "Name" = _updated[1]."Name", "CreatedAt" = _updated[1]."CreatedAt", "LastActiveAt" = _updated[1]."LastActiveAt" WHERE _tab."UserID" = _original[1]."UserID";
	
	PERFORM pg_notify('aggregate_roots', 'MultiPaint.Artist:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."UserID" != _updated[1]."UserID") THEN
		PERFORM pg_notify('aggregate_roots', 'MultiPaint.Artist:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

CREATE OR REPLACE VIEW "MultiPaint"."Artist_unprocessed_events" AS
SELECT _aggregate."UserID"
FROM
	"MultiPaint"."Artist_entity" _aggregate
;
COMMENT ON VIEW "MultiPaint"."Artist_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "User"("MultiPaint"."Artist_entity") RETURNS "Security"."User_entity" AS $$ 
SELECT r FROM "Security"."User_entity" r WHERE r."Name" = $1."UserID"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_RegisterArtist"(IN events "MultiPaint"."RegisterArtist_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."RegisterArtist" (_queued_at, _processed_at, "Name", "UserID", "Password")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Name", i."UserID", i."Password"
		FROM unnest(events) i
		RETURNING _event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.RegisterArtist', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_ChangeArtistName"(IN events "MultiPaint"."ChangeArtistName_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."ChangeArtistName" (_queued_at, _processed_at, "NewName")
		SELECT i."QueuedAt", i."ProcessedAt" , i."NewName"
		FROM unnest(events) i
		RETURNING _event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.ChangeArtistName', 'Insert', newUris);
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

CREATE OR REPLACE FUNCTION "Security"."insert_User"(IN _inserted "Security"."User_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Security"."User" ("Name", "PasswordHash", "IsAllowed") VALUES(_inserted[1]."Name", _inserted[1]."PasswordHash", _inserted[1]."IsAllowed");
	
	PERFORM pg_notify('aggregate_roots', 'Security.User:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '>update-User-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "Security".">update-User-pair<";
		CREATE TYPE "Security".">update-User-pair<" AS (original "Security"."User_entity", changed "Security"."User_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_User"(
IN _inserted "Security"."User_entity"[], IN _updated "Security".">update-User-pair<"[], IN _deleted "Security"."User_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."User" ("Name", "PasswordHash", "IsAllowed")
	SELECT _i."Name", _i."PasswordHash", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

	UPDATE "Security"."User" as _tbl SET "Name" = (_u.changed)."Name", "PasswordHash" = (_u.changed)."PasswordHash", "IsAllowed" = (_u.changed)."IsAllowed"
	FROM unnest(_updated) _u
	WHERE _tbl."Name" = (_u.original)."Name";

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

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."Name" != (_u.original)."Name"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.User', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."update_User"(IN _original "Security"."User_entity"[], IN _updated "Security"."User_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "Security"."User" AS _tab SET "Name" = _updated[1]."Name", "PasswordHash" = _updated[1]."PasswordHash", "IsAllowed" = _updated[1]."IsAllowed" WHERE _tab."Name" = _original[1]."Name";
	
	PERFORM pg_notify('aggregate_roots', 'Security.User:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."Name" != _updated[1]."Name") THEN
		PERFORM pg_notify('aggregate_roots', 'Security.User:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

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

CREATE OR REPLACE FUNCTION "Security"."insert_Role"(IN _inserted "Security"."Role_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Security"."Role" ("Name") VALUES(_inserted[1]."Name");
	
	PERFORM pg_notify('aggregate_roots', 'Security.Role:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '>update-Role-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "Security".">update-Role-pair<";
		CREATE TYPE "Security".">update-Role-pair<" AS (original "Security"."Role_entity", changed "Security"."Role_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_Role"(
IN _inserted "Security"."Role_entity"[], IN _updated "Security".">update-Role-pair<"[], IN _deleted "Security"."Role_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."Role" ("Name")
	SELECT _i."Name" 
	FROM unnest(_inserted) _i;

	

	UPDATE "Security"."Role" as _tbl SET "Name" = (_u.changed)."Name"
	FROM unnest(_updated) _u
	WHERE _tbl."Name" = (_u.original)."Name";

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

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."Name" != (_u.original)."Name"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.Role', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."update_Role"(IN _original "Security"."Role_entity"[], IN _updated "Security"."Role_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "Security"."Role" AS _tab SET "Name" = _updated[1]."Name" WHERE _tab."Name" = _original[1]."Name";
	
	PERFORM pg_notify('aggregate_roots', 'Security.Role:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."Name" != _updated[1]."Name") THEN
		PERFORM pg_notify('aggregate_roots', 'Security.Role:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

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

CREATE OR REPLACE FUNCTION "Security"."insert_InheritedRole"(IN _inserted "Security"."InheritedRole_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Security"."InheritedRole" ("Name", "ParentName") VALUES(_inserted[1]."Name", _inserted[1]."ParentName");
	
	PERFORM pg_notify('aggregate_roots', 'Security.InheritedRole:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '>update-InheritedRole-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "Security".">update-InheritedRole-pair<";
		CREATE TYPE "Security".">update-InheritedRole-pair<" AS (original "Security"."InheritedRole_entity", changed "Security"."InheritedRole_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_InheritedRole"(
IN _inserted "Security"."InheritedRole_entity"[], IN _updated "Security".">update-InheritedRole-pair<"[], IN _deleted "Security"."InheritedRole_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."InheritedRole" ("Name", "ParentName")
	SELECT _i."Name", _i."ParentName" 
	FROM unnest(_inserted) _i;

	

	UPDATE "Security"."InheritedRole" as _tbl SET "Name" = (_u.changed)."Name", "ParentName" = (_u.changed)."ParentName"
	FROM unnest(_updated) _u
	WHERE _tbl."Name" = (_u.original)."Name" AND _tbl."ParentName" = (_u.original)."ParentName";

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

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."Name" != (_u.original)."Name" OR (_u.changed)."ParentName" != (_u.original)."ParentName"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.InheritedRole', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."update_InheritedRole"(IN _original "Security"."InheritedRole_entity"[], IN _updated "Security"."InheritedRole_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "Security"."InheritedRole" AS _tab SET "Name" = _updated[1]."Name", "ParentName" = _updated[1]."ParentName" WHERE _tab."Name" = _original[1]."Name" AND _tab."ParentName" = _original[1]."ParentName";
	
	PERFORM pg_notify('aggregate_roots', 'Security.InheritedRole:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."Name" != _updated[1]."Name" OR _original[1]."ParentName" != _updated[1]."ParentName") THEN
		PERFORM pg_notify('aggregate_roots', 'Security.InheritedRole:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

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

CREATE OR REPLACE FUNCTION "Security"."insert_GlobalPermission"(IN _inserted "Security"."GlobalPermission_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Security"."GlobalPermission" ("Name", "IsAllowed") VALUES(_inserted[1]."Name", _inserted[1]."IsAllowed");
	
	PERFORM pg_notify('aggregate_roots', 'Security.GlobalPermission:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '>update-GlobalPermission-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "Security".">update-GlobalPermission-pair<";
		CREATE TYPE "Security".">update-GlobalPermission-pair<" AS (original "Security"."GlobalPermission_entity", changed "Security"."GlobalPermission_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_GlobalPermission"(
IN _inserted "Security"."GlobalPermission_entity"[], IN _updated "Security".">update-GlobalPermission-pair<"[], IN _deleted "Security"."GlobalPermission_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."GlobalPermission" ("Name", "IsAllowed")
	SELECT _i."Name", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

	UPDATE "Security"."GlobalPermission" as _tbl SET "Name" = (_u.changed)."Name", "IsAllowed" = (_u.changed)."IsAllowed"
	FROM unnest(_updated) _u
	WHERE _tbl."Name" = (_u.original)."Name";

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

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."Name" != (_u.original)."Name"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.GlobalPermission', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."update_GlobalPermission"(IN _original "Security"."GlobalPermission_entity"[], IN _updated "Security"."GlobalPermission_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "Security"."GlobalPermission" AS _tab SET "Name" = _updated[1]."Name", "IsAllowed" = _updated[1]."IsAllowed" WHERE _tab."Name" = _original[1]."Name";
	
	PERFORM pg_notify('aggregate_roots', 'Security.GlobalPermission:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."Name" != _updated[1]."Name") THEN
		PERFORM pg_notify('aggregate_roots', 'Security.GlobalPermission:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

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

CREATE OR REPLACE FUNCTION "Security"."insert_RolePermission"(IN _inserted "Security"."RolePermission_entity"[]) RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Security"."RolePermission" ("Name", "RoleID", "IsAllowed") VALUES(_inserted[1]."Name", _inserted[1]."RoleID", _inserted[1]."IsAllowed");
	
	PERFORM pg_notify('aggregate_roots', 'Security.RolePermission:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = '>update-RolePermission-pair<' AND column_name = 'original') THEN
		DROP TYPE IF EXISTS "Security".">update-RolePermission-pair<";
		CREATE TYPE "Security".">update-RolePermission-pair<" AS (original "Security"."RolePermission_entity", changed "Security"."RolePermission_entity");
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Security"."persist_RolePermission"(
IN _inserted "Security"."RolePermission_entity"[], IN _updated "Security".">update-RolePermission-pair<"[], IN _deleted "Security"."RolePermission_entity"[]) 
	RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

	SET CONSTRAINTS ALL DEFERRED;

	

	INSERT INTO "Security"."RolePermission" ("Name", "RoleID", "IsAllowed")
	SELECT _i."Name", _i."RoleID", _i."IsAllowed" 
	FROM unnest(_inserted) _i;

	

	UPDATE "Security"."RolePermission" as _tbl SET "Name" = (_u.changed)."Name", "RoleID" = (_u.changed)."RoleID", "IsAllowed" = (_u.changed)."IsAllowed"
	FROM unnest(_updated) _u
	WHERE _tbl."Name" = (_u.original)."Name" AND _tbl."RoleID" = (_u.original)."RoleID";

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

	
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Update', (SELECT array_agg((_u.original)."URI") FROM unnest(_updated) _u));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Change', (SELECT array_agg((_u.changed)."URI") FROM unnest(_updated) _u WHERE (_u.changed)."Name" != (_u.original)."Name" OR (_u.changed)."RoleID" != (_u.original)."RoleID"));
	PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'Security.RolePermission', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

	SET CONSTRAINTS ALL IMMEDIATE;

	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "Security"."update_RolePermission"(IN _original "Security"."RolePermission_entity"[], IN _updated "Security"."RolePermission_entity"[]) RETURNS VARCHAR AS
$$
BEGIN
	
	UPDATE "Security"."RolePermission" AS _tab SET "Name" = _updated[1]."Name", "RoleID" = _updated[1]."RoleID", "IsAllowed" = _updated[1]."IsAllowed" WHERE _tab."Name" = _original[1]."Name" AND _tab."RoleID" = _original[1]."RoleID";
	
	PERFORM pg_notify('aggregate_roots', 'Security.RolePermission:Update:' || array["URI"(_original[1])]::TEXT);
	IF (_original[1]."Name" != _updated[1]."Name" OR _original[1]."RoleID" != _updated[1]."RoleID") THEN
		PERFORM pg_notify('aggregate_roots', 'Security.RolePermission:Change:' || array["URI"(_updated[1])]::TEXT);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

CREATE OR REPLACE VIEW "Security"."RolePermission_unprocessed_events" AS
SELECT _aggregate."Name", _aggregate."RoleID"
FROM
	"Security"."RolePermission_entity" _aggregate
;
COMMENT ON VIEW "Security"."RolePermission_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "Role"("Security"."RolePermission_entity") RETURNS "Security"."Role_entity" AS $$ 
SELECT r FROM "Security"."Role_entity" r WHERE r."Name" = $1."RoleID"
$$ LANGUAGE SQL;
COMMENT ON VIEW "MultiPaint"."RegisterArtist_event" IS 'NGS volatile';
COMMENT ON VIEW "MultiPaint"."ChangeArtistName_event" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-")', 'MultiPaint', '-ngs_Artist_type-', 'Artist_entity');
SELECT "-NGS-".Create_Type_Cast('"MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity")', 'MultiPaint', 'Artist_entity', '-ngs_Artist_type-');
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.ActiveUsers"("artist" "MultiPaint"."Artist_entity", "Since" TIMESTAMPTZ) RETURNS BOOL AS 
$$
	SELECT 	 ((("artist"))."LastActiveAt" >= "Artist.ActiveUsers"."Since") 
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;
CREATE OR REPLACE FUNCTION "MultiPaint"."Artist.ActiveUsers"("Since" TIMESTAMPTZ) RETURNS SETOF "MultiPaint"."Artist_entity" AS 
$$SELECT * FROM "MultiPaint"."Artist_entity" "artist"  WHERE 	 ((("artist"))."LastActiveAt" >= "Artist.ActiveUsers"."Since") 
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

SELECT "-NGS-".Persist_Concepts('"dsl\\Artist.dsl"=>"module MultiPaint
{
	/* Each Artist is bound to a unique User*/
	aggregate Artist(UserID) {
		Security.User *User;

		String Name;

		Timestamp CreatedAt { sequence; }
		Timestamp LastActiveAt { Index; }

		specification ActiveUsers ''artist => artist.LastActiveAt >= Since'' {
			Timestamp Since;
		}
	}

	/* Allows unauthorized guests to create new Artists */
	event RegisterArtist {
		String  Name;
		String? UserID;   // output
		String? Password; // output
	}

	/* Changes the current DisplayName for an Artist */
	event ChangeArtistName {
		String NewName;
	}
}
", "dsl\\Security\\Security.dsl"=>"module Security
{
	role Guest;
	role Artist;
	role Admin;

	aggregate User(Name) {
		String(100) Name;
		Role(Name)  *Role;
		Binary      PasswordHash;
		Boolean     IsAllowed;
		implements server ''Revenj.Security.IUser, Revenj.Security'';
	}

	aggregate Role(Name) {
		String(100) Name;
		static Artist ''Artist'';
	}

	aggregate InheritedRole(Name, ParentName) {
		String(100)      Name;
		Role(Name)       *Role;
		String(100)      ParentName;
		Role(ParentName) *ParentRole;
		implements server ''Revenj.Security.IUserRoles, Revenj.Security'';
	}

	aggregate GlobalPermission(Name) {
		String(200) Name;
		bool        IsAllowed;
		implements server ''Revenj.Security.IGlobalPermission, Revenj.Security'';
	}

	aggregate RolePermission(Name, RoleID) {
		String(200) Name;
		Role        *Role;
		bool        IsAllowed;
		implements server ''Revenj.Security.IRolePermission, Revenj.Security'';
	}
}
", "dsl\\Security\\SecurityHelper.dsl"=>"server code <#
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
"', '\x','1.2.0.37489')