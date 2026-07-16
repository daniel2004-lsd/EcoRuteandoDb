ALTER TABLE security.users
ALTER COLUMN status TYPE varchar(20)
USING status::text;

ALTER TABLE security.users
ALTER COLUMN preferred_language TYPE varchar(10)
USING preferred_language::text;

ALTER TABLE security.users
ALTER COLUMN ui_theme TYPE varchar(20)
USING ui_theme::text;