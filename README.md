# Kit del portal de incorporación — HC Promedical

Todo lo necesario para que Claude Code construya el portal de incorporación y capacitación de HC Promedical, desde el índice base hasta la certificación.

## Cómo usarlo

1. Descomprime este zip en una carpeta vacía, por ejemplo `portal-hc-promedical/`.
2. Copia el logotipo de HC Promedical en `assets/` (PNG o SVG). Sin él, el portal usa un marcador neutro.
3. Abre la carpeta en Claude Code y pega el contenido de `PRIMER-MENSAJE.txt`.
4. Revisa el plan que te devuelva. Cuando lo apruebes, trabajará una fase a la vez y te pedirá revisión al cerrar cada una.

Si no tienes un repositorio git, Claude Code puede inicializarlo en el paso 4.

## Qué contiene

```
CLAUDE.md                  reglas del proyecto (Claude Code lo lee solo)
PRIMER-MENSAJE.txt         mensaje de arranque para pegar
docs/
  00-brief.md              objetivo, usuarios, páginas, criterios de aceptación
  01-indice.md             índice de 10 bloques y 3 niveles (numeración oficial)
  02-modulos-y-niveles.md  módulos, horas, niveles de permiso, evaluación
  03-experiencia-y-diseno.md  principios de UX, flujos, pantallas, microcopy
  04-arquitectura.md       stack, carpetas, seguridad, rendimiento
  05-fases.md              plan por fases con listas de verificación
  06-contenido-pendiente.md  lo que falta validar
  07-decisiones.md         decisiones tomadas y su motivo
data/
  indice.json              índice como árbol anidado
  secciones.json           índice aplanado, listo para cargar a la base
  modulos.json             33 módulos con horas y evidencia
  glosario.json            siglas y términos con su definición
  preguntas.plantilla.json formato de preguntas de examen (2 ejemplos)
content/                   108 secciones en Markdown (22 borradores, 86 pendientes)
design/
  tokens.css               paleta, tipografía, espaciado, modo claro y oscuro
  wireframes.md            pantallas principales en móvil y escritorio
supabase/migrations/
  0001_esquema.sql         tablas, RLS, calificación de exámenes en el servidor
scripts/
  validar-contenido.mjs    valida frontmatter y cobertura del índice
.claude/
  commands/                /fase, /revisar, /contenido
  agents/revisor-ux.md     agente que audita pantallas
assets/                    aquí va el logotipo
```

## Qué trae de más

Además del índice con hipervínculos, el kit pide al portal:

- Un botón **Continuar** que decide el siguiente paso por la persona.
- Un recorrido de **primer día** y la lista de la **semana 1** con casillas.
- **Glosario con definiciones al pasar el cursor** sobre cada sigla (MP, MC, EPP, PSA, RPBI y más).
- **Búsqueda sin conexión** y lectura de lo ya visitado en el celular.
- **Exámenes calificados en el servidor**, para que las respuestas correctas no viajen al navegador, con la regla de dos intentos y refuerzo del tutor.
- **Matriz de competencias** para ver quién puede hacer qué y detectar dependencias de una sola persona.
- **Gobierno del contenido**: cada sección tiene responsable, versión y fecha de revisión, y un validador evita publicar texto sin validar.

## Estado del contenido

El kit incluye 22 secciones en `borrador` con texto tomado de Notion o de los criterios de documentación de HC, y 86 en `pendiente`. Nada está `validado`: eso lo decide una persona responsable de HC. Los pendientes por confirmar están en `docs/06-contenido-pendiente.md`.
