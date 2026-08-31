CREATE TABLE mobility.routes (
    id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name                 VARCHAR(150) NOT NULL,
    description          TEXT,
    transport_type       mobility.transport_type NOT NULL,
    status               mobility.route_status NOT NULL DEFAULT 'active',
    start_name           VARCHAR(200) NOT NULL,
    destination_name     VARCHAR(200) NOT NULL,
    start_location       GEOGRAPHY(POINT, 4326),
    end_location         GEOGRAPHY(POINT, 4326),
    route_geometry       GEOGRAPHY(LINESTRING, 4326),
    encoded_polyline     TEXT,
    distance_km          NUMERIC(10,2)
                           CHECK (distance_km IS NULL OR distance_km >= 0),
    estimated_time_min   INT
                           CHECK (estimated_time_min IS NULL OR estimated_time_min >= 0),
    co2_saved_kg         NUMERIC(10,4),
    estimated_calories   NUMERIC(8,2),
    difficulty_level     SMALLINT
                           CHECK (difficulty_level BETWEEN 1 AND 5),
    map_data             JSONB,
    photo_url            VARCHAR(500),
    available_date       DATE,
    created_by           UUID,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (map_data IS NULL OR jsonb_typeof(map_data) = 'object')
);
