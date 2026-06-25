CREATE TABLE admin.transport_factors (
    factor_id          SERIAL PRIMARY KEY,
    transport_type     mobility.transport_type NOT NULL,
    co2_factor_kg_km   NUMERIC(8,6) NOT NULL,
    calorie_factor_km  NUMERIC(6,2),
    valid_from         TIMESTAMPTZ NOT NULL DEFAULT now(),
    valid_until        TIMESTAMPTZ,
    source             VARCHAR(200),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (valid_until IS NULL OR valid_until > valid_from)
);