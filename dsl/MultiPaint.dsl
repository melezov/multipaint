module MultiPaint
{
	/* private artist information */
	big aggregate Artist {
		String     Name;
		Guid       Session { Index; }
		Timestamp  CreatedAt { sequence; }

		specification GetArtistBySession 'it => it.Session == Session' {
			Guid Session;
		}
	}

	/* brushes are public and authors are known */
	big aggregate Brush {
		Artist  *Artist;
		String  Color;
	}

	/* request for a new brush */
	event ChangeBrush {
		Guid   Session; // authorization
		String Color;
		Long?  BrushID; // output
	}

	value Position {
		Int  X;
		Int  Y;
	}

	/* one segment of a brush path */
	big aggregate Segment {
		Brush       *Brush;
		Int         Index;
		MouseState  State;
		Position    Position;
		Timestamp   OccurredAt;
	}

	snowflake<Segment> Drawing {
		ID;
		Brush.Color as Color;
		BrushID;
		Index;
		State;
		Position;

		specification GetFromID 'it => it.ID > fromID' {
			Long fromID;
		}

		order by BrushID, Index;
	}

	enum MouseState {
		Press; Drag; Release;
	}

	/* mouse actions create brush segments */
	event MouseAction {
		Guid        Session; // authorization
		Long        BrushID;
		Int         Index;
		MouseState  State;
		Position    Position;
	}
}
