#!/usr/bin/env node
// Valida que el contenido del portal esté completo y sea coherente.
// Uso: node scripts/validar-contenido.mjs
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const raiz = join(dirname(fileURLToPath(import.meta.url)), "..");
const errores = [];
const avisos = [];

const leerJson = (ruta) => JSON.parse(readFileSync(join(raiz, ruta), "utf8"));
const secciones = leerJson("data/secciones.json");
const modulos = leerJson("data/modulos.json");
const codigosModulo = new Set(modulos.map((m) => m.codigo));
const codigosSeccion = new Set(secciones.map((s) => s.codigo));

// 1. Referencias internas
for (const s of secciones) {
  if (s.modulo_codigo && !codigosModulo.has(s.modulo_codigo))
    errores.push(`${s.codigo}: módulo inexistente (${s.modulo_codigo})`);
  if (s.padre_codigo && !codigosSeccion.has(s.padre_codigo))
    errores.push(`${s.codigo}: padre inexistente (${s.padre_codigo})`);
}

// 2. Archivos de contenido
const archivos = [];
const recorrer = (dir) => {
  for (const nombre of readdirSync(dir)) {
    const ruta = join(dir, nombre);
    if (statSync(ruta).isDirectory()) recorrer(ruta);
    else if (nombre.endsWith(".md")) archivos.push(ruta);
  }
};
recorrer(join(raiz, "content"));

const porCodigo = new Map();
const ESTADOS = new Set(["pendiente", "borrador", "validado"]);

const leerFrontmatter = (texto) => {
  const m = texto.match(/^---\n([\s\S]*?)\n---/);
  if (!m) return null;
  const datos = {};
  for (const linea of m[1].split("\n")) {
    const i = linea.indexOf(":");
    if (i === -1) continue;
    let valor = linea.slice(i + 1).trim();
    if (valor.startsWith('"') && valor.endsWith('"')) valor = valor.slice(1, -1);
    datos[linea.slice(0, i).trim()] = valor === "null" ? null : valor;
  }
  return datos;
};

for (const ruta of archivos) {
  const rel = ruta.slice(raiz.length + 1);
  const fm = leerFrontmatter(readFileSync(ruta, "utf8"));
  if (!fm) {
    errores.push(`${rel}: sin frontmatter`);
    continue;
  }
  for (const campo of ["codigo", "titulo", "estado", "version"]) {
    if (!fm[campo]) errores.push(`${rel}: falta '${campo}'`);
  }
  // Las secciones del bloque 10 son transversales y no pertenecen a un módulo.
  const esperado = secciones.find((x) => x.codigo === fm.codigo);
  if (esperado?.modulo_codigo && !fm.modulo) errores.push(`${rel}: falta 'modulo'`);
  if (fm.estado && !ESTADOS.has(fm.estado))
    errores.push(`${rel}: estado inválido (${fm.estado})`);
  if (fm.estado === "validado") {
    if (!fm.responsable) errores.push(`${rel}: 'validado' exige responsable`);
    if (!fm.revisado) errores.push(`${rel}: 'validado' exige fecha de revisión`);
  }
  if (fm.modulo && !codigosModulo.has(fm.modulo))
    errores.push(`${rel}: módulo inexistente (${fm.modulo})`);
  if (fm.codigo) {
    if (porCodigo.has(fm.codigo)) errores.push(`${rel}: código duplicado (${fm.codigo})`);
    porCodigo.set(fm.codigo, fm);
  }
}

// 3. Cada hoja del índice debe tener su archivo
const hojas = secciones.filter((s) => s.hoja);
for (const h of hojas) {
  if (!porCodigo.has(h.codigo)) errores.push(`Hoja sin archivo de contenido: ${h.codigo} ${h.titulo}`);
}
for (const codigo of porCodigo.keys()) {
  if (!codigosSeccion.has(codigo)) errores.push(`Contenido huérfano (no está en el índice): ${codigo}`);
}

// 4. Resumen
const conteo = { pendiente: 0, borrador: 0, validado: 0 };
for (const fm of porCodigo.values()) if (conteo[fm.estado] !== undefined) conteo[fm.estado]++;

console.log(`Módulos: ${modulos.length} · Secciones: ${secciones.length} · Hojas: ${hojas.length} · Archivos: ${archivos.length}`);
console.log(`Estado → pendiente: ${conteo.pendiente} · borrador: ${conteo.borrador} · validado: ${conteo.validado}`);
if (existsSync(join(raiz, "data/preguntas.json")) === false)
  avisos.push("Aún no existe data/preguntas.json (usa data/preguntas.plantilla.json como base).");

for (const a of avisos) console.warn(`Aviso: ${a}`);
if (errores.length) {
  console.error(`\n${errores.length} error(es):`);
  for (const e of errores) console.error(` - ${e}`);
  process.exit(1);
}
console.log("Contenido válido.");
