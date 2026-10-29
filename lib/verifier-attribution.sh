#!/usr/bin/env bash
# Règle du fork : aucun commit, titre ou description de PR ne mentionne un outil d'IA
# comme auteur, co-auteur ou générateur.
#
# Usage :
#   lib/verifier-attribution.sh fichier.txt        vérifie un texte (message de commit, PR)
#   lib/verifier-attribution.sh --commits A..B     vérifie messages et identités d'une plage
#
# Les commits déjà présents dans le projet d'origine (refs/remotes/upstream/master) sont ignorés.
#
# Code de sortie : 0 si conforme, 1 sinon (avec la liste des lignes en cause).

set -euo pipefail

# Motifs refusés dans un message (insensibles à la casse).
TEXTE_INTERDIT='(co-authored-by:.*(claude|anthropic|copilot|cursor|chatgpt|openai|gemini|codeium|windsurf|devin|aider|tabnine|\bai\b|\[bot\]))|(claude-session:)|(generated (with|by) )|(\bclaude( code)?\b)|(anthropic)|(\bcopilot\b)|(\bcursor (ai|agent|ide)\b)|(\bchatgpt\b)|(noreply@anthropic\.com)|(agent (ia|ai)\b)|(\bai agent\b)'

# Motifs refusés dans le nom ou l'e-mail d'auteur et de committer.
IDENTITE_INTERDITE='(claude|anthropic|copilot|cursor|chatgpt|openai|gemini|codeium|devin|aider)'

verifier_texte() {
  local source="$1" contenu="$2"
  local trouves
  trouves=$(printf '%s\n' "$contenu" | grep -inE "$TEXTE_INTERDIT" || true)
  if [ -n "$trouves" ]; then
    echo "✗ $source mentionne un outil d'IA :"
    printf '%s\n' "$trouves" | sed 's/^/    /'
    return 1
  fi
}

if [ "${1:-}" = "--commits" ]; then
  plage="${2:?plage de commits attendue, par exemple origin/master..HEAD}"
  erreurs=0
  # Les commits du projet d'origine (récupérés lors d'une synchronisation) ne sont pas
  # concernés par la règle : on les exclut si la branche amont est connue localement.
  exclure=()
  if git rev-parse -q --verify refs/remotes/upstream/master >/dev/null; then
    exclure=(--not refs/remotes/upstream/master)
  fi
  for sha in $(git rev-list "$plage" "${exclure[@]}"); do
    court=$(git rev-parse --short "$sha")
    verifier_texte "Le commit $court" "$(git log -1 --format=%B "$sha")" || erreurs=1
    identites=$(git log -1 --format='%an <%ae>%n%cn <%ce>' "$sha")
    if printf '%s\n' "$identites" | grep -iqE "$IDENTITE_INTERDITE"; then
      echo "✗ Le commit $court a un auteur ou un committer d'IA :"
      printf '%s\n' "$identites" | sed 's/^/    /'
      erreurs=1
    fi
  done
  [ "$erreurs" -eq 0 ] && echo "✓ Aucune attribution à un outil d'IA dans $plage."
  exit "$erreurs"
fi

fichier="${1:?fichier à vérifier attendu}"
verifier_texte "Le message" "$(grep -v '^#' "$fichier")"
