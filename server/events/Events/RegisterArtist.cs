using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Revenj.DomainPatterns;
using Revenj.Processing;

namespace MultiPaint
{
	public class RegisterArtist : IServerService<String, Guid>
	{
		private readonly IPersistableRepository<Artist> artistRepository;

		public RegisterArtist(IPersistableRepository<Artist> artistRepository)
		{
			this.artistRepository = artistRepository;
		}

		public Guid Execute(String name)
		{
			var artist = new Artist();
			artist.Name = name;
			artistRepository.Insert(artist);
			return artist.Session; // random Guid
		}
	}
}
