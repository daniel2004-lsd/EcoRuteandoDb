CREATE TABLE mobility.route_usage (

    usage_id UUID DEFAULT uuid_generate_v4(),

    user_id UUID NOT NULL,

    route_id UUID NOT NULL,

    transport_mode mobility.transport_type,

    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    ended_at TIMESTAMPTZ,

    completed BOOLEAN NOT NULL DEFAULT FALSE,

    actual_distance_km NUMERIC(10,2)
        CHECK (actual_distance_km IS NULL OR actual_distance_km >= 0),

    actual_duration_min INT
        CHECK (actual_duration_min IS NULL OR actual_duration_min >= 0),

    actual_co2_kg NUMERIC(10,4),

    actual_route GEOGRAPHY(LINESTRING,4326),

    gps_data JSONB,

    source mobility.usage_source NOT NULL DEFAULT 'web',

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (usage_id, created_at),

    CHECK (gps_data IS NULL OR jsonb_typeof(gps_data)='array'),

    CHECK (ended_at IS NULL OR ended_at >= started_at)

) PARTITION BY RANGE (created_at);