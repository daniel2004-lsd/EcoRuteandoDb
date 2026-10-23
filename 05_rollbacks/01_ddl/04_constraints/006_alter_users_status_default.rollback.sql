-- Reversión segura de H-63: elimina el DEFAULT sin reintroducir la incompatibilidad con chk_users_status.
ALTER TABLE security.users
ALTER COLUMN status DROP DEFAULT;
