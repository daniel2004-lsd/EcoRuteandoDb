# ADR-003

## Título

Reemplazar tipos ENUM de PostgreSQL por columnas VARCHAR para atributos de usuario.

---

## Estado

Accepted

---

## Contexto

El módulo **Security** utilizaba tipos ENUM nativos de PostgreSQL para representar los atributos:

- user_status
- preferred_language
- ui_theme

Durante la evolución del sistema se identificó que el uso de ENUM nativos incrementaba el acoplamiento entre la capa de persistencia y el motor de base de datos, dificultando la evolución del esquema y la interoperabilidad con herramientas ORM.

Además, cualquier modificación sobre los valores permitidos implicaba cambios estructurales sobre los tipos definidos en PostgreSQL.

El proyecto requiere mantener una estrategia de versionamiento mediante Liquibase, favorecer la mantenibilidad del esquema y reducir el impacto de futuras modificaciones.

---

## Decisión

Se reemplazan las columnas basadas en tipos ENUM de PostgreSQL por columnas de tipo VARCHAR.

La integridad de los datos será preservada mediante restricciones CHECK en la base de datos, definiendo explícitamente los valores permitidos para cada atributo.

Las validaciones de negocio continuarán siendo responsabilidad de la capa de dominio de la aplicación.

---

## Consecuencias

### Positivas

- Reduce el acoplamiento con características específicas de PostgreSQL.
- Simplifica la evolución del esquema de base de datos.
- Facilita la integración con herramientas ORM.
- Los valores permitidos continúan siendo validados por la base de datos mediante CHECK CONSTRAINT.
- Disminuye el costo de mantenimiento de los tipos personalizados.

### Negativas

- Los tipos ENUM dejan de utilizarse como mecanismo de restricción nativo.
- La administración de los valores permitidos pasa a depender de las restricciones CHECK y de las reglas del dominio.

---

## Alternativas consideradas

### Mantener ENUM nativos de PostgreSQL

**Descartada.**

Aunque proporciona mayor tipado en la base de datos, incrementa el acoplamiento con PostgreSQL y dificulta la evolución del modelo de datos.

### Almacenar valores enteros

**Descartada.**

Reduce la legibilidad de los datos almacenados y obliga a mantener correspondencias entre valores numéricos y su significado.

---

## Impacto

Esta decisión afecta únicamente al esquema de persistencia del módulo **Security**, específicamente a la tabla:

- security.users

No modifica el comportamiento funcional del sistema.

---

## Fecha

2026-07-15

---

## Autor

Daniel Salazar Vargas