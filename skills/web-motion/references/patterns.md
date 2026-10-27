# web-motion — árbol de decisión y recetas

Stack asumido: Next.js App Router + React/TS + Tailwind. Libs: `lenis`, `gsap`
(+ScrollTrigger), `motion` (Motion / Framer Motion, import desde `motion/react`).
Elige la mínima que resuelva el spec. La barra de calidad (easing, duración, spring) es la
de `review-animations`/`STANDARDS.md`: no la repitas, aplícala.

## 1. Árbol de decisión (fila del motion spec → primitiva)

| Lo que dice el spec | Primitiva | Lib |
|---|---|---|
| Aparece al entrar en viewport (reveal, stagger) | `whileInView` / IntersectionObserver | Motion (o CSS + IO) |
| Progreso ligado al scroll (parallax, barra, escala continua) | `useScroll` + `useTransform` **o** ScrollTrigger `scrub` | Motion o GSAP |
| Fijar una sección y animar por pasos mientras se scrollea | ScrollTrigger `pin` | GSAP |
| Timeline compleja, secuencia orquestada, pin + scrub juntos | ScrollTrigger + `gsap.timeline` | GSAP |
| Transición entre estados/rutas con elemento compartido | View Transitions API | Nativo |
| Un SVG que "se dibuja" | `stroke-dashoffset` / `pathLength` | CSS o Motion |
| Smooth-scroll de base (inercia) bajo todo lo anterior | Lenis | Lenis |

**GSAP vs Motion**: reveals puntuales, micro-interacción y gestos declarativos → Motion
(`whileInView`, springs interrumpibles). Coreografía scroll pesada — pin, scrub, timelines
largas, muchos triggers sincronizados → GSAP ScrollTrigger. No mezcles dos motores para el
mismo efecto.

**Piezas ya hechas (React Bits)**: si la fila del spec es un efecto de catálogo (texto animado,
fondo generativo, hover elaborado), mira antes si `reactbits.dev` la resuelve — se **copia** el
componente a `src/components/`, sin dependencia del catálogo, sin su CLI ni su MCP. Elige la
variante **TS-TW** (TypeScript + Tailwind: no arrastra fichero `.css`). Tres avisos medidos:
(1) su registro fija `three@^0.180.0`, así que instalar por CLI **te baja tu three** — copia a
mano y pon tu versión; (2) 36 componentes traen GSAP y 47 traen `ogl`, o sea que copiar una
pieza puede gastarte la elección de librería que esta skill obliga a minimizar; (3) si la pieza
usa GSAP dentro de React, pásala por `gsap-react` (`useGSAP()`/`gsap.context()`) o hereda su
fuga al desmontar. El código copiado es tuyo: se le aplica la misma barra que al escrito a mano.

## 2. Base: Lenis (smooth-scroll) + reduced-motion

```tsx
// app/providers/SmoothScroll.tsx  ("use client")
"use client";
import { ReactLenis } from "lenis/react";
import { useReducedMotion } from "motion/react";

export function SmoothScroll({ children }: { children: React.ReactNode }) {
  const reduce = useReducedMotion();
  if (reduce) return <>{children}</>;               // nativo, sin inercia
  return (
    <ReactLenis root options={{ lerp: 0.1, smoothWheel: true }}>
      {children}
    </ReactLenis>
  );
}
```

Si usas GSAP ScrollTrigger a la vez, sincroniza el update:
```ts
lenis.on("scroll", ScrollTrigger.update);
gsap.ticker.add((t) => lenis.raf(t * 1000));
gsap.ticker.lagSmoothing(0);
```

## 3. Reveal al entrar (triggered)

```tsx
"use client";
import { motion } from "motion/react";
const reveal = {
  hidden: { opacity: 0, y: 24 },
  show: { opacity: 1, y: 0, transition: { duration: 0.5, ease: [0.22, 1, 0.36, 1] } },
};
export function Reveal({ children }: { children: React.ReactNode }) {
  return (
    <motion.div variants={reveal} initial="hidden"
      whileInView="show" viewport={{ once: true, margin: "-15% 0px" }}>
      {children}
    </motion.div>
  );
}
```
Stagger: pon `transition:{ staggerChildren: 0.06 }` en el contenedor y `variants` en los
hijos. Sin dependencias JS: `@media (prefers-reduced-motion: no-preference)` + IO que añade
una clase, es más ligero para reveals simples.

## 4. Scroll-linked / parallax (progreso)

```tsx
"use client";
import { useRef } from "react";
import { motion, useScroll, useTransform } from "motion/react";
export function ParallaxHero() {
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start start", "end start"] });
  const y = useTransform(scrollYProgress, [0, 1], ["0%", "30%"]);
  return (
    <div ref={ref} className="relative h-[120vh] overflow-hidden">
      <motion.img src="/hero.webp" style={{ y }} className="h-full w-full object-cover" />
    </div>
  );
}
```
GSAP equivalente para coreografía pesada:
```ts
gsap.to(".layer", { yPercent: 30, ease: "none",
  scrollTrigger: { trigger: ".hero", start: "top top", end: "bottom top", scrub: true } });
```

## 5. Pin / sticky sequence (GSAP)

```ts
const tl = gsap.timeline({
  scrollTrigger: { trigger: ".panel", start: "top top", end: "+=200%", scrub: 1, pin: true },
});
tl.from(".step-1", { opacity: 0, y: 40 })
  .from(".step-2", { opacity: 0, y: 40 }, "+=0.3");
```
Limpieza en React: crea todo dentro de `gsap.context(() => {...}, ref)` y devuelve
`() => ctx.revert()` en el `useEffect`.

## 6. View Transitions (entre estados/rutas)

```ts
// Cambio de estado en el cliente
if (document.startViewTransition) document.startViewTransition(() => applyChange());
else applyChange();
```
Elemento compartido: `style={{ viewTransitionName: "hero" }}` en el antes y el después.
Next.js App Router tiene soporte experimental (`experimental.viewTransition`); si no, la API
del navegador + CSS `@view-transition { navigation: auto; }` cubre lo básico. Siempre con
guard: no todos los navegadores la traen.

## 7. SVG line draw

```tsx
import { motion } from "motion/react";
<motion.path d="M2 20 C 40 2, 80 38, 118 20" fill="none" stroke="currentColor"
  initial={{ pathLength: 0 }} whileInView={{ pathLength: 1 }}
  viewport={{ once: true }} transition={{ duration: 1.2, ease: "easeInOut" }} />
```
CSS puro: `stroke-dasharray: L; stroke-dashoffset: L;` y animar `stroke-dashoffset` a 0.

## 8. Reduced-motion (envoltura obligatoria)

```tsx
const reduce = useReducedMotion();           // motion/react
const variants = reduce
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }   // solo fade, sin desplazamiento
  : reveal;
```
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: .01ms !important;
    transition-duration: .01ms !important; scroll-behavior: auto !important; }
}
```
Regla: reduced-motion **atenúa** (quita desplazamiento/parallax, mantiene opacidad/color y
el contenido visible), no deja huecos vacíos ni rompe el layout.

## 9. Checklist antes de pasar a `review-animations`

- [ ] Solo se anima `transform`/`opacity` (nada de width/height/top/left).
- [ ] `prefers-reduced-motion` cubierto y probado (contenido legible y quieto).
- [ ] Lenis off/reducido en reduced-motion; sin scroll-jacking.
- [ ] Cada animación responde a una fila del motion spec (ninguna "porque queda cool").
- [ ] Limpieza de ScrollTrigger/context al desmontar (sin fugas ni triggers zombis).
- [ ] Si se copió una pieza de catálogo: revisada como código propio (limpieza, reduced-motion,
      solo `transform`/`opacity`) y sin haber tocado las versiones de librería del proyecto.
