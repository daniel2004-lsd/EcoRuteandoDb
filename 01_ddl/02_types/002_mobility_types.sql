CREATE TYPE mobility.transport_type AS ENUM ('bike','public_transport','mixed','walking','car');
CREATE TYPE mobility.route_status   AS ENUM ('active','inactive','under_review','archived');
CREATE TYPE mobility.usage_source   AS ENUM ('web','mobile','pwa');
CREATE TYPE mobility.search_type    AS ENUM ('search','origin','destination');
 