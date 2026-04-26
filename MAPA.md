# MAPA — Cérebro Pessoal de {{FUNDADOR_1}}

## Função

Ponto de entrada pra navegar este cérebro pessoal.

## Contexto

Este é o cérebro pessoal/individual de **{{FUNDADOR_1}}** — um por diretor (ou por cargo). É o workspace canônico do **OpenClaw pessoal** ({{AGENTE_NOME}}).

## Relação com os outros 2 cérebros

Se você é diretor da {{EMPRESA}}, tem acesso a 3 cérebros simultâneos:

| cérebro | propósito | branches | captura |
|---|---|---|---|
| `{{EMPRESA_SLUG}}-second-brain` | operacional do time (coletivo) | staging + main | via `/save` + `/team-sync` |
| `{{EMPRESA_SLUG}}-diretoria` | sensível da diretoria (coletivo) | staging + main (PR sempre) | via `/save` + `/team-sync` |
| **este** (pessoal) | só de {{FUNDADOR_1}} | só main | via `/save` (direto) + daily notes do agente |

## Estrutura

- `agentes/{{AGENTE_SLUG}}/` — agente pessoal ({{AGENTE_NOME}}) com config + daily notes em `memory/`
- `empresa/contexto/` — o que {{FUNDADOR_1}} sabe/lembra sobre a {{EMPRESA}} e contexto pro trabalho dele
- `empresa/skills/` — skills próprias do cérebro pessoal (inicializar-cerebro, save, team-sync)
- `empresa/rotinas/` — automações pessoais (se houver)

## Regras operacionais

- **Só Markdown e HTML.** Outros formatos ficam no Drive, referenciados com URL.
- **Captura explícita via `/save`** — nada sobe em tempo real.
- **`/team-sync`** distribui pros 2 cérebros coletivos com quiz.
- **Branch única: `main`.** Sem staging, sem PRs, sem consolidação noturna.
- **Pull + push periódicos** pelo OpenClaw pessoal (cron 15 min) — mantém sincronizado entre VPS e laptop.

---

*Cérebro pessoal — só o dono escreve. O que é coletivo vai pros outros 2 cérebros via `/team-sync`.*
