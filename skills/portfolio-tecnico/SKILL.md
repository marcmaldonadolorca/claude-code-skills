---
name: portfolio-tecnico
description: Convertir proyectos propios en portfolio presentable — repos limpios, README profesional, GitHub, coherencia CV/LinkedIn. Para candidaturas o publicar.
---

# Portfolio técnico

Un reclutador técnico dedica ~2 minutos por repo: el portfolio se optimiza para esa
lectura. Mejor **3 repos excelentes que 15 mediocres** — lo demás, privado o archivado.

## Inputs

- Objetivo (qué tipo de puesto/cliente) y qué proyectos son candidatos. El objetivo decide qué se destaca: para ML enseñar evaluación rigurosa; para web, producto vivo y Lighthouse verde.

## Limpieza de repo (antes de hacerlo público)

1. **Seguridad primero**: historial incluido — `git log -p | grep -aiE 'api[_-]?key|secret|password|token'` (y revisar `.env*` viejos). Un secreto en el historial = rotar el secreto y reescribir historial o **recrear el repo limpio** (más simple y honesto). Datos personales o de terceros (datasets con personas, credenciales de cliente): fuera.
2. Basura fuera: `node_modules`/`.venv`/checkpoints/outputs en `.gitignore`; ramas muertas y archivos huérfanos eliminados; licencia elegida (MIT por defecto si no hay motivo).
3. Reproducible: manifiesto fijado; **instrucciones de instalación probadas en limpio** (el error nº 1 de los repos académicos: "funciona en mi máquina de 2024").
4. Proyectos académicos (máster, tesis): quitar el tono de entregable ("Práctica 3 — Asignatura X" → título por lo que hace); si usa datos no redistribuibles, incluir muestra sintética + instrucciones para obtener los reales; los datos fuente nunca van a Git.

## README profesional (estructura)

1. **Qué es y para quién**, en 2 frases + captura/GIF/demo si tiene cara visible (para ML: gráfica de resultados).
2. **Resultados/highlights**: números concretos (métrica vs baseline, rendimiento, cobertura) — es lo que diferencia "hice un modelo" de ingeniería.
3. Instalación y uso mínimo copy-paste (probados).
4. Arquitectura/decisiones en 5-10 líneas (por qué así — enlaza DECISIONS.md si existe).
5. Limitaciones y siguientes pasos (la honestidad técnica puntúa alto).
Sin badges vacíos ni secciones plantilla sin contenido.

## Perfil GitHub / coherencia CV

- Pinned: los 3-6 repos que sostienen el objetivo; README de perfil corto (quién eres, en qué trabajas, los 3 proyectos). Archivar (no borrar) lo que no representa el nivel actual.
- CV/LinkedIn: cada proyecto destacado con el patrón `qué + tecnología + resultado medible`; los enlaces del CV deben llevar EXACTAMENTE a los repos pulidos (se comprueba clic a clic).
- La actividad reciente importa más que el gráfico verde perfecto: mejor commits reales en los repos destacados que contribuciones decorativas.

## Pasos

1. Inventario de candidatos (usar `repo-intake` para los olvidados) y selección con el objetivo delante; 2. limpieza + README por repo (empezando por el mejor); 3. instalación probada en entorno limpio; 4. perfil y enlaces; 5. revisión final leyéndolo como el reclutador: 2 minutos por repo, ¿qué queda?

## Checks / evidencia

- Grep de secretos limpio (historial incluido); instalación reproducida en limpio; cada repo público responde en 30 s "qué es, qué demuestra, cómo lo pruebo".

## Documentar

Qué repos se publicaron y con qué alcance → nota en tu sistema de notas; si se reescribió
historial o se recreó un repo, `DECISIONS.md` del proyecto (es irreversible).
