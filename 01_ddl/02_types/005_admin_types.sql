CREATE TYPE admin.export_format AS ENUM ('PDF','XLSX','CSV','JSON');
CREATE TYPE admin.export_status  AS ENUM ('generating','ready','error');
CREATE TYPE admin.support_status AS ENUM ('pending','in_progress','resolved','closed');
 