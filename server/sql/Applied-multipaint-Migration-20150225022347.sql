/*MIGRATION_DESCRIPTION
--REMOVE: MultiPaint-Artist-CreatedAt
Property CreatedAt will be removed from object Artist in schema MultiPaint
--REMOVE: MultiPaint-Artist-Session
Property Session will be removed from object Artist in schema MultiPaint
--REMOVE: MultiPaint-Artist-Name
Property Name will be removed from object Artist in schema MultiPaint
--REMOVE: MultiPaint-Artist-ID
Property ID will be removed from object Artist in schema MultiPaint
--REMOVE: MultiPaint-Artist
Object Artist will be removed from schema MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

ALTER TABLE "MultiPaint"."Artist"	ALTER COLUMN "ID" SET DEFAULT NULL;
DROP SEQUENCE IF EXISTS "MultiPaint"."Artist_ID_seq";;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON c.oid = d.objoid WHERE c.conname = 'pk_Artist' AND n.nspname = 'MultiPaint' AND r.relname = 'Artist' AND d.description LIKE 'NGS generated%') THEN
		ALTER TABLE "MultiPaint"."Artist" DROP CONSTRAINT "pk_Artist";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_Artist_Session' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."ix_Artist_Session";
	END IF;
END $$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS "MultiPaint"."Artist.GetArtistBySession"(UUID);
DROP FUNCTION IF EXISTS "MultiPaint"."Artist.GetArtistBySession"("MultiPaint"."Artist_entity", UUID);

CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-") RETURNS "MultiPaint"."Artist_entity" AS $$ SELECT $1::text::"MultiPaint"."Artist_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity") RETURNS "MultiPaint"."-ngs_Artist_type-" AS $$ SELECT $1::text::"MultiPaint"."-ngs_Artist_type-" $$ IMMUTABLE LANGUAGE sql;
DROP VIEW IF EXISTS "MultiPaint"."Artist_unprocessed_events";

DROP FUNCTION IF EXISTS "MultiPaint"."persist_Artist"("MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[], "MultiPaint"."Artist_entity"[]);;

DROP CAST IF EXISTS ("MultiPaint"."-ngs_Artist_type-" AS "MultiPaint"."Artist_entity");
DROP CAST IF EXISTS ("MultiPaint"."Artist_entity" AS "MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."-ngs_Artist_type-");
DROP FUNCTION IF EXISTS "MultiPaint"."cast_Artist_to_type"("MultiPaint"."Artist_entity");
DROP VIEW IF EXISTS "MultiPaint"."Artist_entity";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'CreatedAt' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Artist" DROP COLUMN "CreatedAt";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'CreatedAt' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE "CreatedAt";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'Session' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Artist" DROP COLUMN "Session";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'Session' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE "Session";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Artist" DROP COLUMN "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'Name' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE "Name";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'Artist' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TABLE "MultiPaint"."Artist" DROP COLUMN "ID";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = '-ngs_Artist_type-' AND column_name = 'ID' AND is_ngs_generated) THEN
		ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE "ID";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TYPE "MultiPaint"."-ngs_Artist_type-" DROP ATTRIBUTE IF EXISTS "URI";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist_sequence' AND d.description LIKE 'NGS generated%') THEN
		DROP SEQUENCE "MultiPaint"."Artist_sequence";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."Artist";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = '-ngs_Artist_type-' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."-ngs_Artist_type-";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		INSERT INTO "Security"."Role"("Name") 
		SELECT 'Artist'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Artist');
	END IF;
END $$ LANGUAGE plpgsql;

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
/*	big aggregate Artist {
		Security.User *User;
		Timestamp     CreatedAt { sequence; }
		Timestamp     LastActiveAt { versioning; }
	}
	*/
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
	permissions
	{
		filter Role	''it => it.Name == Thread.CurrentPrincipal.Identity.Name'' except Administrator;
		filter User	''it => it.Name == Thread.CurrentPrincipal.Identity.Name'' except Administrator;
	} 

	role Administrator;
	role Artist;

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