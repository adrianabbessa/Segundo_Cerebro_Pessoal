#!/usr/bin/env bash
# inicializar.sh — substitui placeholders e renomeia pasta do agente.
# Roda UMA vez após clone do template-second-brain-pessoal.
# Aborta se .cerebro-inicializado já existir.

set -euo pipefail

EMPRESA=""
EMPRESA_SLUG=""
EMPRESA_DOMINIO=""
FUNDADOR=""
FUNDADOR_SLUG=""
FUNDADOR_EMAIL=""
FUNDADOR_CARGO=""
FUNDADOR_ESCOPO=""
TIMEZONE=""
IDIOMA=""
AGENTE_NOME=""
AGENTE_SLUG=""
AGENTE_TIME_NOME=""
AGENTE_DIRETORIA_NOME=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --empresa)                  EMPRESA="$2"; shift 2;;
    --empresa-slug)             EMPRESA_SLUG="$2"; shift 2;;
    --empresa-dominio)          EMPRESA_DOMINIO="$2"; shift 2;;
    --fundador)                 FUNDADOR="$2"; shift 2;;
    --fundador-slug)            FUNDADOR_SLUG="$2"; shift 2;;
    --fundador-email)           FUNDADOR_EMAIL="$2"; shift 2;;
    --fundador-cargo)           FUNDADOR_CARGO="$2"; shift 2;;
    --fundador-escopo)          FUNDADOR_ESCOPO="$2"; shift 2;;
    --timezone)                 TIMEZONE="$2"; shift 2;;
    --idioma)                   IDIOMA="$2"; shift 2;;
    --agente-nome)              AGENTE_NOME="$2"; shift 2;;
    --agente-slug)              AGENTE_SLUG="$2"; shift 2;;
    --agente-time-nome)         AGENTE_TIME_NOME="$2"; shift 2;;
    --agente-diretoria-nome)    AGENTE_DIRETORIA_NOME="$2"; shift 2;;
    *) echo "flag desconhecida: $1" >&2; exit 1;;
  esac
done

for var in EMPRESA EMPRESA_SLUG EMPRESA_DOMINIO FUNDADOR FUNDADOR_SLUG FUNDADOR_EMAIL FUNDADOR_CARGO TIMEZONE IDIOMA AGENTE_NOME AGENTE_SLUG AGENTE_TIME_NOME AGENTE_DIRETORIA_NOME; do
  if [ -z "${!var}" ]; then
    echo "erro: argumento obrigatório ausente: --${var,,}" >&2
    exit 1
  fi
done

for slug in "$EMPRESA_SLUG" "$AGENTE_SLUG" "$FUNDADOR_SLUG"; do
  if ! [[ "$slug" =~ ^[a-z0-9][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "erro: slug inválido '$slug'. Use lowercase, números, hífen." >&2
    exit 1
  fi
done

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

if [ -f ".cerebro-inicializado" ]; then
  echo "erro: este cérebro já foi inicializado." >&2
  exit 1
fi

BACKUP_TAG="pre-inicializacao-$(date +%Y%m%d-%H%M%S)"
git tag "$BACKUP_TAG" 2>/dev/null || true

if sed --version 2>/dev/null | grep -q GNU; then
  SED_INPLACE=(-i)
else
  SED_INPLACE=(-i '')
fi

replace_in_tree() {
  local key="$1"
  local value="$2"
  local escaped
  escaped=$(printf '%s\n' "$value" | sed -e 's/[\/&|]/\\&/g')
  find . -type f \( -name '*.md' -o -name '*.sh' -o -name '*.yaml' -o -name '*.yml' -o -name '*.html' \) \
    -not -path './.git/*' \
    -print0 | xargs -0 sed "${SED_INPLACE[@]}" "s|{{${key}}}|${escaped}|g"
}

replace_in_tree "EMPRESA"                "$EMPRESA"
replace_in_tree "EMPRESA_SLUG"           "$EMPRESA_SLUG"
replace_in_tree "EMPRESA_DOMINIO"        "$EMPRESA_DOMINIO"
replace_in_tree "FUNDADOR_1"             "$FUNDADOR"
replace_in_tree "FUNDADOR_1_SLUG"        "$FUNDADOR_SLUG"
replace_in_tree "FUNDADOR_1_EMAIL"       "$FUNDADOR_EMAIL"
replace_in_tree "FUNDADOR_1_CARGO"       "$FUNDADOR_CARGO"
replace_in_tree "FUNDADOR_1_ESCOPO"      "$FUNDADOR_ESCOPO"
replace_in_tree "TIMEZONE"               "$TIMEZONE"
replace_in_tree "IDIOMA"                 "$IDIOMA"
replace_in_tree "AGENTE_NOME"            "$AGENTE_NOME"
replace_in_tree "AGENTE_SLUG"            "$AGENTE_SLUG"
replace_in_tree "AGENTE_TIME_NOME"       "$AGENTE_TIME_NOME"
replace_in_tree "AGENTE_DIRETORIA_NOME"  "$AGENTE_DIRETORIA_NOME"

# Renomear pasta do agente
OLD_AGENT_DIR="agentes/{{AGENTE_SLUG}}"
NEW_AGENT_DIR="agentes/$AGENTE_SLUG"

# Como os placeholders já foram substituídos no find acima, a pasta continua com o nome literal {{AGENTE_SLUG}}
# até a gente renomear
if [ -d "agentes/{{AGENTE_SLUG}}" ]; then
  git mv "agentes/{{AGENTE_SLUG}}" "agentes/$AGENTE_SLUG" 2>/dev/null || mv "agentes/{{AGENTE_SLUG}}" "agentes/$AGENTE_SLUG"
fi

# Remove rodapés meta-template stale (linha "*Gerado a partir...*" + separador "---"
# órfão imediatamente acima — viraria lixo no repo do usuário final).
FILES_WITH_FOOTER=$(grep -rl --include='*.md' -E '^\*Gerado a partir.*template-second-brain.*\*$' . 2>/dev/null || true)
if [ -n "$FILES_WITH_FOOTER" ]; then
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    sed "${SED_INPLACE[@]}" -E '/^\*Gerado a partir.*template-second-brain.*\*$/d' "$f"
    awk '
      { lines[NR] = $0 }
      END {
        n = NR
        while (n > 0 && lines[n] ~ /^[[:space:]]*$/) n--
        if (n > 0 && lines[n] == "---") {
          n--
          while (n > 0 && lines[n] ~ /^[[:space:]]*$/) n--
        }
        for (i = 1; i <= n; i++) print lines[i]
      }
    ' "$f" > "${f}.tmp" && mv "${f}.tmp" "$f"
  done <<< "$FILES_WITH_FOOTER"
fi

cat > ".cerebro-inicializado" <<EOF
inicializado_em: $(date --iso-8601=seconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z")
tipo: pessoal
empresa: $EMPRESA
empresa_slug: $EMPRESA_SLUG
fundador: $FUNDADOR
fundador_slug: $FUNDADOR_SLUG
agente: $AGENTE_NOME
agente_slug: $AGENTE_SLUG
agente_time: $AGENTE_TIME_NOME
agente_diretoria: $AGENTE_DIRETORIA_NOME
timezone: $TIMEZONE
idioma: $IDIOMA
versao_template: 1.0
tag_backup: $BACKUP_TAG
EOF

RESIDUAL=$(grep -rnE '\{\{[A-Z_0-9]+\}\}' . --include='*.md' --include='*.sh' --include='*.yaml' --include='*.yml' --include='*.html' --exclude-dir=.git 2>/dev/null || true)
if [ -n "$RESIDUAL" ]; then
  echo "aviso: placeholders residuais:"
  echo "$RESIDUAL" | head -10
else
  echo "✅ todos os placeholders substituídos"
fi

git add -A
git -c user.name="$FUNDADOR" -c user.email="$FUNDADOR_EMAIL" commit -m "init: cérebro pessoal de $FUNDADOR ($AGENTE_NOME)

Placeholders substituídos, pasta agentes/$AGENTE_SLUG/ criada. Backup: tag $BACKUP_TAG."

echo
echo "== inicialização concluída =="
echo "próximos passos:"
echo "  1) git push origin main"
echo "  2) teste uma sessão com /save"
echo "  3) se é diretor, clone os 2 cérebros coletivos lado a lado (ver SKILL.md passo 4)"
