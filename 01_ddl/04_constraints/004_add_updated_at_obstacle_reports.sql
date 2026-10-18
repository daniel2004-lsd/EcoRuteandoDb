-- HU-16 / CU07: la tabla community.obstacle_reports fue creada en un changeset
-- anterior sin la columna updated_at. Se agrega de forma idempotente para
-- alinear el esquema con el mapeo de EF (Entity<TId>.UpdatedAt).
ALTER TABLE community.obstacle_reports
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();