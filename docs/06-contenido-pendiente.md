# Contenido pendiente y por validar

Este documento lista lo que **no** se debe inventar ni publicar como definitivo. Si Claude Code necesita alguno de estos datos, lo pregunta; no lo rellena.

## Estado actual del contenido

| Estado | Secciones | Qué significa |
| --- | --- | --- |
| `validado` | 0 | Revisado y aprobado por una persona responsable de HC |
| `borrador` | 22 | Tiene texto con fuente (Notion, criterios de documentación o propuesta del programa); falta validarlo |
| `pendiente` | 86 | Sin texto validado; el portal muestra "Pendiente de validar" |

Las 22 secciones en borrador son: 1.2.3, 1.2.4, 1.2.5, 3.4.1, 3.4.2, 4.1.1 a 4.1.4, 4.2.1 a 4.2.4, 7.2.2, 8.1.1, 10.1.1, 10.1.2, 10.2.1, 10.2.2, 10.3.2, 10.4.1 y 10.4.2. El campo `origen` de cada una indica de dónde salió: `notion:<página>`, `usuario:criterios de documentación` o `propuesta-programa`.

## Datos que deben confirmarse con HC

- [ ] **Dueño del programa:** quién responde por él y cuánto tiempo de su jornada se destina.
- [ ] **Plan de Notion y número de personas:** define permisos por teamspace, automatizaciones e historial.
- [ ] **Cuentas compartidas en Notion** ("Departamento de Servicio HC Promedical", "GRUPO HC", "Ventas HC Promedical"): confirmar si son cuentas de área y quién las usa.
- [ ] **Responsables vigentes por póliza:** la página de inducción biomédica del 18 de agosto de 2026 puede nombrar responsables que ya cambiaron.
- [ ] **Cifras de pólizas (1.2.5):** 152 equipos en CEM La Paz y 75 en CMJ vienen de esa misma página; validar antes de publicar.
- [ ] **Correo de acceso:** el diseño asume correo corporativo; si hay personas sin correo de HC, hay que cambiar la regla de invitación.
- [ ] **Logotipo y colores de marca:** hasta entonces, paleta propuesta en `design/tokens.css`.
- [ ] **Archivos faltantes del calendario anual 2026 en Notion:** presentaciones y evaluaciones que aparecen vacías; confirmar si existen fuera de Notion.
- [ ] **Horas de capacitación dentro de la jornada** y cobertura de guardias mientras se imparten.

## Normas y estándares a validar con calidad

Se citan como referencias de partida, sin haber consultado su texto vigente. Ninguna se publica como contenido de examen hasta que calidad confirme versión y aplicación por sede.

| Referencia | Dónde aparece |
| --- | --- |
| IEC 60601-1 e IEC 62353 | B3, Seguridad eléctrica y pruebas de desempeño |
| NFPA 99 | B5, Gases medicinales y manifold |
| NOM-016-SSA3 y Hospital Seguro | B7, Marco normativo hospitalario |
| NOM-045-SSA2 y manejo de RPBI | B6, Control de infecciones y RPBI |
| NOM-STPS aplicables (EPP, instalaciones eléctricas, ergonomía, emergencias, factores de riesgo psicosocial) | N6, Seguridad y salud en el trabajo |

## Contenido que alguien de HC debe escribir

Las secciones `pendiente` necesitan texto de la fuente oficial. Las más críticas para el primer día:

1. 1.1.1 a 1.1.3: misión, visión y valores (existe presentación de cultura en Notion).
2. 1.3.1 a 1.3.5: reglamento, código de conducta y políticas (existen PDF en Notion).
3. 2.1 y 2.2: seguridad de la información (no existe documento).
4. 3.3.2 y 3.3.4: convenciones de nombres y dónde vive cada cosa (no existe documento).
5. 5.1 a 5.3: seguridad y salud (existe manual de seguridad según la lista de inducción; falta el archivo).

## Bancos de examen

No hay preguntas de HC cargadas. `data/preguntas.plantilla.json` trae dos ejemplos genéricos de Notion para probar el formato. Cada módulo necesita un banco escrito o validado por su responsable, con respuesta correcta y explicación de cada opción incorrecta.

## Glosario

Las entradas marcadas `por-validar` en `data/glosario.json` (marcas y equipos) se muestran con la etiqueta "Definición por validar" hasta que un responsable las confirme.
