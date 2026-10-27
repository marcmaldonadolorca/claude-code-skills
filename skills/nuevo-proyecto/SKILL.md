---
name: nuevo-proyecto
description: Crear o normalizar un proyecto con la estructura estándar (PROJECT_STATE, TASKS, DECISIONS, docs/, reports/) y COLOCARLO en el registro de PROJECTS.md (cartera con programa, relaciones, inventario).
---

# Nuevo proyecto

Convención: **un proyecto = un repo** con documentación fuente de verdad propia, y un
índice del workspace (`PROJECTS.md`) que lo enruta.

## Inputs

- Nombre, propósito en una frase y categoría → carpeta destino (p. ej. `active/`, `study/`,
  `archive/` dentro del workspace).
- Lenguaje/runtime previsto y dónde vivirá el remoto (GitHub, Gitea propio…).
- Si se normaliza un repo **existente o externo**: primero el análisis de `repo-intake`;
  esta skill solo aplica la estructura después.
- **Antes de crear nada:** buscar el nombre y sus variantes en el índice, decisiones e
  informes. ¿Es una competición, estrategia, canal o herramienta más de un programa que ya
  existe? Entonces se registra como frente de ese programa, **no** como proyecto aparte.

## Pasos

1. Crea el directorio y `git init` (rama `main`).
2. Estructura mínima:
   - `README.md` — qué es, cómo instalar, cómo validar (test/build/lint).
   - `PROJECT_STATE.md` — fase actual, última acción, próxima acción, fecha.
   - `TASKS.md` — casillas por fases; casilla marcada = evidencia.
   - `DECISIONS.md` — decisiones irreversibles/arquitectónicas con formato
     fecha/estado/contexto/decisión/consecuencias/reversión.
   - `docs/`, `reports/`.
3. `.gitignore` según runtime (`.venv`, `node_modules`, cachés, `.env`); `.env.example` con
   nombres lógicos y valores ficticios si habrá secretos.
4. Manifiesto reproducible desde el inicio (`pyproject.toml`/`requirements.txt`,
   `package.json`…): el entorno se recrea desde el manifiesto, nunca se copia.
5. Recolecta skills de la biblioteca si el proyecto las necesita en local:
   `./install.sh install --project <ruta> <skill>…` (las instaladas globalmente en
   `~/.claude/skills` ya están disponibles sin esto).
6. Si el proyecto usará datos compartidos (una base histórica, un disco de datos de otro
   proyecto), documenta la dependencia en su `README.md` y respeta el modo solo-lectura.
7. **Colocarlo en el registro (obligatorio):** en `PROJECTS.md`, o una fila en la «Cartera»
   con estado, ticket vigente, fuente y **programa** (si hay hueco en «ahora»; si no, entra
   como `siguiente` o `aparcado`), o, si no es un frente con tickets, una fila en el
   «Inventario». Si depende de otro frente o usa un recurso compartido (GPU, disco, cuentas…),
   una fila en «Relaciones» **con su evidencia**. Un programa nuevo solo si ninguno encaja y
   hay ≥ 2 frentes que lo justifiquen (máx. 8).
8. Si el workspace tiene un check de coherencia del registro (programa ausente, relación que
   apunta a algo que no existe, carpeta sin registrar), cerrar con él en verde.

## Reglas

- Sin secretos en Git desde el commit cero.
- No fusionar con repos existentes por parecido de nombre (lección real de una migración:
  un repo contenía varios proyectos independientes).
- Commit inicial solo con autorización del usuario, como todos los commits.

## Documentar

El inventario del workspace es `PROJECTS.md` (paso 7); si toca infraestructura, regístralo
en su repo con `documentar-cambio`. Si el proyecto necesita un `CLAUDE.md` propio, decide qué
entra en él con `project-memory` (corto: reglas que toda sesión necesita; el resto, a `docs/`).
