
DO $$ BEGIN
	IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN	
		IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
			RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
		END IF;
	END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
	IF (1, 1) = (SELECT COUNT(*), SUM(CASE WHEN column_name = 'Name' THEN 1 ELSE 0 END) FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'Security' AND type_name = 'Role') THEN	
		INSERT INTO "Security"."Role"("Name") 
		SELECT 'Admin'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Admin');
	END IF;
END $$ LANGUAGE plpgsql;

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
","dsl\\Security\\Security.dsl"=>"module Security
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
","dsl\\Security\\SecurityHelper.dsl"=>"server code <#
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