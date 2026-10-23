ALTER TABLE security.users
ALTER COLUMN status SET DEFAULT 'ACTIVE'::security.user_status;
