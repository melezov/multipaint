package net.multipaint
package Security

import hr.ngs.patterns._

package object postgres {
	def initialize(container: IContainer) {
		val locator = container[IServiceLocator]
		val postgresUtils = locator.resolve[PostgresUtils]
		
		net.multipaint.Security.postgres.UserConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.Security.postgres.UserRepository, net.multipaint.Security.IUserRepository]
		container.register[net.multipaint.Security.postgres.UserRepository, IRepository[net.multipaint.Security.User]]
		net.multipaint.Security.postgres.RoleConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.Security.postgres.RoleRepository, net.multipaint.Security.IRoleRepository]
		container.register[net.multipaint.Security.postgres.RoleRepository, IRepository[net.multipaint.Security.Role]]
		net.multipaint.Security.postgres.InheritedRoleConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.Security.postgres.InheritedRoleRepository, net.multipaint.Security.IInheritedRoleRepository]
		container.register[net.multipaint.Security.postgres.InheritedRoleRepository, IRepository[net.multipaint.Security.InheritedRole]]
		net.multipaint.Security.postgres.GlobalPermissionConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.Security.postgres.GlobalPermissionRepository, net.multipaint.Security.IGlobalPermissionRepository]
		container.register[net.multipaint.Security.postgres.GlobalPermissionRepository, IRepository[net.multipaint.Security.GlobalPermission]]
		net.multipaint.Security.postgres.RolePermissionConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.Security.postgres.RolePermissionRepository, net.multipaint.Security.IRolePermissionRepository]
		container.register[net.multipaint.Security.postgres.RolePermissionRepository, IRepository[net.multipaint.Security.RolePermission]]
		container.register[net.multipaint.Security.postgres.UserRepository, IPersistableRepository[net.multipaint.Security.User]]
		container.register[net.multipaint.Security.postgres.RoleRepository, IPersistableRepository[net.multipaint.Security.Role]]
		container.register[net.multipaint.Security.postgres.InheritedRoleRepository, IPersistableRepository[net.multipaint.Security.InheritedRole]]
		container.register[net.multipaint.Security.postgres.GlobalPermissionRepository, IPersistableRepository[net.multipaint.Security.GlobalPermission]]
		container.register[net.multipaint.Security.postgres.RolePermissionRepository, IPersistableRepository[net.multipaint.Security.RolePermission]]
	}
}