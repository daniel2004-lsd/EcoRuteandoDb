ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE UUID
    USING usage_id::text::uuid;
