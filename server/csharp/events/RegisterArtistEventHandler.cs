using Revenj.DomainPatterns;
using Security;
using System;
using System.Security.Cryptography;
using System.Text;

namespace MultiPaint
{
	public class RegisterArtistEventHandler : IDomainEventHandler<RegisterArtist>
	{
		private readonly IPersistableRepository<User> userRepository;
		private readonly IPersistableRepository<Role> roleRepository;
		private readonly IPersistableRepository<InheritedRole> inheritedRoleRepository;
		private readonly IPersistableRepository<Artist> artistRepository;

		public RegisterArtistEventHandler(
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

		private static readonly SHA1 SHA1 = SHA1.Create();

		public void Handle(RegisterArtist domainEvent)
		{
			var name = domainEvent.Name.Trim();
			if (name.Length == 0)
				throw new ArgumentException("Artist name cannot be empty!");

			// let's create a random userID and password for this Artist
			var random = Guid.NewGuid().ToString();
			var splitAt = random.LastIndexOf('-');
			var userID = random.Substring(0, splitAt);
			var password = random.Substring(splitAt + 1);

			// create a new role for this user
			var role = new Role();
			role.Name = userID;
			roleRepository.Insert(role);

			// the new role will inherit all of Artist's permissions
			var inheritedRole = new InheritedRole();
			inheritedRole.Role = role;
			inheritedRole.ParentRole = Role.Artist;
			inheritedRoleRepository.Insert(inheritedRole);

			// the password will be hashed and stored within the User entity
			var user = new User();
			user.Role = role;
			user.IsAllowed = true;
			user.PasswordHash = SHA1.ComputeHash(Encoding.UTF8.GetBytes(password));
			userRepository.Insert(user);

			var artist = new Artist();
			artist.User = user;
			artist.Name = name;
			artistRepository.Insert(artist);

			// we will return the newly generated credentials by mutating the originating event
			domainEvent.UserID = userID;
			domainEvent.Password = password;
		}
	}
}
