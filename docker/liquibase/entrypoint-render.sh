#!/bin/sh
# Entrypoint para Render: traduce DATABASE_URL (formato Render/Postgres) a JDBC
# y ejecuta `liquibase update`. Idempotente gracias a DATABASECHANGELOG.
set -e

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL no está definida." >&2
  exit 1
fi

echo "==> Inicializando base de datos con Liquibase..."

# Render entrega: postgres://user:pass@host:port/dbname
# JDBC necesita SIN credenciales en la URL: jdbc:postgresql://host:port/dbname
# (Las credenciales se pasan aparte con --username / --password.)
DB_USER=$(echo "$DATABASE_URL" | sed -E 's|^[a-z]+://([^:/]+).*|\1|')
DB_PASS=$(echo "$DATABASE_URL" | sed -E 's|^[a-z]+://[^:]+:([^@]+)@.*|\1|')
JDBC_URL=$(echo "$DATABASE_URL" | sed -E \
  -e 's|^[a-z]+://[^@]+@|jdbc:postgresql://|' \
  -e 's|^postgres://|jdbc:postgresql://|')

echo "==> Target: $JDBC_URL (user=$DB_USER)"

exec liquibase \
  --changeLogFile=changelog/db.changelog-master.yaml \
  --url="$JDBC_URL" \
  --username="$DB_USER" \
  --password="$DB_PASS" \
  update
