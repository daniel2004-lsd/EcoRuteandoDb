-- ============================================================
-- DATOS DE EJEMPLO - Módulo Mobility (HU: Visualizar Ruta)
-- Rutas y POIs del centro de Bogotá para probar:
--   GET /api/routes
--   GET /api/routes/{id}
--
-- SOLO para desarrollo/pruebas. NO está en el changelog de Liquibase.
-- Ejecutar manualmente, ej.:  psql -d ecoruteando -f seed_mobility_demo.sql
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- Puntos de interés (mobility.points_of_interest)
-- GEOGRAPHY(Point): POINT(longitud latitud)
-- ------------------------------------------------------------
INSERT INTO mobility.points_of_interest
    (id, name, poi_type, description, location, address, icon_url, is_active, source)
VALUES
    ('11111111-1111-4111-8111-111111111111',
     'Mercado de la Perseverancia', 'gastronomia',
     'Mercado tradicional con comida típica colombiana.',
     ST_GeogFromText('SRID=4326;POINT(-74.0700 4.6035)'),
     'Cra. 13 #4-50, La Perseverancia', NULL, TRUE, 'seed_demo'),

    ('22222222-2222-4222-8222-222222222222',
     'Museo del Oro', 'museo',
     'Colección de orfebrería precolombina más grande del mundo.',
     ST_GeogFromText('SRID=4326;POINT(-74.0722 4.6019)'),
     'Cra. 6 #15-88, La Candelaria', NULL, TRUE, 'seed_demo'),

    ('33333333-3333-4333-8333-333333333333',
     'Plaza de Bolívar', 'monumento',
     'Plaza principal de Bogotá, rodeada por la Catedral Primada.',
     ST_GeogFromText('SRID=4326;POINT(-74.0758 4.5981)'),
     'Cl. 10 #5-51, La Candelaria', NULL, TRUE, 'seed_demo'),

    ('44444444-4444-4444-8444-444444444444',
     'Museo Botero', 'museo',
     'Obras de Fernando Botero y artistas como Picasso y Dalí.',
     ST_GeogFromText('SRID=4326;POINT(-74.0746 4.5986)'),
     'Cl. 11 #4-41, La Candelaria', NULL, TRUE, 'seed_demo'),

    ('55555555-5555-4555-8555-555555555555',
     'Chorro de Quevedo', 'historico',
     'Lugar donde se fundó Bogotá según la tradición.',
     ST_GeogFromText('SRID=4326;POINT(-74.0720 4.5972)'),
     'Cl. 12B #2-01, La Candelaria', NULL, TRUE, 'seed_demo');

-- ------------------------------------------------------------
-- Rutas (mobility.routes)
-- ------------------------------------------------------------
INSERT INTO mobility.routes
    (id, name, description, transport_type, status,
     start_name, destination_name, start_location, end_location,
     route_geometry, encoded_polyline,
     distance_km, estimated_time_min, co2_saved_kg, estimated_calories,
     difficulty_level, map_data, photo_url, available_date)
VALUES
    -- Ruta 1: bicicleta
    ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
     'Ruta Cicla Candelaria',
     'Recorrido en bici por el corazón histórico de Bogotá pasando por mercados y museos.',
     'bike', 'active',
     'Mercado de la Perseverancia', 'Chorro de Quevedo',
     ST_GeogFromText('SRID=4326;POINT(-74.0700 4.6035)'),
     ST_GeogFromText('SRID=4326;POINT(-74.0720 4.5972)'),
     ST_GeogFromText('SRID=4326;LINESTRING(-74.0700 4.6035, -74.0712 4.6028, -74.0722 4.6019, -74.0735 4.6002, -74.0740 4.5989, -74.0731 4.5979, -74.0720 4.5972)'),
     '{bb[lxacMjCpFtDdEpIdGbGbBfEsDjC{E',
     3.20, 22, 0.7500, 85.50,
     2,
     '{"center": {"lat": 4.6003, "lng": -74.0720}, "zoom": 15}'::jsonb,
     NULL, CURRENT_DATE),

    -- Ruta 2: caminata
    ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb1',
     'Caminata Histórica Centro',
     'Paseo a pie por la Plaza de Bolívar, el Museo Botero y el Chorro de Quevedo.',
     'walking', 'active',
     'Plaza de Bolívar', 'Chorro de Quevedo',
     ST_GeogFromText('SRID=4326;POINT(-74.0758 4.5981)'),
     ST_GeogFromText('SRID=4326;POINT(-74.0720 4.5972)'),
     ST_GeogFromText('SRID=4326;LINESTRING(-74.0758 4.5981, -74.0746 4.5986, -74.0736 4.5978, -74.0720 4.5972)'),
     'aaa[v|bcMeBoF~CgEvB_I',
     1.10, 18, 0.2600, 70.00,
     1,
     '{"center": {"lat": 4.5978, "lng": -74.0742}, "zoom": 16}'::jsonb,
     NULL, CURRENT_DATE);

-- ------------------------------------------------------------
-- Asociación ruta ↔ POI con orden de visita (mobility.route_poi)
-- ------------------------------------------------------------
INSERT INTO mobility.route_poi (route_id, poi_id, sort_order)
VALUES
    ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', '11111111-1111-4111-8111-111111111111', 1), -- Perseverancia
    ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', '22222222-2222-4222-8222-222222222222', 2), -- Museo del Oro
    ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1', '55555555-5555-4555-8555-555555555555', 3), -- Chorro de Quevedo

    ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb1', '33333333-3333-4333-8333-333333333333', 1), -- Plaza de Bolívar
    ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb1', '44444444-4444-4444-8444-444444444444', 2), -- Museo Botero
    ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb1', '55555555-5555-4555-8555-555555555555', 3); -- Chorro de Quevedo

COMMIT;

-- Verificación rápida
SELECT r.name AS ruta, count(rp.poi_id) AS pois
FROM mobility.routes r
LEFT JOIN mobility.route_poi rp ON rp.route_id = r.id
GROUP BY r.name;
