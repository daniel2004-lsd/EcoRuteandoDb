-- Rollback 012: Safe rollback of mobility.ratings.usage_id from UUID back to BIGINT
-- Restores original BIGINT values from archive while refusing to proceed if new/modified data cannot be safely restored.

-- 1. Precondition and safety validation before altering column or restoring data
DO $$
DECLARE
    v_new_rows_with_uuid INT := 0;
    v_modified_rows INT := 0;
BEGIN
    -- Check that the archive table exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'mobility'
          AND table_name = 'ratings_usage_id_archive'
    ) THEN
        RAISE EXCEPTION 'Rollback 012 aborted: archive table mobility.ratings_usage_id_archive does not exist. Cannot restore historical data.';
    END IF;

    -- Check that column usage_id exists and is UUID
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'mobility'
          AND table_name = 'ratings'
          AND column_name = 'usage_id'
          AND data_type = 'uuid'
    ) THEN
        RAISE EXCEPTION 'Rollback 012 aborted: column mobility.ratings.usage_id is not of type UUID.';
    END IF;

    -- Detect new ratings created after migration that have a UUID usage_id.
    -- These cannot be converted to BIGINT without destroying the newly assigned UUID.
    SELECT count(*) INTO v_new_rows_with_uuid
    FROM mobility.ratings r
    LEFT JOIN mobility.ratings_usage_id_archive a ON a.rating_id = r.id
    WHERE a.rating_id IS NULL AND r.usage_id IS NOT NULL;

    IF v_new_rows_with_uuid > 0 THEN
        RAISE EXCEPTION 'Rollback 012 aborted: % new ratings have UUID usage_id that cannot be safely converted to BIGINT.', v_new_rows_with_uuid;
    END IF;

    -- Detect original ratings that were modified with a UUID usage_id after migration.
    -- (Migration 012 set historical BIGINTs to NULL; if usage_id is NOT NULL now, it was modified post-migration).
    SELECT count(*) INTO v_modified_rows
    FROM mobility.ratings r
    JOIN mobility.ratings_usage_id_archive a ON a.rating_id = r.id
    WHERE r.usage_id IS NOT NULL;

    IF v_modified_rows > 0 THEN
        RAISE EXCEPTION 'Rollback 012 aborted: % existing ratings have been modified with UUID usage_id after migration. Restoring would overwrite modified data.', v_modified_rows;
    END IF;
END $$;

-- 2. Alter column back to BIGINT. Since all rows with usage_id currently have NULL (validated above),
-- this conversion is safe, lossless and does not produce invalid syntax errors.
ALTER TABLE mobility.ratings
    ALTER COLUMN usage_id TYPE BIGINT
    USING (
        CASE
            WHEN usage_id IS NULL THEN NULL
            WHEN usage_id::text ~ '^[0-9]+$' THEN usage_id::text::bigint
            ELSE NULL
        END
    );

-- 3. Restore original BIGINT values from archive
UPDATE mobility.ratings r
SET usage_id = a.original_usage_id
FROM mobility.ratings_usage_id_archive a
WHERE a.rating_id = r.id
  AND a.was_null IS FALSE;

-- 4. Verify restoration integrity: ensure all original non-null rows have been restored exactly
DO $$
DECLARE
    v_unrestored INT := 0;
BEGIN
    SELECT count(*) INTO v_unrestored
    FROM mobility.ratings r
    JOIN mobility.ratings_usage_id_archive a ON a.rating_id = r.id
    WHERE a.was_null IS FALSE
      AND (r.usage_id IS DISTINCT FROM a.original_usage_id);

    IF v_unrestored > 0 THEN
        RAISE EXCEPTION 'Rollback 012 integrity check failed: % rows do not match original BIGINT values. Archive preserved.', v_unrestored;
    END IF;
END $$;

-- Note: The archive table mobility.ratings_usage_id_archive is intentionally PRESERVED
-- for auditing and historical traceability. It is NOT dropped automatically.
COMMENT ON COLUMN mobility.ratings.usage_id IS 'Reverted to BIGINT from mobility.ratings_usage_id_archive';
