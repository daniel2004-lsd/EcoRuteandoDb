-- Cambia profile_photo_url de VARCHAR(500) a TEXT para almacenar fotos base64
ALTER TABLE security.users ALTER COLUMN profile_photo_url TYPE TEXT;
