/*MIGRATION_DESCRIPTION
--RENAME: MultiPaint-ChangeName -> MultiPaint-ChangeArtistName
Object ChangeName will be renamed to ChangeArtistName in schema MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_ChangeName"("MultiPaint"."ChangeName_event"[]);
DROP FUNCTION IF EXISTS "MultiPaint"."mark_ChangeName"(BIGINT[]);
DROP VIEW IF EXISTS "MultiPaint"."ChangeName_event";
ALTER TABLE "MultiPaint"."ChangeName" RENAME TO "ChangeArtistName";

CREATE OR REPLACE VIEW "MultiPaint"."ChangeArtistName_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."NewName"
FROM
	"MultiPaint"."ChangeArtistName" _event
;

CREATE OR REPLACE FUNCTION "MultiPaint"."mark_ChangeArtistName"(_events BIGINT[])
	RETURNS VOID AS
$$
BEGIN
	UPDATE "MultiPaint"."ChangeArtistName" SET processed_at = now() WHERE event_id = ANY(_events) AND processed_at IS NULL;
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
		INSERT INTO "MultiPaint"."ChangeArtistName" (queued_at, processed_at, "NewName")
		SELECT i."QueuedAt", i."ProcessedAt" , i."NewName"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.ChangeArtistName', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON VIEW "MultiPaint"."ChangeArtistName_event" IS 'NGS volatile';

SELECT "-NGS-".Persist_Concepts('"D:\\Code\\multipaint\\dsl\\Artist.dsl"=>"module MultiPaint
{
  /* Each Artist is bound to a unique User*/
  aggregate Artist(UserID) {
		Security.User *User;
		
		String Name;

		Timestamp CreatedAt { sequence; }
		Timestamp LastActiveAt { Index; }
	}
	
	/* Allows unauthorized guests to create new Artists */
	event RegisterArtist {
		String  Name;
		Binary? SecurityToken; // output
	}

	/* Changes the current DisplayName for an Artist */	
	event ChangeArtistName {
		String NewName;
	}
}
","D:\\Code\\multipaint\\dsl\\Security\\Security.dsl"=>"module Security
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