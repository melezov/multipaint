/*MIGRATION_DESCRIPTION
--REMOVE: MultiPaint-MouseAction-State
Property State will be removed from object MouseAction in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Release
Enum label Release will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Drag
Enum label Drag will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Press
Enum label Press will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState-Move
Enum label Move will be removed from enum object MouseState in schema MultiPaint
--REMOVE: MultiPaint-MouseState
Object MouseState will be removed from schema MultiPaint
--RENAME: MultiPaint-MouseAction -> MultiPaint-BrushAction
Object MouseAction will be renamed to BrushAction in schema MultiPaint
--CREATE: MultiPaint-BrushState
New object BrushState will be created in schema MultiPaint
--CREATE: MultiPaint-BrushState-Hover
New enum label Hover will be added to enum object BrushState in schema MultiPaint
--CREATE: MultiPaint-BrushState-Press
New enum label Press will be added to enum object BrushState in schema MultiPaint
--CREATE: MultiPaint-BrushState-Draw
New enum label Draw will be added to enum object BrushState in schema MultiPaint
--CREATE: MultiPaint-BrushState-Lift
New enum label Lift will be added to enum object BrushState in schema MultiPaint
--CREATE: MultiPaint-BrushAction-State
New property State will be created for BrushAction in MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_MouseAction"("MultiPaint"."MouseAction_event"[]);
DROP FUNCTION IF EXISTS "MultiPaint"."mark_MouseAction"(BIGINT[]);
DROP VIEW IF EXISTS "MultiPaint"."MouseAction_event";
ALTER TABLE "MultiPaint"."MouseAction" DROP COLUMN IF EXISTS "State";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace JOIN pg_description d ON t.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND t.typname = 'MouseState' AND d.description LIKE 'NGS generated%') THEN
		DROP TYPE "MultiPaint"."MouseState";
	END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "MultiPaint"."MouseAction" RENAME TO "BrushAction";

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState') THEN	
		CREATE TYPE "MultiPaint"."BrushState" AS ENUM ('Hover', 'Press', 'Draw', 'Lift');
		COMMENT ON TYPE "MultiPaint"."BrushState" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState' AND e.enumlabel = 'Hover') THEN
		--ALTER TYPE "MultiPaint"."BrushState" ADD VALUE IF NOT EXISTS 'Hover'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Hover', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState' AND e.enumlabel = 'Press') THEN
		--ALTER TYPE "MultiPaint"."BrushState" ADD VALUE IF NOT EXISTS 'Press'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Press', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState' AND e.enumlabel = 'Draw') THEN
		--ALTER TYPE "MultiPaint"."BrushState" ADD VALUE IF NOT EXISTS 'Draw'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Draw', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState' AND e.enumlabel = 'Lift') THEN
		--ALTER TYPE "MultiPaint"."BrushState" ADD VALUE IF NOT EXISTS 'Lift'; -- this doesn't work inside a transaction ;( use a hack to add new values...
		--TODO: detect OID wraparounds and throw an exception in that case
		INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
		SELECT t.oid, 'Lift', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
		FROM pg_type t 
		INNER JOIN pg_namespace n ON n.oid = t.typnamespace 
		WHERE n.nspname = 'MultiPaint' AND t.typname = 'BrushState';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'BrushAction' AND column_name = 'State') THEN
		ALTER TABLE "MultiPaint"."BrushAction" ADD COLUMN "State" "MultiPaint"."BrushState";
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "MultiPaint"."BrushAction_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."BrushID", _event."Index", _event."State", _event."Position"
FROM
	"MultiPaint"."BrushAction" _event
;

CREATE OR REPLACE FUNCTION "MultiPaint"."mark_BrushAction"(_events BIGINT[])
	RETURNS VOID AS
$$
BEGIN
	UPDATE "MultiPaint"."BrushAction" SET processed_at = now() WHERE event_id = ANY(_events) AND processed_at IS NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_BrushAction"(IN events "MultiPaint"."BrushAction_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."BrushAction" (queued_at, processed_at, "BrushID", "Index", "State", "Position")
		SELECT i."QueuedAt", i."ProcessedAt" , i."BrushID", i."Index", i."State", i."Position"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.BrushAction', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON VIEW "MultiPaint"."BrushAction_event" IS 'NGS volatile';

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
	/* Each visitor creates a new Artist */
	aggregate Artist(Name) {
		String(100)          Name;
		Security.User(Name)  *User;

		Timestamp  CreatedAt { sequence; }
		Timestamp  LastActiveAt;
	}
		
	/* Artists create Brushes in order to draw */
	big aggregate Brush {
		Artist    *Artist;
		String    Color;
		Int       Thickness;
		Position? LastPosition;
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
	enum BrushState {
		Hover; Press; Draw; Lift;
	}

	/* mouse actions create brush segments */
	event BrushAction {
		Long        BrushID;
		Int         Index;
		BrushState  State;
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