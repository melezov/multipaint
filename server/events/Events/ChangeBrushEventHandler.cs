using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Revenj.DomainPatterns;

namespace MultiPaint
{
	public class ChangeBrushEventHandler : IDomainEventHandler<ChangeBrush>
	{
		private readonly IQueryableRepository<Artist> artistRepository;
		private readonly IPersistableRepository<Brush> brushRepository;

		public ChangeBrushEventHandler(
			IQueryableRepository<Artist> artistRepository,
			IPersistableRepository<Brush> brushRepository)
		{
			this.artistRepository = artistRepository;
			this.brushRepository = brushRepository;
		}

		public void Handle(ChangeBrush domainEvent)
		{
			var session = domainEvent.Session;
			var artistSearch = new Artist.GetArtistBySession(domainEvent.Session);
			var artists = artistRepository.Search(artistSearch, 1, 0);
			if (artists.Length != 1)
				throw new ArgumentException("Unauthorized; session \"" + session + "\" does not exist!");

			var brush = new Brush();
			brush.Artist = artists[0];
			brush.Color = domainEvent.Color;
			brushRepository.Insert(brush);

			// return new brush identifier via the event instance
			domainEvent.BrushID = brush.ID;
		}
	}
}
