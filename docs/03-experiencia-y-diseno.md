# Experiencia y diseño

Objetivo de diseño: que alguien que nunca vio el portal sepa qué hacer sin leer instrucciones. Si una pantalla necesita explicación, se rediseña la pantalla.

## 1. Arquitectura de información

El índice (`docs/01-indice.md`) define el contenido. Tres vistas del mismo índice:

- **Barra lateral:** navegación permanente, tres niveles, numerada.
- **Índice completo (`/indice`):** mapa con casilla de avance por sección.
- **Mi ruta (`/ruta`):** solo los módulos del puesto, en orden, con horas y estado.

Orden de aprendizaje (usado por Continuar y por Mi ruta):

1. Núcleo: bloques 1 a 7, en orden.
2. Ruta del puesto: las secciones de su rama del bloque 8.
3. Bloque 10 (evaluación y certificación): siempre visible, se lee al terminar la ruta.
4. Bloque 9 (avanzado): se desbloquea a partir del día 90 o con Nivel 2.

## 2. El botón Continuar

Es la pieza que hace intuitivo al portal. Aparece en Inicio, en la barra superior de cada sección y en el estado vacío de cualquier lista.

Algoritmo (es una función pura y se prueba con pruebas unitarias):

1. Toma las secciones hoja del orden de aprendizaje de la persona.
2. Descarta las que tienen `estado: pendiente` (no se puede estudiar lo que no existe).
3. Devuelve la primera sin progreso registrado.
4. Si no queda ninguna, ofrece el examen del módulo pendiente más antiguo; si tampoco hay, muestra "Terminaste tu ruta" y lleva a Mi perfil.

El porcentaje de avance se calcula sobre las secciones que cuentan (paso 2), nunca sobre las pendientes.

## 3. Flujos principales

**Primer ingreso:** invitación por correo → crear contraseña y activar verificación en dos pasos → recorrido de primer día (3 pasos) → Inicio con Continuar resaltado.

**Estudiar una sección:** Continuar → sección → "Marcar como leída" → siguiente sección. Al terminar la última de un módulo, aparece "Hacer examen" o "Ver tu práctica".

**Examen:** pantalla de instrucciones (cuántas preguntas, mínimo 80 %, intentos restantes) → una pregunta por pantalla en celular → resultado con calificación, qué falló y por qué → si aprobó, Continuar; si no, repaso de las secciones relacionadas.

**Pedir refuerzo:** tras dos intentos fallidos, el examen se bloquea con el mensaje "Pide refuerzo a tu tutor" y un botón que le avisa. El tutor lo autoriza en su panel.

**Tutor revisa:** panel con acompañados ordenados por quien lleva más días sin avanzar, y bandeja de registros por revisar.

## 4. Recorrido de primer día (`/primer-dia`)

Tres pasos, se puede omitir y se vuelve a abrir desde Ayuda:

1. **Confirma quién eres:** nombre, puesto, sede y tutor, tomados de tu perfil.
2. **Así se usa el portal:** tres ideas ilustradas: el índice a la izquierda (o el botón de menú), el botón Continuar, el buscador.
3. **Tu primer paso:** botón Continuar.

Debajo, la **lista de la semana 1** (tabla de `docs/02-modulos-y-niveles.md`) con casillas. Las del colaborador se marcan solas al avanzar; las que requieren firma o evaluación solo las marca el tutor.

## 5. Glosario en el texto

Las siglas de `data/glosario.json` (MP, MC, EPP, PSA, RPBI…) se subrayan con línea punteada en el contenido. Al pasar el cursor, enfocar con teclado o tocar, aparece su definición. Reglas: solo la primera aparición por sección, accesible con teclado, y las entradas `por-validar` muestran la etiqueta "Definición por validar".

## 6. Búsqueda

- Atajos: `/` y `Ctrl+K` (`Cmd+K`). Botón visible en la barra superior, porque el atajo no se descubre solo.
- Índice de búsqueda generado en el build a partir de `content/` y `data/`; vive en el cliente para que funcione sin conexión.
- Tolerante a acentos, mayúsculas y errores de escritura. Resultados agrupados por bloque, con el número de sección ("3.3.2") bien visible.
- Sin resultados: sugiere términos del glosario y enlaza a Ayuda.

## 7. Estados que siempre se diseñan

| Estado | Qué muestra |
| --- | --- |
| Vacío | Qué falta, por qué y la acción para resolverlo |
| Cargando | Esqueletos con la forma del contenido, nunca una rueda sola |
| Error | Qué pasó, qué puede hacer la persona y cómo avisar al tutor |
| Sin conexión | Banda discreta; el contenido ya visitado se sigue leyendo; las acciones que requieren red se retienen y se envían al volver |
| Sección pendiente | Etiqueta "Pendiente de validar" y texto que explica que se está preparando |
| Sin permiso | Qué nivel se necesita y cómo conseguirlo |

## 8. Microcopy

Tono: tú, directo, amable, sin tecnicismos. Frases de menos de 20 palabras. Todos los textos viven en `src/lib/textos.ts`.

| En lugar de | Escribe |
| --- | --- |
| Submit, Enviar formulario | Guardar |
| Error 403 | No tienes permiso para ver esto. Pide el nivel 2 a tu tutor. |
| Operación completada exitosamente | Listo. Guardamos tu avance. |
| Usuario o contraseña inválidos | El correo o la contraseña no coinciden. Revísalos e inténtalo de nuevo. |
| Lo sentimos, ocurrió un error | No pudimos cargar esto. Revisa tu conexión y vuelve a intentarlo. |
| Módulo no aprobado | Te falta poco: aprobaste 72 % y el mínimo es 80 %. |

Palabras fijas: **Continuar**, **Marcar como leída**, **Hacer examen**, **Pedir refuerzo**, **Abrir en Notion**, **Tu avance**, **Tu ruta**. Una acción, una palabra, en todo el portal.

## 9. Diseño visual

Tokens en `design/tokens.css` (modo claro y oscuro, contrastes verificados). Pantallas de referencia en `design/wireframes.md`.

- **Color:** neutros fríos, un azul profundo como color de marca, un verde azulado de apoyo. El rojo se reserva para alertas de seguridad. Al llegar el logotipo de HC, se reemplazan los valores de marca en un solo archivo y el resto se adapta.
- **Tipografía:** sans humanista muy legible (Inter), 16 px de base, 18 px en lectura larga, interlineado de 1.6 en contenido, líneas de hasta 70 caracteres.
- **Forma:** esquinas de 8 a 12 px, sombras mínimas, bordes finos que separan en lugar de sombras que levantan.
- **Iconos:** un solo juego de línea (Lucide), siempre acompañados de texto en acciones principales.
- **Movimiento:** transiciones de 150 a 200 ms; respeta `prefers-reduced-motion` y entonces las elimina.
- **Densidad:** una columna de lectura al centro, barra lateral a la izquierda; en celular, una columna y barra inferior.

## 10. Accesibilidad (lista de verificación)

- [ ] HTML semántico: `nav`, `main`, `aside`, encabezados en orden, listas reales.
- [ ] Enlace "Saltar al contenido" como primer elemento enfocable.
- [ ] Foco visible en todo elemento interactivo, con contraste suficiente.
- [ ] Todo funciona con teclado; el orden de tabulación sigue el orden visual.
- [ ] Áreas táctiles de al menos 44 × 44 px.
- [ ] Contraste AA en texto y componentes, también en modo oscuro.
- [ ] Nada se comunica solo con color: estados con icono y texto.
- [ ] Anclas del índice mueven el foco a la sección, no solo el desplazamiento.
- [ ] Exámenes: preguntas como grupos con etiqueta, resultado anunciado con `aria-live`.
- [ ] Texto escalable al 200 % sin perder contenido ni funciones.
- [ ] `prefers-reduced-motion` y `prefers-color-scheme` respetados.
- [ ] Idioma declarado `es-MX`.
