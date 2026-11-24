---
description: Ejecuta una fase del plan (docs/05-fases.md) de principio a fin
argument-hint: <número de fase>
---

Ejecuta la **fase $ARGUMENTS** de `docs/05-fases.md`.

1. Lee `CLAUDE.md`, `docs/05-fases.md` y los documentos que la fase cite.
2. Resume en cinco líneas qué vas a construir y qué queda fuera. Si hay una duda que cambie el resultado, pregunta; si no, avanza.
3. Construye solo lo de esta fase. No adelantes fases posteriores.
4. Al terminar, corre `pnpm lint`, `pnpm typecheck`, `pnpm test` y `node scripts/validar-contenido.mjs`. Corrige lo que falle.
5. Comprueba cada criterio de aceptación de la fase y repórtalo como lista: cumplido / no cumplido / no verificable.
6. Registra decisiones nuevas en `docs/07-decisiones.md`.
7. Cierra con: qué quedó listo, qué quedó pendiente y cuál es la siguiente fase.

Nunca marques contenido como `validado` ni inventes información técnica de equipos, normas o procedimientos.
