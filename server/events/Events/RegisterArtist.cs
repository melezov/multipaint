using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Revenj.DomainPatterns;
using Revenj.Processing;
using Security;
using System.Security;
using System.Security.Cryptography;

namespace MultiPaint
{
	public class RegisterArtist : IServerService<String, String>
	{
		private static readonly SHA1 SHA1 = SHA1.Create();

		private readonly IPersistableRepository<User> userRepository;
		private readonly IPersistableRepository<Role> roleRepository;
		private readonly IPersistableRepository<InheritedRole> inheritedRoleRepository;
		private readonly IPersistableRepository<Artist> artistRepository;

		public RegisterArtist(
			IPersistableRepository<User> userRepository,
			IPersistableRepository<Role> roleRepository,
			IPersistableRepository<InheritedRole> inheritedRoleRepository,
			IPersistableRepository<Artist> artistRepository)
		{
			this.userRepository = userRepository;
			this.roleRepository = roleRepository;
			this.inheritedRoleRepository = inheritedRoleRepository;
			this.artistRepository = artistRepository;
		}

		public String Execute(String name)
		{
			if (String.IsNullOrWhiteSpace(name))
				throw new ArgumentException("Artist name cannot be empty!");

			// try to reserve requested name
			var requestedName = name;
			var user = userRepository.Find(requestedName);
			// if such a name already exists, create a unique suffix
			while (user != null) {
				name = requestedName + "-" + Guid.NewGuid();
				user = userRepository.Find(name);
			}

			// create a new role for this user
			var role = new Role();
			role.Name = name;
			roleRepository.Insert(role);

			// the new role will inherit Artist permissions
			var inheritedRole = new InheritedRole();
			inheritedRole.Role = role;
			inheritedRole.ParentRole = Role.Artist;
			inheritedRoleRepository.Insert(inheritedRole);

			// let's create a random password for this user
			var password = Guid.NewGuid().ToString();

			// the password will be hashed and stored within the User entity
			user = new User();
			user.Role = role;
			user.IsAllowed = true;
			user.PasswordHash = SHA1.ComputeHash(Encoding.UTF8.GetBytes(password));
			userRepository.Insert(user);

			var artist = new Artist();
			artist.User = user;
			artistRepository.Insert(artist);

			// we will now create the Base64 auth token and return it to the client
			// so that it's trivial to re-send this token back without processing
			// (no need for Base64 encoding on the client side)
			var authToken = name + ":" + password;
			return Convert.ToBase64String(Encoding.UTF8.GetBytes(authToken));
		}
	}
}
