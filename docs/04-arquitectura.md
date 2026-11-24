# Arquitectura

Las decisiones y su motivo están en `docs/07-decisiones.md`. Si ves una mejor, propónla en el plan antes de implementarla.

## Stack

| Capa | Elección |
| --- | --- |
| Aplicación | Next.js (App Router), React, TypeScript estricto |
| Estilos | Tailwind CSS con los tokens de `design/tokens.css`; componentes con shadcn/ui |
| Datos y autenticación | Supabase: Postgres con RLS, Auth por correo, funciones SQL |
| Validación | Zod en todo límite (formularios, parámetros, respuestas) |
| Búsqueda | Índice generado en el build y consultado en el cliente (MiniSearch o Fuse.js) |
| Sin conexión | Service worker (Serwist) con caché de contenido ya visitado y del índice de búsqueda |
| Pruebas | Vitest (unidad), Playwright con axe (e2e y accesibilidad), Lighthouse CI |
| Calidad | ESLint, Prettier, `tsc --noEmit`, `scripts/validar-contenido.mjs` |
| Despliegue | Vercel u hosting equivalente con Node; variables de entorno por ambiente |

Usa las versiones estables vigentes al crear el proyecto. No dependas de funciones experimentales.

## Estructura de carpetas propuesta

```
src/
  app/
    (publico)/ingreso/            inicio de sesión
    (portal)/                     layout con barra lateral y barra superior
      page.tsx                    Inicio
      primer-dia/
      indice/
      bloque/[codigo]/
      ruta/
      evaluaciones/[modulo]/
      perfil/
      glosario/
      tutor/
      equipo/
      admin/contenido/
      ayuda/
    api/                          solo lo que no puedan hacer las acciones de servidor
  componentes/
    indice/                       BarraIndice, MigasDePan, SeccionAncla
    avance/                       BotonContinuar, AnilloAvance, ListaSemana1
    examen/                       Examen, Pregunta, Resultado
    equipo/                       MatrizCompetencias
    ui/                           primitivas shadcn
  lib/
    continuar.ts                  algoritmo de "Continuar" (función pura)
    niveles.ts                    cálculo de nivel de permiso (función pura)
    textos.ts                     todo el microcopy
    contenido/                    lectura de content/, glosario, búsqueda
    supabase/                     clientes de servidor y de navegador
  pruebas/
content/                          secciones en Markdown (fuente de verdad)
data/                             índice, módulos, glosario
supabase/migrations/              esquema, políticas y funciones
scripts/                          validación y carga de contenido
```

## Flujo del contenido

1. `content/**/*.md` es la fuente de verdad. Cada archivo tiene frontmatter (`codigo`, `titulo`, `modulo`, `estado`, `origen`, `responsable`, `version`, `revisado`, `fuente_sugerida`).
2. `pnpm validate:content` verifica que todas las hojas del índice tengan archivo, que el frontmatter sea válido y que ninguna sección `validado` carezca de `responsable` y `revisado`.
3. En el build, el contenido se compila a páginas estáticas por bloque y a un índice de búsqueda.
4. `pnpm seed:content` sincroniza `secciones` y `modulos` con Supabase para que el avance de cada persona se relacione con ellas.
5. Editar contenido desde el portal (`/admin/contenido`) queda para la Fase 3 y solo cambia metadatos (estado, responsable, revisión); el texto se sigue editando en git.

## Modelo de datos

Definido en `supabase/migrations/0001_esquema.sql`. Tablas: `sedes`, `perfiles`, `modulos`, `secciones`, `progreso`, `preguntas`, `refuerzos`, `intentos`, `certificaciones`, más la vista `matriz_competencias`.

Decisiones de seguridad que no se deben deshacer:

- **RLS en todas las tablas con datos de personas.** Cada persona ve lo suyo; el tutor ve a sus acompañados; el líder ve su sede; el administrador ve todo. Las sedes no se mezclan.
- **Calificación en el servidor.** La tabla `preguntas` guarda las respuestas correctas y solo la leen líder y administrador. El navegador consume la vista `preguntas_publicas` (sin respuestas ni explicaciones) y califica con `calificar_intento()`, que devuelve la calificación y la explicación de cada error y registra el intento.
- **Dos intentos y refuerzo.** `calificar_intento()` bloquea un tercer intento si no hay un refuerzo posterior a los dos últimos fallos.
- **Sin autoascenso.** Nadie edita su propio rol ni su nivel de permiso; solo el administrador.

## Autenticación

- Correo corporativo con invitación del administrador (la invitación crea el perfil con la clave de servicio, solo en servidor).
- Verificación en dos pasos disponible y recomendada; obligatoria para líderes y administradores.
- Sesiones con renovación segura. Cierre de sesión visible en Perfil.
- Nunca hay cuentas compartidas: una persona, una cuenta.

## Rendimiento

- Primera pantalla en menos de 2 s en 4G: render en servidor, contenido estático por bloque, fuentes con `next/font`, imágenes optimizadas.
- Presupuesto de JavaScript inicial: lo mínimo; carga diferida de examen, matriz de competencias y búsqueda.
- Datos del usuario (avance, nivel) con caché corta y revalidación al volver a enfocar la pestaña.

## Sin conexión (PWA)

- Instalable, con ícono y nombre de HC.
- Se guardan en caché: la estructura de la aplicación, el índice de búsqueda y cada bloque visitado.
- Las marcas de "leída" hechas sin red se guardan localmente y se sincronizan al volver. Los exámenes requieren conexión (se califican en el servidor); el mensaje lo explica.

## Observabilidad y operación

- Registro de errores del servidor y del cliente sin datos personales en los mensajes.
- Respaldos automáticos de la base de datos y prueba de restauración documentada en el README de operación.
- README de operación: cómo invitar personas, cambiar contenido, cargar preguntas, ver vencimientos, restaurar un respaldo.

## Variables de entorno

Ver `.env.example`. La clave de servicio de Supabase solo existe en servidor y nunca lleva el prefijo público.

## Lo que se deja fuera a propósito

- Datos clínicos o de pacientes.
- Edición de permisos de Notion desde el portal.
- Chat o comentarios entre usuarios en la primera versión.
- Gamificación (puntos, rankings): el avance se muestra, no se compite.
