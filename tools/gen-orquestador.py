#!/usr/bin/env python3
"""Regenera la tabla de skills de biblioteca de skills/orquestador/SKILL.md.
Fuente única: los SKILL.md de la biblioteca + `skillOverrides` de ~/.claude/settings.json
(o del fichero que indique la variable CLAUDE_SETTINGS).
  "on"                 → skill cargada siempre (su descripción entra en cada turno): NO aparece en la tabla.
  "user-invocable-only"→ biblioteca: Claude no la ve; el usuario puede teclear /nombre; se carga con Read.
  "off"                → archivada: ni aparece.
Uso: tools/gen-orquestador.py [--check]   (--check sale 1 si la tabla está desactualizada)"""
import json, os, re, sys

LIB = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "/skills"
SET = os.environ.get("CLAUDE_SETTINGS") or os.path.expanduser("~/.claude/settings.json")
OUT = LIB + "/orquestador/SKILL.md"
ov = json.load(open(SET)).get("skillOverrides", {})

def desc(n):
    t = open(f"{LIB}/{n}/SKILL.md", encoding="utf-8").read()
    m = re.search(r"^description:\s*(.+?)(?=\n[a-z_-]+:|\n---)", t, re.S | re.M)
    d = re.sub(r"\s+", " ", (m.group(1) if m else "").strip().strip('"'))
    d = re.split(r"(?<=[.])\s", d)[0]            # primera frase
    return d if len(d) <= 150 else d[:147].rsplit(" ", 1)[0] + "…"

filas = [f"| `{n}` | {desc(n)} |" for n in sorted(ov) if ov[n] == "user-invocable-only" and os.path.isdir(f"{LIB}/{n}")]
tabla = "\n".join(filas)
cur = open(OUT, encoding="utf-8").read()
nuevo = re.sub(r"(<!-- tabla:inicio -->\n).*?(<!-- tabla:fin -->)", lambda m: m.group(1) + tabla + "\n" + m.group(2), cur, flags=re.S)
if "--check" in sys.argv:
    sys.exit(0 if nuevo == cur else 1)
open(OUT, "w", encoding="utf-8").write(nuevo)
print(f"{len(filas)} skills de biblioteca en la tabla")
