/*MIGRATION_DESCRIPTION
--RENAME: MultiPaint-RegisterArtist-SecurityToken -> AuthToken
Property SecurityToken will be renamed to AuthToken for object RegisterArtist in schema MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_RegisterArtist"("MultiPaint"."RegisterArtist_event"[]);
DROP VIEW IF EXISTS "MultiPaint"."RegisterArtist_event";
ALTER TABLE "MultiPaint"."RegisterArtist" RENAME "SecurityToken" TO "AuthToken";

CREATE OR REPLACE VIEW "MultiPaint"."RegisterArtist_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."Name", _event."AuthToken"
FROM
	"MultiPaint"."RegisterArtist" _event
;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_RegisterArtist"(IN events "MultiPaint"."RegisterArtist_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."RegisterArtist" (queued_at, processed_at, "Name", "AuthToken")
		SELECT i."QueuedAt", i."ProcessedAt" , i."Name", i."AuthToken"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.RegisterArtist', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON VIEW "MultiPaint"."RegisterArtist_event" IS 'NGS volatile';

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
		Binary? AuthToken; // output
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