module MultiPaint
{
  /* Each Artist is bound to a unique User*/
  aggregate Artist(UserID) {
		Security.User *User;
		
		String Name;

		Timestamp CreatedAt { sequence; }
		Timestamp LastActiveAt { Index; }
	}
	
	/* Allows unauthorized guests to create new Artists */
	event RegisterArtist {
		String  Name;
		String? UserID; // output
		String? Password; // output
	}

	/* Changes the current DisplayName for an Artist */	
	event ChangeArtistName {
		String NewName;
	}
}
