//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using Revenj.DomainPatterns;
//using Security;
//using System.Threading;
//using System.Text.RegularExpressions;

//namespace MultiPaint
//{
//	public class ChangeBrushEventHandler : IDomainEventHandler<ChangeBrush>
//	{
//		private readonly IPersistableRepository<Artist> artistRepository;
//		private readonly IPersistableRepository<Brush> brushRepository;

//		public ChangeBrushEventHandler(
//			IPersistableRepository<Artist> artistRepository,
//			IPersistableRepository<Brush> brushRepository)
//		{
//			this.brushRepository = brushRepository;
//			this.artistRepository = artistRepository;
//		}

//		private static readonly Regex ColorRegex = new Regex("^#[0-9A-Fa-f]{6}$");
//		private static readonly int MinThickness = 10;
//		private static readonly int MaxThickness = 250;

//		public void Handle(ChangeBrush domainEvent)
//		{
//			var artistName = Thread.CurrentPrincipal.Identity.Name;
//			var artist = artistRepository.Find(artistName);
//			if (artist == null)
//				throw new ArgumentException("Unauthorized; artist \"" + artistName + "\" does not exist");

//			// Brush parameter validation 
//			var color = domainEvent.Color;
//			if (!ColorRegex.IsMatch(color))
//				throw new ArgumentException("Invalid color \"" + color + "\", it should be in #rrggbb format");

//			var thickness = domainEvent.Thickness;
//			if (thickness < MinThickness || thickness > MaxThickness)
//				throw new ArgumentException("Invalid thickness (" + thickness + "), valid range is [" + MinThickness + ".." + MaxThickness + "]");

//			// Create a new brush for this artist 
//			var brush = new Brush();
//			brush.Artist = artist;
//			brush.Color = domainEvent.Color;
//			brush.Thickness = domainEvent.Thickness;
//			brushRepository.Insert(brush);

//			// Update artist activity
//			artist.LastActiveAt = domainEvent.QueuedAt;
//			artistRepository.Update(artist);

//			// return new brush identifier via the event instance
//			domainEvent.BrushID = brush.ID;
//		}
//	}
//}
