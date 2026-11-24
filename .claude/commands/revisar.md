---
description: Revisión de calidad antes de dar por terminado un cambio
---

Revisa los cambios actuales (`git diff` y archivos nuevos) como un revisor exigente.

- **Contenido:** nada inventado; lo no confirmado sigue como `pendiente` o `borrador`; normas solo como referencia por validar.
- **Seguridad:** ninguna respuesta correcta llega al cliente; toda regla de calificación y permisos vive en la base; RLS cubre cada tabla nueva; sin secretos en el repositorio.
- **Accesibilidad:** contraste según `design/tokens.css`, foco visible, navegación por teclado, áreas táctiles de 44 px, estados con icono y texto, `prefers-reduced-motion`.
- **Experiencia:** una acción principal por pantalla, lenguaje sencillo, estados vacíos y de error redactados, funciona en celular.
- **Código:** TypeScript estricto sin `any`, validación con Zod en los bordes, pruebas para lógica nueva (especialmente "Continuar" y calificación).

Entrega una lista priorizada (crítico / importante / menor) con archivo y línea, y corrige lo crítico sin esperar.
