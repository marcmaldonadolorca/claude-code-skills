#!/usr/bin/env bash
# Biblioteca de skills de Claude Code — instala skills y agentes como symlinks.
#
# La biblioteca canónica vive en este directorio ({skills,agents}) y se
# versiona en Git. La instalación NUNCA copia: crea symlinks, de modo que un
# cambio en la biblioteca se propaga a todo lo instalado.
#
# Uso:
#   ./install.sh list                                  # catálogo disponible
#   ./install.sh status                                # qué hay instalado y dónde
#   ./install.sh install --global all                  # todo, para ~/.claude
#   ./install.sh install --global <nombre>...          # selección global
#   ./install.sh install --project <ruta> <nombre>...  # selección para un proyecto
#   ./install.sh uninstall --global|--project <ruta> all|<nombre>...
#
# Solo gestiona symlinks que apunten a esta biblioteca; no toca skills o
# agentes de otros orígenes que convivan en el mismo destino.

set -euo pipefail

LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

die() { echo "error: $*" >&2; exit 1; }

all_skills() { find "$LIB/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort; }
all_agents() { [ -d "$LIB/agents" ] || return 0; find "$LIB/agents" -mindepth 1 -maxdepth 1 -name '*.md' -printf '%f\n' | sed 's/\.md$//' | sort; }

# Devuelve la raíz .claude destino según --global o --project <ruta>.
# Deja el resto de argumentos (nombres) en NAMES.
parse_dest() {
  local mode="${1:-}"
  case "$mode" in
    --global)
      DEST="$HOME/.claude"
      shift
      ;;
    --project)
      [ $# -ge 2 ] || die "--project requiere una ruta"
      [ -d "$2" ] || die "no existe el directorio de proyecto: $2"
      DEST="$(cd "$2" && pwd)/.claude"
      shift 2
      ;;
    *)
      die "falta --global o --project <ruta>"
      ;;
  esac
  NAMES=("$@")
  [ ${#NAMES[@]} -ge 1 ] || die "indica nombres de skills/agentes, o 'all'"
  if [ "${NAMES[0]}" = "all" ]; then
    mapfile -t NAMES < <(all_skills; all_agents)
  fi
}

# Clasifica un nombre: imprime "skill <origen>" o "agent <origen>".
locate() {
  local name="$1"
  if [ -d "$LIB/skills/$name" ]; then
    echo "skill $LIB/skills/$name"
  elif [ -f "$LIB/agents/$name.md" ]; then
    echo "agent $LIB/agents/$name.md"
  else
    return 1
  fi
}

link_one() {
  local name="$1" kind src dst
  read -r kind src < <(locate "$name") || die "no existe en la biblioteca: $name (usa './install.sh list')"
  if [ "$kind" = skill ]; then
    dst="$DEST/skills/$name"
  else
    dst="$DEST/agents/$name.md"
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ] && { echo "  = $name (ya instalado)"; return; }
    die "$dst es un symlink a otro origen; resuélvelo a mano"
  fi
  [ -e "$dst" ] && die "$dst ya existe y no es un symlink de la biblioteca; no lo sobrescribo"
  ln -s "$src" "$dst"
  echo "  + $name ($kind) -> $dst"
}

unlink_one() {
  local name="$1" dst
  for dst in "$DEST/skills/$name" "$DEST/agents/$name.md"; do
    if [ -L "$dst" ] && [[ "$(readlink -f "$dst")" == "$LIB"/* ]]; then
      rm "$dst"
      echo "  - $name ($dst)"
      return
    fi
  done
  echo "  ? $name no estaba instalado desde esta biblioteca en $DEST"
}

status_of() {
  local root="$1" f
  [ -d "$root" ] || return 0
  find "$root/skills" "$root/agents" -maxdepth 1 -type l 2>/dev/null | sort | while read -r f; do
    if [[ "$(readlink -f "$f" 2>/dev/null || true)" == "$LIB"/* ]]; then
      [ -e "$f" ] && echo "  ok    $f" || echo "  ROTO  $f"
    fi
  done
}

cmd="${1:-help}"; shift || true
case "$cmd" in
  list)
    echo "Skills:";  all_skills | sed 's/^/  /'
    echo "Agentes:"; all_agents | sed 's/^/  /'
    ;;
  status)
    echo "Global (~/.claude):"
    status_of "$HOME/.claude"
    if [ $# -ge 1 ]; then
      echo "Proyecto ($1/.claude):"
      status_of "$1/.claude"
    fi
    ;;
  install)
    parse_dest "$@"
    echo "Instalando en $DEST:"
    for n in "${NAMES[@]}"; do link_one "$n"; done
    ;;
  uninstall)
    parse_dest "$@"
    echo "Desinstalando de $DEST:"
    for n in "${NAMES[@]}"; do unlink_one "$n"; done
    ;;
  *)
    sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'
    ;;
esac
