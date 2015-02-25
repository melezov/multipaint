
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
		SELECT 'Guest'
		WHERE NOT EXISTS(SELECT * FROM "Security"."Role" WHERE "Name" = 'Guest');
	END IF;
END $$ LANGUAGE plpgsql;

SELECT "-NGS-".Persist_Concepts('"d:\\Code\\multipaint\\dsl\\MultiPaint.dsl"=>"module MultiPaint
{
	big aggregate Artist {
		Security.User *User;
		Timestamp     CreatedAt { sequence; }
		Timestamp     LastActiveAt { versioning; }
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