ALTER TABLE security.users
ALTER COLUMN status
TYPE security.user_status
USING status::security.user_status;

ALTER TABLE security.users
ALTER COLUMN preferred_language
TYPE security.preferred_language
USING preferred_language::security.preferred_language;

ALTER TABLE security.users
ALTER COLUMN ui_theme
TYPE security.ui_theme
USING ui_theme::security.ui_theme;