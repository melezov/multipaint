INSERT INTO "Security"."GlobalPermission" ("Name", "IsAllowed") VALUES
('Security', false),
('MultiPaint', false);

INSERT INTO "Security"."RolePermission" ("Name", "RoleID", "IsAllowed") VALUES
('MultiPaint.RegisterArtist', 'Guest', true);
('MultiPaint.ChangeArtistName', 'Artist', true);

INSERT INTO "Security"."User" ("Name", "PasswordHash", "IsAllowed") VALUES
('Guest', '\xface83ee3014bdc8f98203cc94e2e89222452e90', true);
