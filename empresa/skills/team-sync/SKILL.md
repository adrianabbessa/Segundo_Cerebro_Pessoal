---
name: team-sync
description: Distribui capturas do cérebro pessoal do diretor pros 2 cérebros coletivos (empresa + diretoria) via quiz guiado item-a-item. Só roda explicitamente quando o diretor quer compartilhar. Usa git log pra identificar capturas novas desde último sync. Escreve em inbox/{diretor-slug}/ dos cérebros coletivos em staging — a consolidação noturna deles processa dali.
---

# /team-sync — Cérebro Pessoal (diretor)

> Distribui capturas do cérebro pessoal pros 2 cérebros coletivos quando o diretor decidir. Nunca automático sem confirmação item-a-item.

## Quando rodar

**Sempre manual** (comando `/team-sync`). Típico: 1x/dia no fim do expediente, ou quando decidir distribuir algo específico.

**Em VPS 24/7:** pode ser agendado via cron (ex: `0 18 * * *` — 18h todo dia). Mas ainda é interativo — o cron só dispara; o diretor decide cada item em sessão Claude Code.

## Pré-requisito

Os 2 cérebros coletivos devem estar clonados **lado a lado** deste:

```
~/brains/
├── {{EMPRESA_SLUG}}-second-brain/
├── {{EMPRESA_SLUG}}-diretoria/
└── {{EMPRESA_SLUG}}-{{AGENTE_SLUG}}/    ← estou aqui
```

Se algum dos 2 não existir ou não estiver no path esperado, a skill pergunta onde está (ou aborta se o diretor não tem acesso).

## Fluxo — 7 passos

### Passo 1 — Identificar capturas novas (Opção C — git log)

Lê `.team-sync-log` na raiz do cérebro pessoal (se existir) pra pegar o último commit sincronizado. Se não existe, considera "desde o início do repo".

```bash
LAST_SYNCED=$(cat .team-sync-log 2>/dev/null | tail -1 | awk '{print $1}' || echo "")
if [ -n "$LAST_SYNCED" ]; then
  git log --oneline $LAST_SYNCED..HEAD -- empresa/contexto/ agentes/{{AGENTE_SLUG}}/memory/
else
  git log --oneline HEAD -- empresa/contexto/ agentes/{{AGENTE_SLUG}}/memory/
fi
```

Lista arquivos criados/modificados desde o último sync em `empresa/contexto/` e `memory/`.

### Passo 2 — Quiz item-a-item

Pra cada arquivo novo/modificado, mostrar resumo curto (2-3 linhas do conteúdo) e perguntar:

> _"Arquivo: `empresa/contexto/projetos.md`_
> _Resumo: atualizei com novo projeto 'Apollo launch' — meta 500k, deadline 15/07._
>
> _Onde esse conteúdo vai?_
> _[1] Time (cérebro da empresa) — inbox/{{FUNDADOR_1_SLUG}}/_
> _[2] Diretoria — inbox/{{FUNDADOR_1_SLUG}}/_
> _[3] Ambos_
> _[4] Só pessoal (não distribuir)_
> _[5] Ver conteúdo completo antes de decidir"_

Default é **[4] só pessoal** — só sai se o diretor explicitar outro destino.

### Passo 3 — Aplicar regra dos 3 gatilhos

Se o conteúdo dispara qualquer dos 3 gatilhos (dinheiro com nome próprio, pessoa específica, peso contratual sensível ou jurídico — acordos de sócios, NDAs, M&A, litígio, advocacia/advisory; **não** contratos operacionais como gateway, hosting, SaaS recorrente):

- **Destino obrigatório: diretoria** (não pode ir pro time)
- Skill avisa se o diretor tentou marcar `[1] Time`:
  > _"Esse item dispara gatilho 2 (pessoa específica: menção a 'Ana Silva'). Não posso mandar pro time. Pergunto de novo: [2] diretoria ou [4] só pessoal?"_

### Passo 4 — Copiar pros inboxes dos cérebros coletivos

Pra cada item com destino **Time** ou **Diretoria**:

1. Copiar o arquivo (Markdown/HTML) pra `inbox/{{FUNDADOR_1_SLUG}}/` do repo-destino
2. Gerar sidecar `.meta.yaml` com:

```yaml
autor: {{FUNDADOR_1_SLUG}}
data: {timestamp do /team-sync}
fonte: team-sync-de-pessoal
tipo: proposta-canonica        # default — consolidação abre PR
maturidade: draft              # default — diretor pode marcar pronto-para-canonico no quiz
destino_sugerido: null         # diretor pode sugerir via quiz opcional
relacionado: [../{cerebro-pessoal-repo}/path/original.md]
tags: [team-sync, {origem}]
```

3. Se for diretoria: sidecar tem flag `revisao_humana_obrigatoria: true` explícita (redundante mas clara)

### Passo 5 — Quiz opcional de destino canônico (rápido, só se o diretor quiser)

Pergunta rápida por item:
> _"Sugerir destino canônico? (ex: `areas/marketing/contexto/campanhas.md`) ou deixa a consolidação decidir? [Enter pra deixar]"_

Se sugerir, preenche `destino_sugerido` no sidecar.

### Passo 6 — Commit + push em staging dos cérebros coletivos

Pra cada cérebro-destino que recebeu capturas:

```bash
cd ../{{EMPRESA_SLUG}}-second-brain  # ou -diretoria
git fetch origin
git checkout staging
git pull --rebase origin staging
git add inbox/{{FUNDADOR_1_SLUG}}/
git commit -m "team-sync: {{FUNDADOR_1}} ({N} capturas)"
git push origin staging
```

### Passo 7 — Atualizar `.team-sync-log` no cérebro pessoal

Registrar o último commit HEAD do cérebro pessoal que foi processado:

```bash
echo "$(date --iso-8601=seconds) $(git rev-parse HEAD)" >> .team-sync-log
git add .team-sync-log
git commit -m "team-sync: marca ultimo sync"
git push origin main
```

Próximo `/team-sync` usa esse log pra pegar só capturas mais recentes.

## Confirmação final

> _"✅ Team-sync completo._
> _- {N} capturas enviadas pro time (inbox/{{FUNDADOR_1_SLUG}}/ em staging)_
> _- {M} capturas enviadas pra diretoria (inbox/{{FUNDADOR_1_SLUG}}/ em staging)_
> _- {K} capturas mantidas só pessoal (não distribuídas)"_

## Regras duras

- **Só Markdown e HTML** são copiados. Arquivos binários não existem neste cérebro pessoal (URLs apenas).
- **3 gatilhos bloqueiam envio pro time** — só vai pra diretoria
- **Default do quiz:** item mantido só pessoal, nunca distribuído sem confirmação explícita
- **Merge, não rebase**, nos cérebros coletivos (menos o staging dos coletivos, que é rebase pra sync)
- **`.team-sync-log` é append-only** — nunca reescrever histórico

## Edge cases

- **Cérebros coletivos não clonados localmente** — skill orienta a clonar lado a lado ou sair
- **Conflito em `inbox/{{FUNDADOR_1_SLUG}}/` (outro sócio com mesmo slug?)** — não deveria acontecer; abortar com alerta
- **Rede offline** — skill detecta e sai com erro; nada é committed até retomar

---

*Inspirada no fluxo coletivo do second-brain-amora, adaptada pra distribuição cross-repo com quiz guiado.*
