ALTER TABLE security.users
DROP CONSTRAINT chk_users_status;

ALTER TABLE security.users
DROP CONSTRAINT chk_users_preferred_language;

ALTER TABLE security.users
DROP CONSTRAINT chk_users_ui_theme;