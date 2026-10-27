---
name: repo-intake
description: Analizar un repo nuevo o desconocido antes de trabajar — stack, estructura, riesgos, puntos de entrada, plan. Todo repo externo es no confiable hasta esto.
---

# Repo intake

Análisis de **solo lectura**: nada se ejecuta (ni `npm install`, ni `make`, ni tests) hasta
completar el intake y decidirlo explícitamente. Repos externos se clonan primero al
scratchpad o a una carpeta de cuarentena, no directamente junto a los proyectos activos. Para skills
de Claude el análogo específico es `skill-auditor`.

## Inputs

- URL o ruta del repo y para qué se quiere (usar, estudiar, contribuir, auditar) — el plan final depende de esto.

## Pasos

0. **¿Ya visto?** Buscar `<nombre> [variantes]` en decisiones, informes y notas previas (`rg -i`) y pegar en el informe cuánto se escaneó y qué salió. Si ya hay veredicto, se respeta (no se re-evalúa) y se anota solo lo que ha cambiado.
1. **Mapa**: `find . -maxdepth 2 -not -path './.git/*' | sort` + README. ¿Monorepo o proyecto único? ¿Hay varios proyectos independientes conviviendo? (lección real: un repo migrado contenía varios proyectos independientes; no fusionar por parecido de nombre).
2. **Stack y manifiestos**: `pyproject.toml`/`requirements*.txt`, `package.json`, `Cargo.toml`, `compose*.yml`, `Dockerfile`, CI (`.github/workflows/`). Versiones fijadas ¿sí/no? ¿Lockfile presente y coherente?
3. **Puntos de entrada**: binarios/scripts declarados (`scripts` de package.json, `[project.scripts]`, `Makefile`, `main.py`/`index.*`), servicios que levanta, puertos que abre.
4. **Scripts con efectos**: hooks de instalación (`postinstall`, `setup.py` con código, makefiles que descargan), instaladores `curl|bash` (prohibidos por SAFETY_RULES — anotar y no ejecutar). `grep -rnE 'curl|wget|postinstall|preinstall' --include='*.json' --include='Makefile' --include='*.sh' | head`.
5. **Dependencias**: cuántas, cuán mantenidas las críticas, alguna sospechosa (typosquatting, versión flotante `*`). No instalar para averiguarlo: leer manifiestos.
6. **Secretos y datos**: qué espera (`.env.example`, config); confirmar que no hay secretos reales commiteados (`grep -rniE '(api[_-]?key|secret|token|password)\s*[:=]' --include='*.env*' --include='*.y*ml' --include='*.json' | grep -viE 'example|placeholder|your[_-]'`); qué datos necesita y si son sensibles.
7. **Estado y riesgos**: última actividad, tests existentes ¿corren en CI?, licencia, TODOs/FIXMEs masivos, partes muertas.
8. **Plan de trabajo** acorde al propósito: qué instalar (desde manifiesto, nunca copiando entornos), en qué orden validar (build → tests → arranque), qué no tocar, y qué preguntas quedan abiertas.

## Salida (informe corto)

`propósito · stack · estructura (3-6 líneas) · puntos de entrada · instalación prevista ·
riesgos con evidencia (línea/archivo) · plan de trabajo · preguntas abiertas`.

## Checks / evidencia

- Cada riesgo señalado cita archivo y línea; ninguna afirmación de "seguro/limpio" sin el grep correspondiente.
- El plan no incluye ejecutar nada que el intake haya marcado como sospechoso sin resolverlo antes.

## Documentar

Si el repo entra al workspace: normalizarlo con `nuevo-proyecto` (estructura estándar) y
registrar el intake como primer informe en su `reports/`. Si se descarta: una línea con el
motivo donde se decidió (TASKS.md o una nota).
