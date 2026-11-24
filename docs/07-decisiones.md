# Decisiones tomadas

Cada decisión puede cuestionarse en el plan. Si propones cambiarla, explica el motivo y el costo.

| # | Decisión | Motivo |
| --- | --- | --- |
| 1 | El contenido vive en Markdown dentro del repositorio (`content/`) y se sincroniza a la base | Se revisa como código, tiene historial, funciona sin conexión y no depende de que alguien edite en un panel. La base guarda lo que es de las personas: avance, intentos, certificaciones |
| 2 | El índice se define una vez (`data/indice.json`) y de ahí salen la barra lateral, las páginas y la validación | Una sola fuente evita que la numeración y el contenido se desalineen |
| 3 | Las anclas usan el prefijo `s-` (`#s-1-1-1`) | Un identificador que empieza con dígito es válido en HTML pero incómodo como selector CSS |
| 4 | Los exámenes se califican en el servidor con una función SQL | Si las respuestas correctas viajan al navegador, cualquiera las ve en el inspector |
| 5 | Dos intentos y refuerzo se hacen cumplir en la base, no en la interfaz | Una regla que solo vive en la pantalla se evade |
| 6 | El portal calcula y muestra el nivel de permiso, pero no cambia permisos de Notion | Mantiene separados el registro de la capacitación y la administración de otra herramienta |
| 7 | La búsqueda vive en el cliente con un índice generado en el build | Funciona sin conexión y sin costo por consulta, con un volumen de contenido pequeño |
| 8 | Las secciones `pendiente` no cuentan para el avance ni para Continuar | Evita callejones sin salida y porcentajes que nunca llegan a 100 |
| 9 | El estado `validado` solo lo cambia una persona responsable | El portal enseña normas y procedimientos de equipo médico; el contenido no puede salir de una suposición |
| 10 | No hay gamificación ni rankings | El objetivo es competencia, no competencia entre personas; el avance se muestra sin compararlas |
| 11 | Sin comentarios ni chat entre usuarios en la primera versión | Reduce moderación y superficie de datos; las dudas van al tutor |
| 12 | Sedes separadas por diseño (`sede_id` en perfiles y RLS por sede) | Los registros de una póliza no deben mezclarse con los de otra |
| 13 | Sin marcas de herramientas de generación de código en interfaz, código ni metadatos | Es un producto interno de HC y debe verse y mantenerse como tal |
