#!/bin/sh
# Resolves the student's current exercise and prints where its statement lives.
# Usage: exercise.sh [NN]
# Without NN: the exercise recorded by /ex (git config workshop.exercise),
# else the highest exNN-start tag merged into HEAD.
# Always exits 0, since a failing dynamic context command aborts the whole skill.

root=$(cd "$(dirname "$0")/.." && pwd)
repo=https://github.com/sebastiaoteixeira/workshop-claude/blob/main
tag=$(git for-each-ref --merged HEAD --sort=-refname --count=1 \
  --format='%(refname:lstrip=2)' 'refs/tags/ex[0-9][0-9]-start' 2>/dev/null)
latest=${tag#ex}

nn=${1:-$(git config --get workshop.exercise 2>/dev/null)}
nn=${nn:-${latest%-start}}

case $nn in
  [0-9]) nn=0$nn ;;
  [0-9][0-9]) ;;
  *) echo 'exercise: unknown'; exit 0 ;;
esac

for readme in "$root"/exercises/"$nn"-*/README.md; do
  [ -f "$readme" ] || { echo "exercise: $nn (no statement)"; exit 0; }
  slug=$(basename "$(dirname "$readme")")
  printf 'exercise: %s\nslug: %s\nreadme: %s\nlink: %s\n' \
    "$nn" "$slug" "$readme" "$repo/exercises/$slug/README.md"
done
