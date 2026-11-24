# Brief del portal

## Objetivo

Que cualquier persona que entre a HC Promedical, sin explicación previa, entienda en menos de un minuto dónde está, qué sigue y cómo avanzar, y que al terminar el programa pueda trabajar al nivel que exige la empresa.

El portal es el **índice vivo** de todo lo que se debe saber al ingresar. Cada punto del índice (`docs/01-indice.md`) es un hipervínculo a su sección.

## Usuarios y roles

| Rol de acceso | Quién es | Qué necesita |
| --- | --- | --- |
| Colaborador | Personal nuevo y actual: biomédicos, técnicos de servicios generales y PSA, ventas y administración | Saber qué sigue, estudiar, hacer exámenes, ver su avance y su nivel |
| Tutor | Persona que acompaña a uno o más ingresos | Ver el avance de sus acompañados, revisar registros, autorizar refuerzos |
| Líder | Encargado de póliza o de equipo | Ver la matriz de competencias de su sede, vencimientos, certificar |
| Administrador | Responsable del programa | Gestionar personas, módulos, contenido y permisos |

Contexto de uso: computadora y, sobre todo, celular, dentro de hospitales, con prisa y a veces con mala señal.

## Principios de experiencia

1. Siempre se sabe dónde se está y qué sigue: botón principal **Continuar**.
2. Cualquier contenido a tres clics o menos.
3. Una pregunta y una acción principal por pantalla.
4. Lenguaje llano, frases cortas, sin jerga de sistemas.
5. Cero relleno: nada de texto de ejemplo; los estados vacíos explican qué hacer.
6. Diseño sobrio y clínico: aire, jerarquía clara, ningún adorno que no informe.

El detalle de flujos, pantallas y microcopy está en `docs/03-experiencia-y-diseno.md`.

## Navegación

- **Barra lateral** con el índice completo a tres niveles, numerado (1, 1.1, 1.1.1), plegable. En celular: cajón abierto desde un botón de menú y barra inferior con Inicio, Índice, Mi ruta y Perfil.
- Cada entrada es un **enlace con ancla** (`#s-1-1-1`). Al hacer clic la página se desplaza a la sección y la resalta un momento; al desplazarse, la barra marca la sección activa.
- **Ruta de migas** en cada página.
- **Buscador global** (atajos `/` y `Ctrl+K`) sobre títulos y contenido, tolerante a acentos y errores de escritura, que funciona sin conexión.
- **Anterior / Siguiente** al final de cada sección.
- **Abrir en Notion** en cada sección que tenga documento fuente (`notion_url`), en pestaña nueva.

## Páginas

| Ruta | Página | Qué hace |
| --- | --- | --- |
| `/` | Inicio | "Empieza aquí", "Tu avance" con Continuar, "Tu ruta" |
| `/primer-dia` | Primer día | Recorrido de 3 pasos y lista de la semana 1 |
| `/indice` | Índice completo | Mapa de todo el programa con avance por sección |
| `/bloque/[codigo]` | Bloque | Un bloque con sus secciones y subsecciones ancladas |
| `/ruta` | Mi ruta | Módulos de su puesto con horas y estado |
| `/evaluaciones` y `/evaluaciones/[modulo]` | Evaluaciones | Examen por módulo con resultado inmediato y explicación de cada error |
| `/perfil` | Mi perfil | Nivel de permiso, módulos aprobados, certificación, recertificación |
| `/glosario` | Glosario | Siglas y términos |
| `/tutor` | Panel del tutor | Avance de sus acompañados, registros por revisar |
| `/equipo` | Panel de líder y administrador | Matriz de competencias, vencimientos a 30 días |
| `/admin/contenido` | Contenido | Estado, responsable y revisión de cada sección |
| `/ayuda` | Ayuda | Preguntas frecuentes y contacto del tutor |
| `/ingreso` | Ingreso | Inicio de sesión |

## Qué no es

- No es un sistema clínico: no guarda datos de pacientes ni información clínica.
- No reemplaza a Notion: enlaza a los documentos fuente, que siguen viviendo allí.
- No sustituye la evaluación práctica en campo: la registra.

## Criterios de aceptación globales

- Una persona sin instrucciones encuentra el botón Continuar en menos de 10 segundos.
- Cada entrada del índice lleva a su ancla, la resalta y la barra marca la sección activa.
- Todo funciona y se lee bien desde 360 px de ancho.
- Navegación completa solo con teclado; foco siempre visible.
- Las evaluaciones califican, explican cada error y respetan el mínimo de 80 %.
- Un usuario no puede ver registros de otra sede ni de personas ajenas a su rol.
- Carga en menos de 2 segundos en 4G para la primera pantalla.
- Cero errores graves o críticos en axe y puntuación de accesibilidad de 95 o más en Lighthouse.

Los umbrales numéricos son propuestas: se ajustan con los resultados del piloto.
