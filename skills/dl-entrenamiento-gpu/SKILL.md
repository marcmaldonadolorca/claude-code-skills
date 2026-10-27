---
name: dl-entrenamiento-gpu
description: Entrenar, fine-tuning (LoRA/PEFT) o evaluar modelos PyTorch/HF en una GPU local de 16 GB (ROCm o CUDA), reproducible — contenedor, seeds, tracking, validación honesta.
---

# Entrenamiento / fine-tuning en GPU local

Disciplina de ML para una GPU de consumo. Hardware de referencia: GPU AMD de **16 GB VRAM**
con ROCm **solo en contenedor** (imágenes `rocm/pytorch`), nunca en el host. La ejecución va
siempre acotada: contenedor sin privilegios, timeout, log a disco y GPU verificada dentro del
contenedor antes de empezar.

## Inputs

- Objetivo medible (métrica y baseline a batir), dataset (ruta, licencia, ¿cabe en disco?, ¿es sensible?) y presupuesto de tiempo/VRAM aproximado.
- Sin métrica ni baseline definidos, parar: "entrenar a ver qué sale" quema GPU sin conclusión.

## Reglas

- **Datasets y checkpoints fuera de Git** (`.gitignore` desde el inicio); en Git van el código, la config y los resultados agregados. Datos sensibles o compartidos con otros proyectos: solo lectura.
- PyTorch para ROCm se instala desde el índice oficial de PyTorch fijando versión (`--index-url https://download.pytorch.org/whl/rocm*`); dentro del contenedor la GPU aparece como `cuda` (`torch.cuda.is_available()` — es lo esperado en ROCm, no un error).
- Un experimento = una config versionada (YAML/args) + un seed fijado (`torch`, `numpy`, `random`) + versiones registradas. Si no se puede repetir, no es un resultado: es una anécdota.
- Un job pesado de GPU a la vez: si un servidor de inferencia (p. ej. Ollama) tiene un modelo cargado, está ocupando VRAM.

## Realidades de los 16 GB (antes de pelearse con OOM)

- Fine-tuning completo de modelos >3B no cabe; usar **LoRA/PEFT + cuantización 4-bit**, gradient checkpointing y `accumulation_steps` en lugar de batch grande.
- Precisión mixta: preferir **bf16** si el modelo lo soporta (fp16 en RDNA2 da overflow con más facilidad).

## Pasos

1. **Smoke primero**: 50-100 steps con subset mínimo — comprueba que la loss baja, la VRAM aguanta y el checkpoint se escribe, antes de lanzar horas de entrenamiento.
2. Baseline barato antes del modelo caro (regresión logística, modelo pequeño, zero-shot del modelo base): si el caro no lo bate con claridad, la conclusión también vale.
3. Entrenamiento real acotado (timeout, log a disco, checkpoints periódicos + guardar SIEMPRE el último para reanudar).
4. **Tracking**: mínimo, un CSV/JSONL por run (config, métricas por época, duración, VRAM pico) en `reports/` del proyecto; MLflow solo cuando haya volumen de experimentos que lo justifique (servicio nuevo → decisión registrada).
5. Evaluación honesta: split de test intocado durante el desarrollo, métrica pactada, comparación contra el baseline del paso 2, y 2-3 ejemplos cualitativos (aciertos y fallos).

## Checks / evidencia

- El run se puede reproducir desde config+seed+manifiesto; el resultado incluye baseline, no solo la métrica final; el log confirma uso real de GPU.

## Reversión

- Los checkpoints/datasets generados se borran sin pérdida (el código y la config los regeneran); nada de esto toca datos canónicos.

## Documentar

Resultados con valor → `reports/` del proyecto (tabla de runs) y aprendizajes duraderos a tus
notas. Modelos que pasen a servirse → inventario de servicios.
