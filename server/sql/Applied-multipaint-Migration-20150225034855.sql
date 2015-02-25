/*MIGRATION_DESCRIPTION
--RENAME: MultiPaint-ChangeBrush-BrushID -> BrushURI
Property BrushID will be renamed to BrushURI for object ChangeBrush in schema MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_ChangeBrush"("MultiPaint"."ChangeBrush_event"[]);
DROP VIEW IF EXISTS "MultiPaint"."ChangeBrush_event";
ALTER TABLE "MultiPaint"."ChangeBrush" RENAME "BrushID" TO "BrushURI";
ALTER TABLE "MultiPaint"."ChangeBrush" ALTER "BrushURI" TYPE VARCHAR ;

CREATE OR REPLACE VIEW "MultiPaint"."ChangeBrush_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."Color", _event."Thickness", _event."BrushURI"
FROM
	"MultiPaint"."ChangeBrush" _event
;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_ChangeBrush"(IN events "MultiPaint"."ChangeBrush_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."ChangeBrush" (queued_at, processed_at, "Color", "Thickness", "BrushURI")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Color", i."Thickness", i."BrushURI"
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
COMMENT ON VIEW "MultiPaint"."ChangeBrush_event" IS 'NGS volatile';

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
	/* Each visitor creates a new Artist */
	aggregate Artist(Name) {
		String(100)          Name;
		Security.User(Name)  *User;

		Timestamp     CreatedAt { sequence; }
		Timestamp     LastActiveAt { versioning; }
		List<Brush>   Brushes;
	}
	
	/* Artists create Brushes in order to draw */
	entity Brush {
		Artist  *Artist;
		String  Color;
		Int     Thickness;
	}

	/* request for a new brush */
	event ChangeBrush {
		String  Color;
		Int     Thickness;
		String?   BrushURI; // output
	}

/*
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