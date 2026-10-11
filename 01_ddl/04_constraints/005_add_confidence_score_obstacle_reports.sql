-- HU-22 / CU22: sistema de confianza para reportes ciudadanos (tipo Google Maps).
-- confidence_score: puntaje 0-100 calculado por la API (base al crear,
-- confirmaciones de usuarios independientes, rechazos). El mapa solo muestra
-- reportes con score >= 40. El decay por antigüedad se aplica en tiempo de
-- lectura, por lo que no se persiste aquí. DEFAULT 40 (= score base) deja
-- visibles los reportes creadados antes de la HU-22.
ALTER TABLE community.obstacle_reports
    ADD COLUMN IF NOT EXISTS confidence_score SMALLINT NOT NULL DEFAULT 40;

COMMENT ON COLUMN community.obstacle_reports.confidence_score IS
    'Puntaje de confianza 0-100 (HU-22 CU22). El reporte es visible en el mapa si el score efectivo >= 40.';
