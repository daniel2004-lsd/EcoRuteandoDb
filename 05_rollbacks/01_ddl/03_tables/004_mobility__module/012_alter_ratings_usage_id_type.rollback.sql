-- Rollback resiliente para H-52: asigna NULL a los UUID al revertir a BIGINT para evitar fallos de conversión. La migración es unidireccional para UUID genuinos; consultar ADR-004.
ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE BIGINT
    USING (
        CASE 
            WHEN usage_id IS NULL THEN NULL
            WHEN usage_id::text ~ '^[0-9]+$' THEN usage_id::text::bigint
            ELSE NULL
        END
    );
