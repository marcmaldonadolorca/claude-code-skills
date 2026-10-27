---
name: web-motion
description: Construye e integra motion web scroll-driven a partir de una referencia que aportas en el momento (URL, vídeo, capturas o descripción). Interpreta cualquier referencia → motion spec → ingeniería; no lleva referencias fijas dentro. Cubre animaciones de scroll, scroll reveals, parallax, pinning/sticky, scroll-linked, transiciones de página/View Transitions y dibujo de SVG en landings o sites React/Next. Es el "constructor" de la tríada; para nombrar un efecto usa animation-vocabulary y para revisar el resultado usa review-animations. Complementa diseno-fundamentos y emil-design-eng (dirección/craft) y web-proyecto-nextjs/web-landing-cliente (stack y entrega). Usar al construir o refinar el motion de una web, o cuando pidan "reproduce/adapta el motion de esta referencia", "añade animaciones de scroll", "hero con parallax" o "transición entre secciones".
---

# Web Motion — de referencia a scroll-site

El **constructor** de la tríada de motion (nombrar → construir → revisar). Traduce una
referencia que aportas *en tiempo de uso* a motion funcional en el stack React/Next.
No trae referencias fijas: interpreta las que te den. La **barra de calidad** no se
re-explica aquí — se aplica desde `review-animations` (y su `STANDARDS.md`); para
**nombrar** un efecto que se describe en vago, `animation-vocabulary`. Ambas son de
[emilkowalski/skills](https://github.com/emilkowalski/skills) (MIT) y se instalan aparte. Recetas de código y árbol de
decisión: [`references/patterns.md`](references/patterns.md).

## Inputs

- **Referencia(s) de motion del usuario** (URL, vídeo, capturas o descripción). **Si no
  hay ninguna referencia ni dirección, parar y pedirla** — no inventar dirección visual
  con efectos genéricos (regla: referencias reales antes de construir).
- **Proyecto y stack destino** (por defecto Next.js App Router + React/TS + Tailwind, ver
  `web-proyecto-nextjs`).
- **Tipo de asset disponible**: CSS/SVG/DOM vs vídeo o generativo. El vídeo/generativo es
  frontera con el pipeline de assets (Remotion/otros): esta skill NO genera assets, los
  integra.

## Reglas

- **Sin referencia no se construye.** Nada de dirección visual inventada.
- Todo lo que animes cumple la barra de `review-animations`; **auto-revisar con
  `review-animations` antes de dar por bueno** (no reimplementar aquí sus tablas).
- **Accesibilidad y rendimiento, no negociable**: `prefers-reduced-motion` con fallback
  *estático y legible* (no un hueco vacío); animar solo `transform`/`opacity` (GPU); nada
  de scroll-jacking que pelee con el usuario; Lenis reducido/desactivado en reduced-motion.
- **Librerías fijadas, sin terceros de pago ni MCP**: Lenis (smooth-scroll), GSAP +
  ScrollTrigger (gratis desde que Webflow lo liberó), Motion/Framer Motion (`motion/react`).
  Elegir la mínima que resuelva el spec, no las tres por defecto.
- **Catálogo de piezas, no dirección**: una fila del spec puede materializarse copiando un
  componente de **React Bits** (`reactbits.dev`; revisa su licencia antes de copiar). Se **copia el código** al proyecto — sin dependencia del catálogo,
  sin su CLI (`shadcn`/`jsrepo`) y sin su MCP, que es lo que la regla de arriba excluye.
  Solo **después** de tener referencia y spec: el catálogo resuelve el «cómo», nunca el «qué».
  Abrirlo «a ver qué queda bien» es dirección visual inventada, y sigue prohibido.
  Si una pieza choca con los bans de `diseno-fundamentos`, mandan los bans.

## Pasos

1. **Leer la referencia → *motion spec* (antes de tocar código).** Por sección, extraer:
   qué se mueve y con qué *trigger*; **scroll-linked** (progreso) vs **triggered**
   (enter/exit); timing/easing/stagger; *feel* (snappy/floaty/cinematográfico); tipo de
   asset. Nombrar los efectos con `animation-vocabulary`. **Entregable: tabla motion spec**
   (una fila por elemento animado). Este es el paso que más se salta una sesión sin la skill.
2. **Mapear cada fila del spec a una primitiva.** Árbol de decisión en
   `references/patterns.md`: Lenis de base; scroll-linked por progreso → GSAP ScrollTrigger
   (`scrub`) o Framer `useScroll`; reveal al entrar → `whileInView`/IntersectionObserver;
   pin/secuencia → ScrollTrigger `pin`; parallax → transform por progreso; navegación entre
   estados/rutas → View Transitions API; dibujar SVG → `stroke-dashoffset`/`pathLength`.
3. **Construir sección a sección (dry-run primero).** Una sección, verla, luego escalar.
   Recetas en `references/patterns.md`. Prohibido el "fade-up en todo".
4. **Blindar a11y + rendimiento.** Envolver en `prefers-reduced-motion`; verificar que solo
   se anima `transform`/`opacity`; Lenis off/reducido en reduced-motion; sin layout thrash.
5. **Auto-revisar con `review-animations`** y corregir hallazgos antes de entregar.

## Checks / evidencia

- La sección se anima como dice el spec, a ~60fps sin jank, y **con reduced-motion activo el
  contenido queda legible y quieto** (no vacío ni roto).
- `review-animations` devuelve *Approve* (o solo hallazgos menores justificados).
- Verificación visual headless (geckodriver + Firefox): **ojo, `matchMedia` `hover`/`fine`
  miente en headless** — comprobar hover/pointer también en un navegador real.

## Reversión

- Es código en un proyecto: revertir con el git del proyecto (**sin commit sin
  autorización del usuario**). Si se descarta, quitar las libs añadidas del
  `package.json`.

## Documentar

- Skill nueva en la biblioteca → casilla en `TASKS.md` de la biblioteca + fila en el
  catálogo del `README.md`. Trabajo dentro de un proyecto → su `PROJECT_STATE.md`/`TASKS.md`.
  Aprendizaje reutilizable (una técnica de motion que funcionó) → nota nueva en tu
  sistema de notas.
