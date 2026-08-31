CREATE TABLE community.alerts (
    id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type            community.alert_type NOT NULL,
    title           VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    impact_area     GEOGRAPHY(POLYGON, 4326),
    impact_radius_m INT CHECK (impact_radius_m IS NULL OR impact_radius_m >= 0),
    valid_from      TIMESTAMPTZ NOT NULL,
    valid_until     TIMESTAMPTZ,
    created_by      UUID,
    report_id       UUID,
    weather_data_id  UUID,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (valid_until IS NULL OR valid_until > valid_from)
);