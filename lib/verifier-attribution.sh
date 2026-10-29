#!/usr/bin/env bash
# Règle du fork : aucun commit, titre ou description de PR ne mentionne un outil d'IA
# comme auteur, co-auteur ou générateur.
#
# Usage :
#   lib/verifier-attribution.sh fichier.txt          vérifie un texte (message de commit, PR)
#   lib/verifier-attribution.sh --commits REV...     vérifie messages et identités des commits
#                                                    désignés (arguments de git rev-list,
#                                                    par exemple A..B ou SHA --not --remotes)
#
# Les commits déjà présents dans le projet d'origine (refs/remotes/upstream/master) sont ignorés.
#
# Seules les attributions sont refusées : une simple mention d'un outil (« le conseil sur
# ChatGPT ») ou une personne qui s'appelle Claude ou Devin restent acceptées.
#
# Code de sortie : 0 si conforme, 1 si une attribution est trouvée, 2 si les commits
# n'ont pas pu être listés.

set -euo pipefail

# Noms d'outils d'IA, tels qu'ils apparaissent comme auteur ou co-auteur.
OUTIL='(github )?(claude( code)?|copilot|chatgpt|openai( codex)?|codex|gemini( code assist)?|codeium|windsurf|devin( ai)?|cursor( agent)?|aider|tabnine)'
# Domaines d'e-mail des éditeurs de ces outils.
DOMAINE='(anthropic\.com|openai\.com|cursor\.(com|sh)|devin\.ai|cognition\.ai|codeium\.com|windsurf\.com|aider\.chat|tabnine\.com)'

# Motifs refusés dans un message (insensibles à la casse).
TEXTE_INTERDIT="(co-authored-by:[[:space:]]*${OUTIL}([[:space:]][0-9.]+)?[[:space:]]*<)"
TEXTE_INTERDIT+="|(co-authored-by:.*@${DOMAINE})"
TEXTE_INTERDIT+="|(co-authored-by:[^<]*(\[bot\]|\b(ai|ia)\b))"
TEXTE_INTERDIT+="|(claude-session:)|(noreply@anthropic\.com)|(claude\.(ai/code|com/claude-code))"
TEXTE_INTERDIT+="|((generated|written|created|made) (with|by|using) \[?${OUTIL}\b)"
TEXTE_INTERDIT+="|((generated|written|created|made) (with|by|using) an? (ai|llm)\b)"
TEXTE_INTERDIT+="|((généré|écrit|rédigé|créé|produit)e?s? (avec|par|grâce à) \[?${OUTIL}\b)"
TEXTE_INTERDIT+="|((généré|écrit|rédigé|créé|produit)e?s? (avec|par|grâce à) (une? )?(ia|llm)\b)"

# Identités refusées, sur des lignes « nom <e-mail> » : nom exactement égal à un outil,
# e-mail d'un éditeur d'outil, compte bot d'un outil, ou suffixe « (aider) ».
IDENTITE_INTERDITE="(^${OUTIL}([[:space:]][0-9.]+)?[[:space:]]*<)|(@${DOMAINE}>)|(${OUTIL}[^<]*\[bot\])|(\(aider\))"

verifier_texte() {
  local source="$1" contenu="$2"
  local trouves
  trouves=$(printf '%s\n' "$contenu" | grep -inE "$TEXTE_INTERDIT" || true)
  if [ -n "$trouves" ]; then
    echo "✗ $source attribue le travail à un outil d'IA :"
    printf '%s\n' "$trouves" | sed 's/^/    /'
    return 1
  fi
}

if [ "${1:-}" = "--commits" ]; then
  shift
  [ "$#" -gt 0 ] || { echo "Commits à vérifier attendus, par exemple origin/master..HEAD" >&2; exit 2; }
  erreurs=0
  # Les commits du projet d'origine (récupérés lors d'une synchronisation) ne sont pas
  # concernés par la règle : on les exclut si la branche amont est connue localement.
  # L'exclusion est placée avant les arguments, pour qu'un --not de l'appelant ne l'inverse pas.
  exclure=()
  if git rev-parse -q --verify refs/remotes/upstream/master >/dev/null; then
    exclure=(^refs/remotes/upstream/master)
  fi
  # Un échec de rev-list (plage invalide, commit absent) ne doit pas passer pour « rien à vérifier ».
  if ! commits=$(git rev-list ${exclure[@]+"${exclure[@]}"} "$@"); then
    echo "✗ Impossible de lister les commits ($*) : vérification interrompue." >&2
    exit 2
  fi
  for sha in $commits; do
    court=$(git rev-parse --short "$sha")
    verifier_texte "Le commit $court" "$(git log -1 --format=%B "$sha")" || erreurs=1
    identites=$(git log -1 --format='%an <%ae>%n%cn <%ce>' "$sha")
    if printf '%s\n' "$identites" | grep -iqE "$IDENTITE_INTERDITE"; then
      echo "✗ Le commit $court a un auteur ou un committer d'IA :"
      printf '%s\n' "$identites" | sed 's/^/    /'
      erreurs=1
    fi
  done
  [ "$erreurs" -eq 0 ] && echo "✓ Aucune attribution à un outil d'IA dans $*."
  exit "$erreurs"
fi

fichier="${1:?fichier à vérifier attendu}"
# On s'arrête à la ligne de coupe de « git commit -v » : le diff qui suit ne fait pas
# partie du message. Les lignes de commentaire sont ignorées.
verifier_texte "Le message" "$(sed '/^# -\{24\} >8 -\{24\}$/,$d' "$fichier" | grep -v '^#' || true)"
