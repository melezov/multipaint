using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Revenj.DomainPatterns;

namespace MultiPaint
{
	public class MouseActionEventHandler : IDomainEventHandler<MouseAction>
	{
		private readonly IRepository<Brush> brushRepository;
		private readonly IPersistableRepository<Segment> segmentRepository;

		public MouseActionEventHandler(
			IRepository<Brush> brushRepository,
			IPersistableRepository<Segment> segmentRepository)
		{
			this.brushRepository = brushRepository;
			this.segmentRepository = segmentRepository;
		}

		public void Handle(MouseAction domainEvent)
		{
			var session = domainEvent.Session.ToString();
			var brushURI = domainEvent.BrushID.ToString();

			var brush = brushRepository.Find(brushURI);
			if (brush == null)
				throw new ArgumentException("Brush #" + brushURI + " does not exist!");

			if (session != brush.Artist.Session.ToString())
				throw new ArgumentException("Unauthorized; session \"" + session + "\" does not exist!");

			var segment = new Segment();
			segment.Brush = brush;
			segment.Index = domainEvent.Index;
			segment.State = domainEvent.State;
			segment.Position = domainEvent.Position;
			segment.OccurredAt = domainEvent.QueuedAt;
			segmentRepository.Insert(segment);
		}
	}
}
