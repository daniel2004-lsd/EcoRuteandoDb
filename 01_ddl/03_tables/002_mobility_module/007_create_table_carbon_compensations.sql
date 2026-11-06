CREATE TABLE mobility.carbon_compensations (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id            UUID REFERENCES admin.companies(id) ON DELETE SET NULL,
    user_id               UUID REFERENCES security.users(id) ON DELETE SET NULL,
    co2_compensated_kg    NUMERIC(12,4) NOT NULL,
    trees_equivalent      INT NOT NULL,
    partner_program       VARCHAR(150) NOT NULL DEFAULT 'Reforestación Cuenca Río Las Ceibas (CAM Huila)',
    certificate_code      VARCHAR(50) NOT NULL UNIQUE,
    compensation_status   VARCHAR(30) NOT NULL DEFAULT 'certified',
    notes                 TEXT,
    certified_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_compensations_company_id ON mobility.carbon_compensations(company_id);
CREATE INDEX idx_compensations_user_id ON mobility.carbon_compensations(user_id);
