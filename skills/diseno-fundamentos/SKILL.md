---
name: diseno-fundamentos
description: Fundamentos operativos de diseño web — tipografía, color, layout/espaciado, interacción y anti-patrones «se nota que lo hizo una IA». Usar al diseñar o refinar cualquier interfaz web (landing, dashboard, app UI), al elegir fuentes, paleta o tema, cuando un diseño «se ve genérico/plano/soso», o al revisar UI generada por IA propia o de Codex. Complementa emil-design-eng (filosofía de craft) y dataviz (color para gráficos de datos).
---

# Fundamentos de diseño

> **Atribución:** adaptado de [pbakaus/impeccable](https://github.com/pbakaus/impeccable)
> (Apache-2.0, commit `630fc26`, 2026-07-10; © 2025 Paul Bakaus). Solo el contenido
> markdown, modificado; su tooling (detectores, live-mode, hooks, comandos) quedó fuera.
> Las reglas se conservan en inglés para no perder matiz. Licencia y cambios: `LICENSE` y
> `NOTICE.md` de esta carpeta.

## Primero: ¿qué registro?

Decide antes de tocar nada y carga la referencia del registro:

- **El diseño ES el producto** (landing, marketing, portfolio, campaña, contenido) →
  [reference/registro-marca.md](reference/registro-marca.md)
- **El diseño SIRVE al producto** (app UI, dashboard, admin, herramienta, tablas) →
  [reference/registro-producto.md](reference/registro-producto.md)

Elección por primera coincidencia: (1) pista de la tarea («landing» vs «dashboard»);
(2) superficie en foco; (3) naturaleza del proyecto.

## Referencias por tema (cargar solo la que toque)

| Tema | Cuándo | Referencia |
|---|---|---|
| Tipografía | Elegir/emparejar fuentes, jerarquía, escala, carga de webfonts | [reference/tipografia.md](reference/tipografia.md) |
| Color de UI | Paleta, estrategia de color, OKLCH, dark mode, contraste | [reference/color.md](reference/color.md) |
| Layout | Espaciado, ritmo, jerarquía visual, grids, densidad | [reference/layout.md](reference/layout.md) |
| Interacción | Estados, focus, formularios, modales, dropdowns, teclado | [reference/interaccion.md](reference/interaccion.md) |
| Buscar referencias | Antes de construir: dónde encontrar webs reales por tipo de pieza | [reference/fuentes-referencias.md](reference/fuentes-referencias.md) |

Para color de **gráficos de datos**, manda la skill `dataviz` (paleta validada por
script); esta skill cubre el color del resto de la interfaz.

## Reglas generales (aplican siempre)

### Color

- **Verify contrast.** Body text must hit ≥4.5:1 against its background; large text
  (≥18px or bold ≥14px) needs ≥3:1. Placeholder text needs the same 4.5:1. The most
  common failure: muted gray body text on a tinted near-white — light gray "for
  elegance" is the single biggest reason AI designs feel hard to read.
- Gray text on a colored background looks washed out. Use a darker shade of the
  background's own hue, or a transparency of the text color.

### Typography

- Cap body line length at 65–75ch.
- Don't pair fonts that are similar but not identical (two geometric sans-serifs).
  Pair on a contrast axis (serif + sans, geometric + humanist) or use one family in
  multiple weights.
- Hero / display heading ceiling: clamp() max ≤ 6rem (~96px). Above that the page is
  shouting, not designing.
- Display heading letter-spacing floor: ≥ -0.04em. Anything tighter and letters touch.
- Use `text-wrap: balance` on h1–h3; `text-wrap: pretty` on long prose.

### Layout

- Vary spacing for rhythm.
- Cards are the lazy answer. Use them only when they're truly the best affordance.
  Nested cards are always wrong.
- Flexbox for 1D, Grid for 2D. Don't default to Grid when `flex-wrap` would be simpler.
- Responsive grids without breakpoints: `repeat(auto-fit, minmax(280px, 1fr))`.
- Build a semantic z-index scale (dropdown → sticky → modal-backdrop → modal → toast →
  tooltip). Never arbitrary values like 999.

### Motion

- Motion is part of the build, not an afterthought.
- Don't animate CSS layout properties unless truly needed.
- Ease out with exponential curves (ease-out-quart / quint / expo). No bounce, no elastic.
- Reduced motion is not optional: every animation needs a
  `@media (prefers-reduced-motion: reduce)` alternative (crossfade or instant).
- Staggering items within one list is legitimate; the tell is the uniform reflex (one
  identical entrance applied to every section). But zero motion on the whole page is
  not the answer either.
- Reveal animations must enhance an already-visible default. Don't gate content
  visibility on a class-triggered transition (ships blank in headless renderers).
- Premium motion materials go beyond transform/opacity: blur, backdrop-filter,
  clip-path, mask, shadow/glow — when they materially improve the effect and stay smooth.

### Interaction

- Dropdowns with `position: absolute` inside `overflow: hidden|auto` get clipped. Use
  native `<dialog>` / popover API, `position: fixed`, or a portal.

## Proyectos nuevos (sin sistema previo)

- Use OKLCH.
- **The cream / sand / beige body bg is the saturated AI default.** Token names like
  `--paper`, `--cream`, `--sand`, `--linen` are tells in themselves. "Warmth" in the
  brand is carried by accent + typography + imagery, not by body bg.
- Tinted neutrals: add 0.005–0.015 chroma toward **the brand's own hue**, never
  default-warm or default-cool.
- Dark vs. light is never a default. Write one sentence of physical scene (who uses
  this, where, under what light, in what mood); add detail until it forces the answer.
- Pick a **color strategy** before picking colors:
  - **Restrained**: tinted neutrals + one accent ≤10%. Product default.
  - **Committed**: one saturated color carries 30–60% of the surface.
  - **Full palette**: 3–4 named roles, each deliberate.
  - **Drenched**: the surface IS the color. Brand heroes.

## Bans absolutos (match-and-refuse: si vas a escribirlo, reestructura)

- **Side-stripe borders** (`border-left/right` >1px como acento de color en cards,
  callouts o alerts). Full borders, tints de fondo, glifos — o nada.
- **Gradient text** (`background-clip: text` + gradiente). Un color sólido; énfasis
  por peso o tamaño.
- **Glassmorphism as default.** Raro y con propósito, o nada.
- **The hero-metric template** (número grande + label pequeño + stats + gradiente).
- **Identical card grids** (icono + título + texto, repetido sin fin).
- **Tiny uppercase tracked eyebrow above every section.** Un kicker deliberado es voz;
  un eyebrow en cada sección es gramática de IA.
- **Numbered section markers as scaffolding** (01/02/03 sobre cada sección). Solo si
  la sección ES una secuencia real.
- **Text that overflows its container.** Prueba los titulares en cada breakpoint.

## El test anti-slop

Si alguien puede mirar la interfaz y decir «esto lo hizo una IA» sin dudar, ha
fallado. Dos alturas:

- **Primer orden:** si el tema + paleta se adivinan solo por la categoría del
  producto, es el primer reflejo del training data. Rehaz la escena física y la
  estrategia de color.
- **Segundo orden:** si la familia estética se adivina por categoría + anti-referencia
  («fintech que no es navy-and-gold → terminal-dark»), es la trampa un nivel más
  abajo. Las lanes saturadas están en
  [reference/registro-marca.md](reference/registro-marca.md).

## Apéndice: tells por modelo (útil al revisar trabajo de Codex u otros)

- **Codex:** ghost-cards (border 1px + sombra ancha ≥16px juntas); over-round
  (radius ≥32px en cards; tope 12–16px); SVG «sketchy»/doodle como ilustración;
  fondos de rayas con `repeating-linear-gradient`; retículas decorativas de
  `linear-gradient` 1px; tracking de display más cerrado que -0.04em; copy
  meta-crítico (nombrar un cliché para «corregirlo»).
- **Gemini:** animar `<img>` en hover (incl. `group-hover:scale` de Tailwind sobre la
  imagen hija). Feedback de hover en fondo/borde/sombra de la card, nunca en la imagen.

## Verificación

- Contraste: computable — no lo estimes a ojo (el validador de `dataviz` sirve para
  pares texto/fondo puntuales).
- Revisa el resultado renderizado (captura o navegador), no solo el código: colisiones
  de etiquetas, overflow, jerarquía con el squint test.
