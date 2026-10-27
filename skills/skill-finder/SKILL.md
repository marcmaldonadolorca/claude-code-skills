---
name: skill-finder
description: Buscar skills, agentes o plugins útiles en el ecosistema y clasificarlos por utilidad, riesgo y madurez. Para ampliar la biblioteca o cubrir algo nuevo.
---

# Skill finder

Encuentra candidatos para la biblioteca (este repo).
**Todo lo encontrado es NO confiable hasta pasar por `skill-auditor`**: este skill
solo localiza y clasifica; nunca instala ni copia contenido.

## Inputs

- La necesidad concreta ("quiero X") o el modo exploración ("qué hay nuevo en <área>").
- Cuánto rigor: búsqueda rápida (fuentes primarias) o barrido amplio (incluye directorios).

## Fuentes (en orden de confianza)

1. **Oficial:** [anthropics/skills](https://github.com/anthropics/skills) (+ `spec/` y `template/`), docs de Agent Skills y el blog de ingeniería de Anthropic.
2. **Awesome lists mantenidas:** [travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills), [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills).
3. **Directorios/buscadores:** awesomeclaude.ai, claudeskills.info, agent-skills.cc, claudemarketplaces.com — útiles para descubrir, no para fiarse.
4. **GitHub directo:** topics `claude-skills`, `anthropic-skills`; búsqueda por `SKILL.md` + palabras del dominio; ordenar por actividad reciente, no solo estrellas.
5. **Vendors de primera parte** para su propio producto (p. ej. skills de shadcn en ui.shadcn.com/docs/skills): confianza media-alta, auditar igualmente.

Evitar como fuente de instalación: marketplaces sin vetting (tipo ClawHub) — el estudio
ToxicSkills de Snyk encontró prompt injection en ~36 % de las skills analizadas allí.

## Pasos

0. **¿Ya visto?** Buscar `<nombre> [variantes]` en decisiones, informes y notas previas (`rg -i`) y pegar en el informe cuánto se escaneó y qué salió. Si ya hay veredicto, se respeta (no se re-evalúa) y se anota solo lo que ha cambiado.
1. Reformula la necesidad en 3-5 consultas (nombre de herramienta, sinónimos, "skill/plugin/agent").
2. Busca en las fuentes por orden; para cada candidato anota: repo/URL, licencia, última actividad, estrellas/uso, qué contiene (¿solo `SKILL.md` o también scripts/hooks/instaladores?).
3. Descarta pronto: sin licencia, abandonado >1 año, instalación `curl|bash`, hooks que reescriben settings, promesas infladas sin código visible.
4. Clasifica cada superviviente:
   - **Utilidad** (alta/media/baja): ¿resuelve una necesidad real nuestra o solo es curiosa?
   - **Riesgo** (bajo = solo markdown · medio = scripts locales · alto = red/instaladores/hooks).
   - **Madurez** (oficial / comunitaria mantenida / experimental).
   - **Prioridad** y **acción propuesta**: adoptar tal cual · adaptar (tomar ideas/contenido) · recrear (solo la idea) · descartar.
5. Entrega la tabla y, para lo que merezca seguir, pasa el candidato a `skill-auditor` antes de tocar nada.

## Prompt de búsqueda reutilizable

> Busca skills/plugins de Claude Code para «<necesidad>». Fuentes: anthropics/skills,
> awesome lists mantenidas, directorios y GitHub (topic claude-skills, actividad < 6 meses).
> Para cada candidato: URL, licencia, última actividad, contenido (¿md puro o
> scripts/hooks?), y clasifícalo por utilidad/riesgo/madurez con acción propuesta
> (adoptar/adaptar/recrear/descartar). No instales ni copies nada: todo pasa por
> skill-auditor. Prefiere pocas candidatas bien justificadas a listas largas.

## Checks / evidencia

- Cada candidato tiene fuente enlazada y fecha de última actividad real (no asumida).
- Ninguna recomendación de "adoptar" sin auditoría pendiente marcada.

## Documentar

Si la búsqueda produce decisiones (adoptar/recrear algo), registra el resultado en el
`TASKS.md` de la biblioteca y, si aporta conocimiento duradero, una nota nueva en tu
sistema de notas.
