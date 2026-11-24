# Fases de entrega

Una fase a la vez. Al cerrar cada una: `pnpm check`, `pnpm test:e2e`, resumen de lo hecho y lo pendiente, y esperar revisión. Las casillas son la lista de verificación de cierre.

## Fase 0: fundación

Objetivo: un proyecto vacío pero sano, con todas las barreras de calidad funcionando.

- [ ] Proyecto creado con el stack de `docs/04-arquitectura.md`; repositorio git inicializado.
- [ ] Tokens de `design/tokens.css` conectados a Tailwind y al modo claro/oscuro.
- [ ] Componentes base (botón, enlace, tarjeta, entrada, etiqueta, diálogo) con estados de foco, hover y deshabilitado.
- [ ] `src/lib/textos.ts` creado con los textos fijos de `docs/03-experiencia-y-diseno.md`.
- [ ] Scripts `check`, `test:e2e`, `validate:content`, `seed:content` funcionando.
- [ ] Migración `0001_esquema.sql` aplicada en un proyecto de Supabase de desarrollo.
- [ ] Integración continua que corre `pnpm check` y Playwright en cada cambio.
- [ ] README de operación con el mínimo: cómo levantar el proyecto.

## Fase 1: navegar y aprender

Objetivo: entrar, ver el índice con hipervínculos, leer secciones y avanzar.

- [ ] Inicio de sesión con correo y contraseña; rutas protegidas.
- [ ] Layout con barra lateral de tres niveles, numerada, plegable; cajón y barra inferior en celular.
- [ ] Anclas `#s-1-1-1`: clic en el índice desplaza, resalta y mueve el foco; la barra marca la sección activa.
- [ ] Migas de pan; botones Anterior y Siguiente.
- [ ] Páginas de bloque generadas desde `content/`, con las secciones `pendiente` visiblemente marcadas.
- [ ] Buscador global con índice del build, atajos `/` y `Ctrl+K`, tolerancia a acentos y errores.
- [ ] Inicio: "Empieza aquí", "Tu avance", "Tu ruta".
- [ ] Botón Continuar con su algoritmo y pruebas unitarias (casos: primera vez, a mitad, todo pendiente, ruta terminada).
- [ ] Marcar sección como leída; progreso guardado por persona.
- [ ] Enlaces "Abrir en Notion" donde hay `fuente_sugerida` o `notion_url`.
- [ ] Glosario con definiciones en el texto y página `/glosario`.
- [ ] Recorrido de primer día y lista de la semana 1.
- [ ] `pnpm seed:content` carga secciones y módulos.

**Aceptación:** una persona sin instrucciones encuentra Continuar en menos de 10 s; todo se usa a 360 px y con teclado; axe sin errores graves.

## Fase 2: evaluar y certificar

Objetivo: exámenes, intentos, niveles y perfil.

- [ ] Banco de preguntas por módulo cargado desde un archivo con el formato de `data/preguntas.plantilla.json`.
- [ ] Examen con una pregunta por pantalla en celular, resultado inmediato con explicación de cada error.
- [ ] Calificación con `calificar_intento()`; verificar en pruebas que el navegador nunca recibe las respuestas correctas.
- [ ] Regla de dos intentos y refuerzo; botón "Pedir refuerzo" que avisa al tutor.
- [ ] Mi ruta con estado por módulo (pendiente, en curso, aprobado).
- [ ] Mi perfil: nivel calculado con `src/lib/niveles.ts` (con pruebas unitarias), certificación y próxima recertificación.
- [ ] Registro de prácticas y certificación final por tutor, líder o administrador.

**Aceptación:** las evaluaciones califican, explican cada error y respetan el 80 %; un tercer intento sin refuerzo se rechaza en el servidor; el nivel mostrado coincide con las reglas de `docs/02-modulos-y-niveles.md`.

## Fase 3: acompañar y gobernar

Objetivo: tutores, líderes y administradores trabajan desde el portal.

- [ ] Panel del tutor: acompañados por días sin avanzar, registros por revisar, autorización de refuerzos.
- [ ] Panel de equipo: matriz de competencias (personas por módulos), vencimientos de los próximos 30 días, filtro por sede.
- [ ] Alerta de dependencia: módulos con menos de 2 personas certificadas para impartirlos.
- [ ] Gestión de personas: invitar, asignar puesto, sede, ruta y tutor.
- [ ] `/admin/contenido`: estado, responsable y fecha de revisión por sección; vencidas resaltadas.
- [ ] Pruebas e2e de aislamiento: un usuario de la sede A nunca ve datos de la sede B.

**Aceptación:** un líder ve solo su sede; un tutor ve solo a sus acompañados; nadie puede cambiarse el rol ni el nivel.

## Fase 4: confiable en campo

Objetivo: que funcione donde se usa.

- [ ] PWA instalable; caché del contenido visitado y del índice de búsqueda.
- [ ] Marcas de "leída" sin red, con sincronización al volver.
- [ ] Avisos de recertificación y vencimiento (correo y banda en el portal).
- [ ] Auditoría de rendimiento: primera pantalla en menos de 2 s en 4G simulado.
- [ ] Auditoría completa de accesibilidad con la lista de `docs/03-experiencia-y-diseno.md`.
- [ ] README de operación completo y prueba de restauración de respaldo.

## Fase 5: mejoras opcionales (proponer antes de construir)

Cada una necesita contenido o decisiones de HC; no se asume.

- **Respuestas rápidas "¿Qué hago si…?"**: tarjetas de una pantalla para situaciones frecuentes en campo. El contenido lo define el responsable de cada área.
- **Certificado en PDF** al aprobar un módulo o la certificación final.
- **Sesiones de capacitación**: calendario con instructor, asistentes y constancia (reemplaza el calendario anual vacío de Notion).
- **Mapas de equipo crítico por sede**, cuando exista el inventario validado.
- **Exportar la matriz de competencias** a hoja de cálculo para dirección.
- **Encuesta breve** al terminar cada módulo para mejorar el contenido.

## Cómo medir que funciona

| Indicador | Qué mide | Meta propuesta |
| --- | --- | --- |
| Días hasta Nivel 2 | Rapidez para llegar a autonomía | 30 días o menos |
| Aprobación del núcleo al primer intento | Calidad del contenido y de la enseñanza | 80 % o más de las personas |
| Personal con certificación vigente | Cobertura | 100 % al cierre de mayo de 2027 |
| Personas certificadas para impartir cada módulo | Dependencia de una sola persona | 2 o más por módulo |
| Secciones con responsable y revisión vigente | Gobierno del contenido | 100 % |

Las metas son propuestas; se ajustan con los datos del piloto.
