-- Portal HC Promedical · esquema inicial
-- Ejecutar con: supabase db push
-- Principio: las reglas viven en la base de datos. El cliente nunca recibe las respuestas correctas ni califica.

create extension if not exists pgcrypto;

-- ---------- Tipos ----------
create type rol_app as enum ('colaborador', 'tutor', 'lider', 'admin');
create type resultado_cert as enum ('vigente', 'por_vencer', 'vencida', 'revocada');

-- ---------- Tablas ----------
create table sedes (
  id uuid primary key default gen_random_uuid(),
  codigo text not null unique,           -- ej. 'CMJ-QRO'
  nombre text not null,
  creada_en timestamptz not null default now()
);

create table perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text not null,
  rol rol_app not null default 'colaborador',
  sede_id uuid references sedes(id),
  ruta text,                             -- ej. 'B' (biomédica), 'S', 'V', 'L'
  nivel smallint not null default 0 check (nivel between 0 and 4),
  tutor_id uuid references perfiles(id),
  fecha_ingreso date,
  creado_en timestamptz not null default now()
);

create table modulos (
  codigo text primary key,               -- 'N1', 'B3', ...
  nombre text not null,
  grupo text not null,                   -- nucleo | biomedica | servicios | ventas | liderazgo | avanzado
  horas numeric(4,1) not null default 0,
  evidencia text,
  orden int not null
);

create table secciones (
  codigo text primary key,               -- '1.2.4'
  titulo text not null,
  nivel smallint not null,
  padre_codigo text references secciones(codigo),
  modulo_codigo text references modulos(codigo),
  orden int not null,
  hoja boolean not null default false,
  estado text not null default 'pendiente' check (estado in ('pendiente','borrador','validado')),
  version text,
  revisado date
);

create table progreso (
  perfil_id uuid not null references perfiles(id) on delete cascade,
  seccion_codigo text not null references secciones(codigo) on delete cascade,
  completada_en timestamptz not null default now(),
  primary key (perfil_id, seccion_codigo)
);

create table preguntas (
  id uuid primary key default gen_random_uuid(),
  modulo_codigo text not null references modulos(codigo),
  enunciado text not null,
  opciones jsonb not null,               -- [{"id":"a","texto":"..."}, ...]
  correctas text[] not null,             -- ids correctos; NUNCA se expone al cliente
  explicacion text,
  seccion_repaso text references secciones(codigo),
  activa boolean not null default true,
  check (jsonb_typeof(opciones) = 'array' and cardinality(correctas) >= 1)
);

create table intentos (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles(id) on delete cascade,
  modulo_codigo text not null references modulos(codigo),
  numero smallint not null,
  calificacion numeric(5,2) not null,
  aprobado boolean not null,
  detalle jsonb not null,
  creado_en timestamptz not null default now(),
  unique (perfil_id, modulo_codigo, numero)
);

create table refuerzos (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles(id) on delete cascade,
  modulo_codigo text not null references modulos(codigo),
  registrado_por uuid not null references perfiles(id),
  nota text,
  creado_en timestamptz not null default now()
);

create table certificaciones (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles(id) on delete cascade,
  modulo_codigo text not null references modulos(codigo),
  estado resultado_cert not null default 'vigente',
  otorgada_en date not null default current_date,
  vence_en date,
  otorgada_por uuid references perfiles(id),
  unique (perfil_id, modulo_codigo)
);

create index on progreso (perfil_id);
create index on intentos (perfil_id, modulo_codigo);
create index on certificaciones (perfil_id);
create index on perfiles (sede_id);
create index on perfiles (tutor_id);

-- ---------- Funciones auxiliares ----------
create or replace function app_rol() returns rol_app
language sql stable security definer set search_path = public as
$$ select rol from perfiles where id = auth.uid() $$;

create or replace function app_sede() returns uuid
language sql stable security definer set search_path = public as
$$ select sede_id from perfiles where id = auth.uid() $$;

-- Quién puede ver el perfil de otra persona:
-- ella misma; su tutor; líder de la misma sede; admin.
create or replace function puede_ver_perfil(p_id uuid) returns boolean
language sql stable security definer set search_path = public as
$$
  select
    p_id = auth.uid()
    or exists (select 1 from perfiles x where x.id = p_id and x.tutor_id = auth.uid())
    or (app_rol() = 'lider' and exists (select 1 from perfiles x where x.id = p_id and x.sede_id = app_sede()))
    or app_rol() = 'admin'
$$;

-- ---------- Calificación en servidor ----------
-- Recibe {"<id_pregunta>": ["a","c"], ...}. Devuelve calificación, aprobado y detalle.
-- Reglas: mínimo 80 %; 2 intentos; el tercero exige un refuerzo posterior al segundo.
create or replace function calificar_intento(p_modulo text, p_respuestas jsonb)
returns jsonb
language plpgsql security definer set search_path = public as
$$
declare
  v_uid uuid := auth.uid();
  v_prev int;
  v_ultimo_intento timestamptz;
  v_total int := 0;
  v_ok int := 0;
  v_detalle jsonb := '[]'::jsonb;
  v_cal numeric(5,2);
  v_aprobado boolean;
  r record;
  v_resp text[];
begin
  if v_uid is null then
    raise exception 'No autenticado';
  end if;

  select count(*), max(creado_en) into v_prev, v_ultimo_intento
  from intentos where perfil_id = v_uid and modulo_codigo = p_modulo;

  if v_prev >= 2 and not exists (
    select 1 from refuerzos
    where perfil_id = v_uid and modulo_codigo = p_modulo and creado_en > v_ultimo_intento
  ) then
    raise exception 'Intentos agotados: se requiere refuerzo con tu tutor antes de volver a intentar';
  end if;

  for r in
    select id, correctas, explicacion, seccion_repaso
    from preguntas where modulo_codigo = p_modulo and activa
  loop
    v_total := v_total + 1;
    select coalesce(array_agg(x order by x), '{}') into v_resp
    from jsonb_array_elements_text(coalesce(p_respuestas -> r.id::text, '[]'::jsonb)) as t(x);

    if v_resp = (select array_agg(c order by c) from unnest(r.correctas) c) then
      v_ok := v_ok + 1;
      v_detalle := v_detalle || jsonb_build_object('pregunta', r.id, 'correcta', true);
    else
      v_detalle := v_detalle || jsonb_build_object(
        'pregunta', r.id, 'correcta', false,
        'explicacion', r.explicacion, 'repasar', r.seccion_repaso);
    end if;
  end loop;

  if v_total = 0 then
    raise exception 'El módulo % no tiene preguntas activas', p_modulo;
  end if;

  v_cal := round(100.0 * v_ok / v_total, 2);
  v_aprobado := v_cal >= 80;

  insert into intentos (perfil_id, modulo_codigo, numero, calificacion, aprobado, detalle)
  values (v_uid, p_modulo, v_prev + 1, v_cal, v_aprobado, v_detalle);

  return jsonb_build_object(
    'calificacion', v_cal,
    'aprobado', v_aprobado,
    'intento', v_prev + 1,
    'detalle', v_detalle);
end;
$$;

-- ---------- Vistas ----------
-- Preguntas sin respuestas correctas, para el cliente
create view preguntas_publicas with (security_invoker = false) as
  select id, modulo_codigo, enunciado, opciones,
         (cardinality(correctas) > 1) as multiple
  from preguntas where activa;

-- Matriz de competencias (respeta RLS de quien consulta)
create view matriz_competencias with (security_invoker = true) as
  select p.id as perfil_id, p.nombre, p.sede_id, c.modulo_codigo, c.estado, c.vence_en
  from perfiles p
  left join certificaciones c on c.perfil_id = p.id;

-- ---------- RLS ----------
alter table sedes enable row level security;
alter table perfiles enable row level security;
alter table modulos enable row level security;
alter table secciones enable row level security;
alter table progreso enable row level security;
alter table preguntas enable row level security;
alter table intentos enable row level security;
alter table refuerzos enable row level security;
alter table certificaciones enable row level security;

-- Catálogos: lectura para cualquier usuario autenticado
create policy sedes_leer on sedes for select to authenticated using (true);
create policy modulos_leer on modulos for select to authenticated using (true);
create policy secciones_leer on secciones for select to authenticated using (true);

-- Preguntas: nadie las lee directo (solo vía vista y función). Sin política = sin acceso.

-- Perfiles
create policy perfiles_leer on perfiles for select to authenticated using (puede_ver_perfil(id));
-- Se limita a cambiar el nombre propio; rol, nivel y sede los cambia solo un admin.
create policy perfiles_editar_propio on perfiles for update to authenticated
  using (id = auth.uid())
  with check (
    id = auth.uid()
    and rol = (select rol from perfiles where id = auth.uid())
    and nivel = (select nivel from perfiles where id = auth.uid())
    and sede_id is not distinct from (select sede_id from perfiles where id = auth.uid())
  );
create policy perfiles_admin on perfiles for all to authenticated
  using (app_rol() = 'admin') with check (app_rol() = 'admin');

-- Progreso: cada quien marca el suyo; lo ven quienes pueden ver el perfil
create policy progreso_leer on progreso for select to authenticated using (puede_ver_perfil(perfil_id));
create policy progreso_insertar on progreso for insert to authenticated with check (perfil_id = auth.uid());
create policy progreso_borrar on progreso for delete to authenticated using (perfil_id = auth.uid());

-- Intentos: solo lectura; se escriben únicamente con calificar_intento()
create policy intentos_leer on intentos for select to authenticated using (puede_ver_perfil(perfil_id));

-- Refuerzos: los registra el tutor de la persona o un admin
create policy refuerzos_leer on refuerzos for select to authenticated using (puede_ver_perfil(perfil_id));
create policy refuerzos_insertar on refuerzos for insert to authenticated
  with check (
    registrado_por = auth.uid()
    and (
      app_rol() = 'admin'
      or exists (select 1 from perfiles x where x.id = perfil_id and x.tutor_id = auth.uid())
    )
  );

-- Certificaciones: las ven quienes pueden ver el perfil; las otorga tutor/líder de la sede o admin
create policy cert_leer on certificaciones for select to authenticated using (puede_ver_perfil(perfil_id));
create policy cert_escribir on certificaciones for all to authenticated
  using (
    app_rol() = 'admin'
    or exists (select 1 from perfiles x where x.id = perfil_id and (x.tutor_id = auth.uid()
         or (app_rol() = 'lider' and x.sede_id = app_sede())))
  )
  with check (
    app_rol() = 'admin'
    or exists (select 1 from perfiles x where x.id = perfil_id and (x.tutor_id = auth.uid()
         or (app_rol() = 'lider' and x.sede_id = app_sede())))
  );

-- Permisos de ejecución
revoke all on function calificar_intento(text, jsonb) from public;
grant execute on function calificar_intento(text, jsonb) to authenticated;
grant select on preguntas_publicas to authenticated;
