---
description: Redacta o mejora el contenido de una sección a partir de fuentes reales
argument-hint: <código de sección, ej. 3.1.2>
---

Trabaja la sección **$ARGUMENTS** en `content/`.

1. Lee su archivo, su módulo en `data/modulos.json` y `docs/06-contenido-pendiente.md`.
2. Si tiene `fuente_sugerida` de Notion y el conector está disponible, lee esa página y úsala como base. Si no hay fuente accesible, **no redactes contenido técnico**: deja la sección en `pendiente` y lista qué información hace falta y quién debe aportarla.
3. Redacta en español claro, frases cortas, pasos numerados cuando sea un procedimiento. Una idea por párrafo.
4. Deja el estado en `borrador`. Solo una persona responsable puede pasarlo a `validado`; no lo hagas tú.
5. Actualiza `version` y `origen`. No inventes responsables, fechas de revisión, cifras ni normas.
6. Corre `node scripts/validar-contenido.mjs`.
