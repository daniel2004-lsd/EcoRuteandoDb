ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE BIGINT
    USING usage_id::text::bigint;
