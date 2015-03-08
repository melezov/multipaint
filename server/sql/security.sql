-- TRUNCATE "MultiPaint"."Artist", "MultiPaint"."Brush", "MultiPaint"."Segment";
-- DELETE FROM "Security"."User" WHERE "Name" NOT IN ('Guest', 'Administrator');

INSERT INTO "Security"."GlobalPermission" ("Name", "IsAllowed") VALUES
('MultiPaint.Artist', true),
('MultiPaint.ArtistBrushes', true);

INSERT INTO "User" ("Name", "PasswordHash", "IsAllowed") VALUES 
('Administrator', '\x747b92d1e6dd851939b298fa87ab6a7c1ae05608', true);
('Guest', '\xface83ee3014bdc8f98203cc94e2e89222452e90', true);

