# Portal de incorporación de HC Promedical

Este archivo se carga solo al abrir el proyecto. Es la fuente de verdad de cómo se trabaja aquí.

## Qué se construye

Un portal web en español (México) donde cualquier persona que entra a HC Promedical entiende dónde está, qué sigue y cómo avanzar, y al terminar el programa puede trabajar al nivel que exige la empresa. El índice de 10 bloques y 3 niveles (`docs/01-indice.md`) es la columna vertebral: cada punto es un hipervínculo a su sección.

HC Promedical es una empresa mexicana de equipo médico, generación de oxígeno y servicios generales hospitalarios. Sus usuarios son ingenieros biomédicos, técnicos de servicios generales y PSA, personal de ventas y administración, y líderes de póliza. Lo usan en celular, dentro de hospitales, con prisa y a veces con mala señal.

## Lee esto antes de escribir código

| Documento | Para qué |
| --- | --- |
| `docs/00-brief.md` | Objetivo, usuarios, páginas y criterios de aceptación |
| `docs/01-indice.md` y `data/indice.json` | Estructura y numeración del contenido |
| `docs/02-modulos-y-niveles.md` | Módulos, horas, niveles de permiso y reglas de evaluación |
| `docs/03-experiencia-y-diseno.md` y `design/` | Principios de UX, pantallas, microcopy y tokens |
| `docs/04-arquitectura.md` | Stack, carpetas, seguridad y rendimiento |
| `docs/05-fases.md` | Plan de entrega con listas de verificación |
| `docs/06-contenido-pendiente.md` | Lo que no está validado y no se debe inventar |
| `docs/07-decisiones.md` | Decisiones tomadas y por qué |

## Stack

Next.js (App Router) con TypeScript estricto, Tailwind CSS, shadcn/ui, Supabase (Auth, Postgres con RLS), Zod, Vitest y Playwright con axe. Gestor de paquetes: pnpm. Usa las versiones estables vigentes al crear el proyecto y fíjalas en el lockfile.

Comandos que deben existir al cerrar la Fase 0 (créalos si faltan):

- `pnpm dev`: servidor local.
- `pnpm check`: lint + typecheck + pruebas unitarias + `validate:content`. Debe pasar antes de cada commit.
- `pnpm test:e2e`: Playwright, incluye auditoría de accesibilidad con axe.
- `pnpm validate:content`: ejecuta `node scripts/validar-contenido.mjs`.
- `pnpm seed:content`: sincroniza `content/` y `data/` con Supabase.

## Reglas de producto (no negociables)

1. Siempre se sabe dónde se está y qué sigue. Hay un botón principal "Continuar" que lleva a la siguiente sección pendiente (algoritmo en `docs/03-experiencia-y-diseno.md`).
2. Cualquier contenido está a tres clics o menos.
3. Una pregunta y una acción principal por pantalla.
4. Lenguaje llano, frases cortas, sin jerga de sistemas. Las mismas palabras para las mismas acciones en todo el portal.
5. Nada de relleno ni texto de ejemplo en pantalla. Los estados vacíos explican qué hacer.
6. Funciona bien en 360 px de ancho, con teclado y con lector de pantalla.

## Reglas de contenido

- El contenido vive en `content/` como Markdown con frontmatter y es la fuente de verdad. Se revisa en git como cualquier código.
- Estados: `pendiente` (sin texto validado), `borrador` (texto con fuente, falta validar) y `validado`. Solo una persona responsable de HC puede pasar una sección a `validado`; tú no.
- No inventes contenido técnico, normas, cifras, nombres de personas, equipos ni procedimientos. Si falta un dato, deja la sección en `pendiente` y visible como "Pendiente de validar" en el portal.
- Las normas y estándares citados (IEC, NFPA, NOM-SSA, NOM-STPS) son referencias de partida. Ninguna se publica como contenido de examen hasta que calidad confirme su vigencia.
- Las cifras y los nombres de responsables pueden estar desactualizados: cada sección guarda `revisado` y `responsable` para saberlo.
- Cada sede (por ejemplo CMJ Querétaro y CEM La Paz) tiene sus registros separados. Nunca mezcles datos entre sedes.

## Reglas de código

- TypeScript estricto, sin `any` salvo justificación en comentario.
- Valida con Zod toda entrada externa (formularios, params, respuestas de la base).
- Componentes pequeños, con una sola responsabilidad. Los componentes de UI siguen `design/tokens.css`: ningún color, radio o espaciado escrito a mano fuera de los tokens.
- Los textos de interfaz van en un solo diccionario (`src/lib/textos.ts`) para mantener el microcopy consistente.
- Accesibilidad primero: HTML semántico, foco visible, áreas táctiles de 44 px, contraste AA. Nada que dependa solo del color.
- Pruebas: cada regla de negocio (calificación, intentos, niveles, "Continuar") tiene prueba unitaria. Cada flujo principal tiene una prueba e2e.
- Commits pequeños y en español, en imperativo: "Agrega barra de índice con anclas".

## Seguridad y datos

- El portal no guarda datos de pacientes ni información clínica. Si una pantalla pudiera recibirlos, se rediseña.
- Cuenta personal obligatoria. Nada de cuentas compartidas. Alta solo por invitación del administrador.
- Toda tabla con datos de personas tiene RLS. Las respuestas correctas de los exámenes nunca viajan al navegador antes de calificar (ver `supabase/migrations/0001_esquema.sql`).
- Secretos solo en variables de entorno. `.env.example` lista las necesarias; `.env.local` nunca se sube.
- Antes de cualquier migración destructiva, pregunta.

## Marca y limpieza

- Sin marcas de agua, insignias ni créditos de herramientas de generación de código en la interfaz, el código o los metadatos.
- Sin comentarios en el código que mencionen inteligencia artificial. Los comentarios explican el porqué, no el qué.
- El logotipo de HC Promedical va en `assets/`. Si no está, usa un marcador neutro y avísalo.

## Cómo trabajar

1. Entra en modo plan. Presenta estructura de carpetas, decisiones de arquitectura que cambiarías y el plan detallado de la fase, y espera aprobación.
2. Trabaja una fase a la vez (`docs/05-fases.md`). Al cerrar cada una: `pnpm check`, `pnpm test:e2e`, resumen de lo hecho y lo pendiente, y espera revisión.
3. Si una decisión de diseño o de datos queda ambigua, pregunta antes de asumir.
4. Comandos útiles ya definidos en `.claude/commands/`: `/fase`, `/revisar` y `/contenido`. El agente `revisor-ux` audita pantallas contra los criterios de aceptación.

## Definición de terminado (para cualquier tarea)

- Cumple los criterios de aceptación de su fase.
- `pnpm check` y `pnpm test:e2e` pasan.
- Se probó a 360 px y solo con teclado.
- No hay textos de relleno, colores fuera de tokens ni marcas de herramientas.
- La documentación afectada (`docs/`) quedó actualizada.
