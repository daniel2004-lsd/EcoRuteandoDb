-- Rollback resiliente para H-52: convierte valores numéricos a BIGINT y asigna NULL a identificadores UUID no convertibles
ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE BIGINT
    USING (
        CASE 
            WHEN usage_id IS NULL THEN NULL
            WHEN usage_id::text ~ '^[0-9]+$' THEN usage_id::text::bigint
            ELSE NULL
        END
    );
