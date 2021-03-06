module Security
{
	role Guest;
	role Artist;
	role Admin;

	aggregate User(Name) {
		String(100) Name;
		Role(Name)  *Role;
		Binary      PasswordHash;
		Boolean     IsAllowed;
		implements server 'Revenj.Security.IUser';
	}

	aggregate Role(Name) {
		String(100) Name;
		static Artist 'Artist';
	}

	aggregate InheritedRole(Name, ParentName) {
		String(100)      Name;
		Role(Name)       *Role;
		String(100)      ParentName;
		Role(ParentName) *ParentRole;
		implements server 'Revenj.Security.IUserRoles';
	}

	aggregate GlobalPermission(Name) {
		String(200) Name;
		bool        IsAllowed;
		implements server 'Revenj.Security.IGlobalPermission';
	}

	aggregate RolePermission(Name, RoleID) {
		String(200) Name;
		Role        *Role;
		bool        IsAllowed;
		implements server 'Revenj.Security.IRolePermission';
	}
}
