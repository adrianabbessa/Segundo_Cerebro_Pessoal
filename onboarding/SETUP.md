# SETUP — Cérebro Pessoal

> Wizard enxuto do `template-second-brain-pessoal`. Este é o cérebro **individual** do dono — mais simples que os coletivos.

## Pré-requisitos

- Conta GitHub (pessoal — não use conta da Org da empresa)
- Claude Code ou Cowork Desktop instalado
- Git configurado (SSH recomendado)
- ~20 min

## Skills na ordem

| # | Skill | Onde rodar |
|---|---|---|
| 1 | `inicializar-cerebro` | Claude Code no repo clonado. Preenche placeholders, renomeia pasta do agente. **1 vez só.** |
| 2 | `save` (diário, automático) | Claude Code durante qualquer sessão. Captura buffer mental do Claude. Roda automaticamente antes de compactar ou explicitamente com `/save`. |
| 3 | `team-sync` (sob demanda) | Claude Code quando você quer distribuir pros cérebros coletivos. Quiz item-a-item. |

## Fase 1 — Criar seu fork

1. Acesse `github.com/pixel-educacao/template-second-brain-pessoal`.
2. **"Use this template" → "Create a new repository"**.
3. Owner: **sua conta pessoal** (não a Org da empresa — este cérebro é seu).
4. Nome sugerido: `grupo-vab-ada` (ex: `acme-amora`).
5. Visibilidade: **Private**.

## Fase 2 — Clonar local

Recomenda-se clonar junto aos outros 2 cérebros (se você for diretor e tiver acesso):

```bash
mkdir -p ~/brains
cd ~/brains
git clone git@github.com:{{SUA_CONTA}}/grupo-vab-ada.git
# se diretor, clone também:
# git clone git@github.com:{{ORG}}/grupo-vab-second-brain.git
# git clone git@github.com:{{ORG}}/grupo-vab-diretoria.git
cd grupo-vab-ada
```

## Fase 3 — Inicializar

No Claude Code / Cowork, com o repo aberto:

> "Rode a skill inicializar-cerebro"

Segue o fluxo de 5 passos (ver `empresa/skills/inicializar-cerebro/SKILL.md`):
1. Entende o modelo
2. Responde ~14 perguntas (empresa, fundador, agente, etc.)
3. Confirma
4. Script substitui placeholders + renomeia pasta do agente
5. Mostra roadmap dos próximos passos

## Fase 4 — Primeira sessão com `/save`

Faça uma conversa qualquer com o Claude (ex: "me ajude a pensar sobre o lançamento do produto X"). Ao fim:

> "Rode /save"

Claude:
- Revisa tudo que foi discutido
- Pergunta se há arquivos em Drive/outros que vale referenciar
- Materializa capturas em `empresa/contexto/` (ou cria daily note em `agentes/ada/memory/YYYY-MM-DD.md`)
- Commita e pusha em `main`

## Fase 5 — Primeira `/team-sync` (quando tiver conteúdo pra distribuir)

Depois de acumular algumas capturas no cérebro pessoal, quando algo valer compartilhar com time ou diretoria:

> "Rode /team-sync"

Claude vai:
- Listar capturas novas desde último sync (usa git log)
- Pra cada: pergunta "vai pra empresa? diretoria? só pessoal?"
- Copia pros `inbox/{seu-slug}/` dos cérebros coletivos em staging + commit + push
- A consolidação noturna dos cérebros coletivos processa a partir daí

## Fase 6 — Setup opcional de VPS 24/7

Se quiser agente pessoal rodando autônomo:

- Suba OpenClaw no VPS
- Clone este repo no workspace do VPS
- Configure crons (exemplos em `agentes/ada/HEARTBEAT.md`)

## Tempo total

- Fases 1-3: 15 min
- Fase 4: 5 min (primeira experiência)
- Fase 5: ~10 min quando fizer sentido (semana 2+)
- Fase 6: 30 min (opcional, só se quiser VPS)

## Links

- [`CLAUDE.md`](../CLAUDE.md) — instruções operacionais
- [`MAPA.md`](../MAPA.md) — navegação
- [`empresa/skills/save/SKILL.md`](../empresa/skills/save/SKILL.md)
- [`empresa/skills/team-sync/SKILL.md`](../empresa/skills/team-sync/SKILL.md)
