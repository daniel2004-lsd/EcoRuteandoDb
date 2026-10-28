-- Migration 012: Safe conversion of usage_id from BIGINT to UUID
-- Preserves original BIGINT values in an archive table before conversion.

-- 1. Precondition checks and contradiction validation
DO $$
DECLARE
    v_conflict_count INT := 0;
BEGIN
    -- Check that table mobility.ratings exists and usage_id is of type BIGINT
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'mobility'
          AND table_name = 'ratings'
          AND column_name = 'usage_id'
          AND data_type = 'bigint'
    ) THEN
        RAISE EXCEPTION 'Migration 012 precondition failed: mobility.ratings.usage_id is not BIGINT or does not exist.';
    END IF;

    -- Ensure archive table exists before conflict verification
    CREATE TABLE IF NOT EXISTS mobility.ratings_usage_id_archive (
        rating_id UUID NOT NULL PRIMARY KEY,
        original_usage_id BIGINT,
        was_null BOOLEAN NOT NULL DEFAULT FALSE,
        archived_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    -- Check for conflicting / contradictory values in pre-existing archive entries
    SELECT count(*) INTO v_conflict_count
    FROM mobility.ratings r
    JOIN mobility.ratings_usage_id_archive a ON a.rating_id = r.id
    WHERE (a.original_usage_id IS DISTINCT FROM r.usage_id)
       OR (a.was_null IS TRUE AND r.usage_id IS NOT NULL);

    IF v_conflict_count > 0 THEN
        RAISE EXCEPTION 'Migration 012 aborted: archive conflict detected. % records have contradictory usage_id values between ratings and archive.', v_conflict_count;
    END IF;
END $$;

-- 2. Archive current usage_id values, tracking original BIGINT and preserving original NULL state.
-- Does NOT use ON CONFLICT DO UPDATE to prevent silent overwriting of historical evidence.
INSERT INTO mobility.ratings_usage_id_archive (rating_id, original_usage_id, was_null)
SELECT
    r.id,
    r.usage_id,
    (r.usage_id IS NULL)
FROM mobility.ratings r
ON CONFLICT (rating_id) DO NOTHING;

-- 3. Convert usage_id to UUID only when existing value matches canonical UUID format.
-- Historical BIGINT values become NULL (retained safely in archive). No artificial UUIDs are generated.
ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE UUID
    USING (
        CASE
            WHEN usage_id IS NULL THEN NULL
            WHEN usage_id::text ~ '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
                THEN usage_id::text::uuid
            ELSE NULL
        END
    );

COMMENT ON COLUMN mobility.ratings.usage_id IS 'Converted to UUID; original BIGINT values archived in mobility.ratings_usage_id_archive';
