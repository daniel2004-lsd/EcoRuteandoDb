-- H-63: Corrige el valor DEFAULT de security.users.status para alinearlo con chk_users_status y el dominio C#
ALTER TABLE security.users
ALTER COLUMN status SET DEFAULT 'active';
