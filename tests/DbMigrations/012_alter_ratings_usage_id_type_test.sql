-- ============================================================================
-- Test Suite for Migration 012 and Rollback 012
-- Target: Safe alteration of mobility.ratings.usage_id from BIGINT to UUID
-- Execution: psql -v ON_ERROR_STOP=1 -f 012_alter_ratings_usage_id_type_test.sql
-- (Run from the tests/DbMigrations/ directory on a disposable test database)
-- ============================================================================

\set ON_ERROR_STOP 1

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS mobility;

-- Helper to set up clean table matching 009_create_table_ratings.sql
CREATE OR REPLACE PROCEDURE mobility.test_setup_clean_ratings()
LANGUAGE plpgsql AS $$
BEGIN
    DROP TABLE IF EXISTS mobility.ratings_usage_id_archive CASCADE;
    DROP TABLE IF EXISTS mobility.ratings CASCADE;

    CREATE TABLE mobility.ratings (
        id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id       UUID     NOT NULL,
        route_id      UUID     NOT NULL,
        usage_id      BIGINT,
        rating        SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
        comment       TEXT,
        helpful_count INT NOT NULL DEFAULT 0,
        is_published  BOOLEAN NOT NULL DEFAULT TRUE,
        created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
        updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
        UNIQUE (user_id, route_id)
    );
END;
$$;

-- ----------------------------------------------------------------------------
-- TEST 1: Empty Table Migration & Rollback
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

-- Run real migration file on empty table
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql

DO $$
BEGIN
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'uuid', 'TEST 1 FAILED: usage_id is not UUID after migration on empty table';
    RAISE NOTICE 'TEST 1 (Empty table migration): PASSED';
END $$;

-- Run real rollback file on empty table
\i ../../05_rollbacks/01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.rollback.sql

DO $$
BEGIN
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'bigint', 'TEST 1 FAILED: usage_id is not BIGINT after rollback on empty table';
    RAISE NOTICE 'TEST 1 (Empty table rollback): PASSED';
END $$;

-- ----------------------------------------------------------------------------
-- TEST 2: Historical Values (NULL, 1, 123456789012345, MAX BIGINT)
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('11111111-1111-1111-1111-111111111111', uuid_generate_v4(), uuid_generate_v4(), NULL, 5),
    ('22222222-2222-2222-2222-222222222222', uuid_generate_v4(), uuid_generate_v4(), 1, 4),
    ('33333333-3333-3333-3333-333333333333', uuid_generate_v4(), uuid_generate_v4(), 123456789012345, 3),
    ('44444444-4444-4444-4444-444444444444', uuid_generate_v4(), uuid_generate_v4(), 9223372036854775807, 5);

-- Apply Migration using real migration script
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql

DO $$
DECLARE
    v_archived_count INT;
    v_non_null_usage INT;
BEGIN
    -- Check column type is UUID
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'uuid', 'TEST 2 FAILED: usage_id is not UUID';

    -- Check all historical ratings in ratings table have usage_id IS NULL
    SELECT count(*) INTO v_non_null_usage FROM mobility.ratings WHERE usage_id IS NOT NULL;
    ASSERT v_non_null_usage = 0, 'TEST 2 FAILED: historical BIGINT values were not converted to NULL';

    -- Check archive table contents
    SELECT count(*) INTO v_archived_count FROM mobility.ratings_usage_id_archive;
    ASSERT v_archived_count = 4, 'TEST 2 FAILED: expected 4 archived records, got ' || v_archived_count;

    -- Check specific archived values and null flags
    ASSERT (SELECT was_null FROM mobility.ratings_usage_id_archive WHERE rating_id = '11111111-1111-1111-1111-111111111111') = TRUE, 'TEST 2 FAILED: row 1 was_null != TRUE';
    ASSERT (SELECT original_usage_id FROM mobility.ratings_usage_id_archive WHERE rating_id = '22222222-2222-2222-2222-222222222222') = 1, 'TEST 2 FAILED: row 2 original_usage_id != 1';
    ASSERT (SELECT original_usage_id FROM mobility.ratings_usage_id_archive WHERE rating_id = '33333333-3333-3333-3333-333333333333') = 123456789012345, 'TEST 2 FAILED: row 3 original_usage_id != 123456789012345';
    ASSERT (SELECT original_usage_id FROM mobility.ratings_usage_id_archive WHERE rating_id = '44444444-4444-4444-4444-444444444444') = 9223372036854775807, 'TEST 2 FAILED: row 4 original_usage_id != MAX BIGINT';

    RAISE NOTICE 'TEST 2 (Migration with NULL, 1, 123456789012345, MAX BIGINT): PASSED';
END $$;

-- Test Rollback on Test 2 Data using real rollback script
\i ../../05_rollbacks/01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.rollback.sql

DO $$
BEGIN
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'bigint', 'TEST 2 ROLLBACK FAILED: usage_id is not BIGINT';

    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '11111111-1111-1111-1111-111111111111') IS NULL, 'TEST 2 ROLLBACK FAILED: row 1 usage_id != NULL';
    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '22222222-2222-2222-2222-222222222222') = 1, 'TEST 2 ROLLBACK FAILED: row 2 usage_id != 1';
    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '33333333-3333-3333-3333-333333333333') = 123456789012345, 'TEST 2 ROLLBACK FAILED: row 3 usage_id != 123456789012345';
    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '44444444-4444-4444-4444-444444444444') = 9223372036854775807, 'TEST 2 ROLLBACK FAILED: row 4 usage_id != MAX BIGINT';

    -- Verify archive is preserved
    ASSERT EXISTS (
        SELECT 1 FROM information_schema.tables WHERE table_schema = 'mobility' AND table_name = 'ratings_usage_id_archive'
    ), 'TEST 2 ROLLBACK FAILED: archive table was dropped, but must be preserved';

    RAISE NOTICE 'TEST 2 (Rollback exact restoration): PASSED';
END $$;

-- ----------------------------------------------------------------------------
-- TEST 3: Archive Conflict Detection (Aborts safely on discrepancy via real migration script)
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('55555555-5555-5555-5555-555555555555', uuid_generate_v4(), uuid_generate_v4(), 100, 5);

-- Manually insert contradictory archive entry (usage_id 999 != 100)
CREATE TABLE IF NOT EXISTS mobility.ratings_usage_id_archive (
    rating_id UUID NOT NULL PRIMARY KEY,
    original_usage_id BIGINT,
    was_null BOOLEAN NOT NULL DEFAULT FALSE,
    archived_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
INSERT INTO mobility.ratings_usage_id_archive (rating_id, original_usage_id, was_null)
VALUES ('55555555-5555-5555-5555-555555555555', 999, FALSE);

-- Run actual migration: must fail with conflict exception
SAVEPOINT sp_test3;
\set ON_ERROR_STOP 0
\set ERROR false
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql
\set ON_ERROR_STOP 1

\if :ERROR
    -- Expected error occurred, roll back to savepoint to recover transaction
    ROLLBACK TO SAVEPOINT sp_test3;
\else
    -- If no error occurred, fail immediately!
    SELECT 'TEST 3 FAILED: Migration did not reject contradictory archive entry (no error raised)'::integer;
\endif

DO $$
BEGIN
    -- Verify that migration aborted and usage_id is STILL bigint (unmodified)
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'bigint', 'TEST 3 FAILED: column type changed despite conflict error';

    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '55555555-5555-5555-5555-555555555555') = 100, 'TEST 3 FAILED: usage_id was altered despite conflict';
    RAISE NOTICE 'TEST 3 (Archive Conflict Detection via actual migration): PASSED';
END $$;

-- ----------------------------------------------------------------------------
-- TEST 4: Rollback Rejection on New Row with UUID via actual rollback script
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

-- Migrate
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql

-- Insert a brand new rating post-migration with a genuine UUID usage_id
INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('66666666-6666-6666-6666-666666666666', uuid_generate_v4(), uuid_generate_v4(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 5);

SAVEPOINT sp_test4;
\set ON_ERROR_STOP 0
\set ERROR false
\i ../../05_rollbacks/01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.rollback.sql
\set ON_ERROR_STOP 1

\if :ERROR
    ROLLBACK TO SAVEPOINT sp_test4;
\else
    SELECT 'TEST 4 FAILED: Rollback did not reject new row with UUID (no error raised)'::integer;
\endif

DO $$
BEGIN
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'uuid', 'TEST 4 FAILED: column was converted to bigint despite new UUID row';

    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '66666666-6666-6666-6666-666666666666') = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'TEST 4 FAILED: new UUID was lost or overwritten';
    RAISE NOTICE 'TEST 4 (Rollback Rejection on New Row with UUID via actual rollback): PASSED';
END $$;

-- ----------------------------------------------------------------------------
-- TEST 5: Rollback Rejection on Modified Row with UUID via actual rollback script
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('77777777-7777-7777-7777-777777777777', uuid_generate_v4(), uuid_generate_v4(), 50, 4);

-- Migrate
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql

-- Modify existing rating with a new UUID post-migration
UPDATE mobility.ratings
SET usage_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
WHERE id = '77777777-7777-7777-7777-777777777777';

SAVEPOINT sp_test5;
\set ON_ERROR_STOP 0
\set ERROR false
\i ../../05_rollbacks/01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.rollback.sql
\set ON_ERROR_STOP 1

\if :ERROR
    ROLLBACK TO SAVEPOINT sp_test5;
\else
    SELECT 'TEST 5 FAILED: Rollback did not reject modified row with UUID (no error raised)'::integer;
\endif

DO $$
BEGIN
    ASSERT (
        SELECT data_type FROM information_schema.columns 
        WHERE table_schema = 'mobility' AND table_name = 'ratings' AND column_name = 'usage_id'
    ) = 'uuid', 'TEST 5 FAILED: column was converted to bigint despite modified UUID row';

    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '77777777-7777-7777-7777-777777777777') = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'TEST 5 FAILED: modified UUID was lost or overwritten';
    RAISE NOTICE 'TEST 5 (Rollback Rejection on Modified Row with UUID via actual rollback): PASSED';
END $$;

-- ----------------------------------------------------------------------------
-- TEST 6: Rollback with Post-Migration Rows having NULL usage_id
-- ----------------------------------------------------------------------------
CALL mobility.test_setup_clean_ratings();

INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('88888888-8888-8888-8888-888888888888', uuid_generate_v4(), uuid_generate_v4(), 75, 4);

-- Migrate
\i ../../01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.sql

-- Insert a new rating post-migration with NULL usage_id (allowed and supported)
INSERT INTO mobility.ratings (id, user_id, route_id, usage_id, rating) VALUES
    ('99999999-9999-9999-9999-999999999999', uuid_generate_v4(), uuid_generate_v4(), NULL, 5);

-- Rollback
\i ../../05_rollbacks/01_ddl/03_tables/004_mobility__module/012_alter_ratings_usage_id_type.rollback.sql

DO $$
BEGIN
    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '88888888-8888-8888-8888-888888888888') = 75, 'TEST 6 FAILED: row 8888... usage_id != 75';
    ASSERT (SELECT usage_id FROM mobility.ratings WHERE id = '99999999-9999-9999-9999-999999999999') IS NULL, 'TEST 6 FAILED: new row 9999... usage_id != NULL';
    RAISE NOTICE 'TEST 6 (Preserve new NULL rows on Rollback): PASSED';
END $$;

-- Clean up test procedures and tables
DROP PROCEDURE IF EXISTS mobility.test_setup_clean_ratings();
DROP TABLE IF EXISTS mobility.ratings_usage_id_archive CASCADE;
DROP TABLE IF EXISTS mobility.ratings CASCADE;

ROLLBACK; -- Always roll back transaction so no persistent changes remain
