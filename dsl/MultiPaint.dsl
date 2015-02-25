module MultiPaint
{
	/* Each visitor creates a new Artist */
	aggregate Artist(Name) {
		String(100)          Name;
		Security.User(Name)  *User;

		Timestamp  CreatedAt { sequence; }
		Timestamp  LastActiveAt;
	}
		
	/* Artists create Brushes in order to draw */
	big aggregate Brush {
		Artist    *Artist;
		String    Color;
		Int       Thickness;
		Position? LastPosition;
	}

	/* request for a new brush */
	event ChangeBrush {
		String  Color;
		Int     Thickness;
		Long?   BrushID; // output
	}

	value Position {
		Int  X;
		Int  Y;
	}

	/* one segment of a brush path 
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

*/
	enum BrushState {
		Hover; Press; Draw; Lift;
	}

	/* mouse actions create brush segments */
	event BrushAction {
		Long        BrushID;
		Int         Index;
		BrushState  State;
		Position    Position;
	}
}
