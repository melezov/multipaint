using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Revenj.DomainPatterns;
using Revenj.Processing;
using Security;
using System.Security;
using System.Security.Cryptography;
using System.Threading;

namespace MultiPaint
{
	public class ChangeNameEventHandler : IDomainEventHandler<ChangeArtistName>
	{
		private readonly IPersistableRepository<Artist> artistRepository;

		public ChangeNameEventHandler(
			IPersistableRepository<Artist> artistRepository)
		{
			this.artistRepository = artistRepository;
		}

		public void Handle(ChangeArtistName domainEvent)
		{
			var newName = domainEvent.NewName.Trim();
			if (newName.Length == 0)
				throw new ArgumentException("Artist name cannot be empty!");

			var userID = Thread.CurrentPrincipal.Identity.Name;
			var artist = artistRepository.Find(userID);

			if (artist.Name != newName)
			{
				artist.Name = newName;
				artistRepository.Update(artist);
			}
		}
	}
}
