/*MIGRATION_DESCRIPTION
--CREATE: Security-GlobalPermission
New object GlobalPermission will be created in schema Security
--CREATE: Security-GlobalPermission-Name
New property Name will be created for GlobalPermission in Security
--CREATE: Security-GlobalPermission-IsAllowed
New property IsAllowed will be created for GlobalPermission in Security
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'Security') THEN
		CREATE SCHEMA "Security";
		COMMENT ON SCHEMA "Security" IS 'NGS generated';
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

CREATE OR REPLACE VIEW "Security"."GlobalPermission_entity" AS
SELECT CAST(_entity."Name" as TEXT) AS "URI" , _entity."Name", _entity."IsAllowed"
FROM
	"Security"."GlobalPermission" _entity
	;
COMMENT ON VIEW "Security"."GlobalPermission_entity" IS 'NGS volatile';

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

SELECT "-NGS-".Create_Type_Cast('"Security"."cast_GlobalPermission_to_type"("Security"."-ngs_GlobalPermission_type-")', 'Security', '-ngs_GlobalPermission_type-', 'GlobalPermission_entity');
SELECT "-NGS-".Create_Type_Cast('"Security"."cast_GlobalPermission_to_type"("Security"."GlobalPermission_entity")', 'Security', 'GlobalPermission_entity', '-ngs_GlobalPermission_type-');
UPDATE "Security"."GlobalPermission" SET "Name" = '' WHERE "Name" IS NULL;
UPDATE "Security"."GlobalPermission" SET "IsAllowed" = false WHERE "IsAllowed" IS NULL;

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
ALTER TABLE "Security"."GlobalPermission" ALTER "Name" SET NOT NULL;
ALTER TABLE "Security"."GlobalPermission" ALTER "IsAllowed" SET NOT NULL;

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
/*	aggregate User(Name) {
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
*/
	aggregate GlobalPermission(Name) {
		String(200)  Name;
		bool         IsAllowed;
		implements server ''Revenj.Security.IGlobalPermission, Revenj.Security'';
	}
/*
	aggregate RolePermission(Name, RoleID) {
		String(200)  Name;
		Role         *Role;
		bool         IsAllowed;
		implements server ''Revenj.Security.IRolePermission, Revenj.Security'';
	}
	*/
}
/*
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
*/"', '\x','1.0.3.34768')