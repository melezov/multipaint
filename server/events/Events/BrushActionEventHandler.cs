//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using Revenj.DomainPatterns;
//using System.Threading;

//namespace MultiPaint
//{
//	public class BrushActionEventHandler : IDomainEventHandler<BrushAction>
//	{
//		private readonly IPersistableRepository<Brush> brushRepository;
//		private readonly IPersistableRepository<Segment> segmentRepository;

//		public BrushActionEventHandler(
//			IPersistableRepository<Brush> brushRepository,
//			IPersistableRepository<Segment> segmentRepository)
//		{
//			this.brushRepository = brushRepository;
//			this.segmentRepository = segmentRepository;
//		}

//		public void Handle(BrushAction domainEvent)
//		{
//			var brushURI = domainEvent.BrushID.ToString();
//			var brush = brushRepository.Find(brushURI);
//			if (brush == null)
//				throw new ArgumentException("Brush #" + brushURI + " does not exist");

//			var artistName = Thread.CurrentPrincipal.Identity.Name;
//			if (artistName != brush.ArtistID)
//				throw new ArgumentException("Unauthorized; this brush does not belong to \"" + artistName + "\"");
///*
//			var segment = new Segment();
//			segment.Brush = brush;
//			segment.Index = domainEvent.Index;
//			segment.Tracking = domainEvent.Tracking;
//			segment.OccurredAt = domainEvent.QueuedAt;
//			segmentRepository.Insert(segment);
//*/
//			brush.LastTracking = domainEvent.Tracking;
//			brushRepository.Update(brush);
//		}
//	}
//}
