#!/usr/bin/env bash
# Construit une branche orpheline par dossier de cas/, avec le contenu du dossier à la racine.
# Se lance depuis main ; l'arbre de travail n'est jamais modifié, relancer remplace les branches.
set -euo pipefail
cd "$(dirname "$0")"

index=$(mktemp -u)
trap 'rm -f "$index"' EXIT

for dir in cas/*/; do
    name=$(basename "$dir")
    rm -f "$index"
    GIT_INDEX_FILE=$index git --work-tree="$dir" add -A -f .
    tree=$(GIT_INDEX_FILE=$index git write-tree)
    commit=$(git commit-tree "$tree" -m "test: Cas $name")
    git update-ref "refs/heads/$name" "$commit"
    echo "branche $name"
done

echo
echo "Pour publier :"
echo "  git remote add origin <url du dépôt GitHub public>"
echo "  git push origin main"
echo "  git push --force origin $(ls cas | tr '\n' ' ')"
