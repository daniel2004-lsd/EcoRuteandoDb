CREATE TABLE admin.companies (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nit                   VARCHAR(20) NOT NULL UNIQUE,
    business_name         VARCHAR(150) NOT NULL,
    sector                VARCHAR(50) NOT NULL DEFAULT 'passenger_transport',
    monthly_co2_budget_kg NUMERIC(12,2) NOT NULL DEFAULT 50000.00,
    contact_email         VARCHAR(120),
    is_active             BOOLEAN NOT NULL DEFAULT true,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);
