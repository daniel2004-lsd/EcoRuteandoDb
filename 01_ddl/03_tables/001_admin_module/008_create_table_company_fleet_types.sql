CREATE TABLE admin.company_fleet_types (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id            UUID NOT NULL REFERENCES admin.companies(id) ON DELETE CASCADE,
    vehicle_type          VARCHAR(60) NOT NULL,
    fuel_type             VARCHAR(30) NOT NULL,
    emission_factor_kg_km NUMERIC(8,6) NOT NULL,
    source_reference      VARCHAR(150) NOT NULL DEFAULT 'UPME / MinAmbiente Colombia',
    is_active             BOOLEAN NOT NULL DEFAULT true,
    valid_from            TIMESTAMPTZ NOT NULL DEFAULT now(),
    valid_until           TIMESTAMPTZ,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_company_fleet_company_id ON admin.company_fleet_types(company_id);
