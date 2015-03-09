/*MIGRATION_DESCRIPTION
--REMOVE: MultiPaint-Artist.ChangeName-NewName
Property NewName will be removed from object Artist.ChangeName in schema MultiPaint
--REMOVE: MultiPaint-Artist.ChangeName
Object Artist.ChangeName will be removed from schema MultiPaint
--CREATE: MultiPaint-ChangeName
New object ChangeName will be created in schema MultiPaint
--CREATE: MultiPaint-ChangeName-NewName
New property NewName will be created for ChangeName in MultiPaint
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace JOIN pg_description d ON r.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_Artist_ChangeName' AND d.description LIKE 'NGS generated%') THEN
		DROP INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_Artist_ChangeName";
	END IF;
END $$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS "MultiPaint"."submit_Artist.ChangeName"("MultiPaint"."Artist.ChangeName_event"[]);
DROP FUNCTION IF EXISTS "MultiPaint"."mark_Artist.ChangeName"(BIGINT[]);
DROP VIEW IF EXISTS "MultiPaint"."Artist.ChangeName_event";
ALTER TABLE "MultiPaint"."Artist.ChangeName" DROP COLUMN IF EXISTS "NewName";

DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace JOIN pg_description d ON c.oid = d.objoid AND d.objsubid = 0 WHERE n.nspname = 'MultiPaint' AND c.relname = 'Artist.ChangeName' AND d.description LIKE 'NGS generated%') THEN
		DROP TABLE "MultiPaint"."Artist.ChangeName";
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'MultiPaint' AND c.relname = 'ChangeName') THEN	
		CREATE TABLE "MultiPaint"."ChangeName" 
		(
			event_id BIGSERIAL PRIMARY KEY,
			queued_at TIMESTAMPTZ NOT NULL DEFAULT(NOW()),
			processed_at TIMESTAMPTZ
		);
		COMMENT ON TABLE "MultiPaint"."ChangeName" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ 
BEGIN
	IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'MultiPaint' AND type_name = 'ChangeName' AND column_name = 'NewName') THEN
		ALTER TABLE "MultiPaint"."ChangeName" ADD COLUMN "NewName" VARCHAR;
	END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "MultiPaint"."ChangeName_event" AS
SELECT _event.event_id::text AS "URI", _event.event_id, _event.queued_at AS "QueuedAt", _event.processed_at AS "ProcessedAt" , _event."NewName"
FROM
	"MultiPaint"."ChangeName" _event
;

CREATE OR REPLACE FUNCTION "MultiPaint"."mark_ChangeName"(_events BIGINT[])
	RETURNS VOID AS
$$
BEGIN
	UPDATE "MultiPaint"."ChangeName" SET processed_at = now() WHERE event_id = ANY(_events) AND processed_at IS NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "MultiPaint"."submit_ChangeName"(IN events "MultiPaint"."ChangeName_event"[], OUT "URI" VARCHAR) 
	RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN

	

	FOR uri IN 
		INSERT INTO "MultiPaint"."ChangeName" (queued_at, processed_at, "NewName")
		SELECT i."QueuedAt", i."ProcessedAt" , i."NewName"
		FROM unnest(events) i
		RETURNING event_id::text
	LOOP
		"URI" = uri;
		newUris = array_append(newUris, uri);
		RETURN NEXT;
	END LOOP;

	PERFORM "-NGS-".Safe_Notify('events', 'MultiPaint.ChangeName', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON VIEW "MultiPaint"."ChangeName_event" IS 'NGS volatile';

DO $$ BEGIN
	IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'MultiPaint' AND r.relname = 'ix_unprocessed_events_MultiPaint_ChangeName') THEN
		CREATE INDEX "ix_unprocessed_events_MultiPaint_ChangeName" ON "MultiPaint"."ChangeName" (event_id) WHERE processed_at IS NULL;
		COMMENT ON INDEX "MultiPaint"."ix_unprocessed_events_MultiPaint_ChangeName" IS 'NGS generated';
	END IF;
END $$ LANGUAGE plpgsql;

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
	event ChangeName {
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