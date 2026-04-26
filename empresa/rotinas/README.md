# rotinas/ — automações pessoais

Pasta pra descrever automações (crons) que {{FUNDADOR_1}} configurou no próprio fluxo.

## Exemplos possíveis

- `autosave.md` — descreve o cron de `/save` periódico no VPS (se rodar em VPS)
- `team-sync-diario.md` — descreve o `/team-sync` automático diário (se houver)
- `briefing-matinal.md` — rotina personalizada de briefing

## Formato

Cada rotina num arquivo `.md`, flat. Exemplo de estrutura:

```markdown
---
nome: autosave
schedule: "*/15 * * * *"
skill: save
---

# Rotina: autosave a cada 15 min

## O que faz
Rodar /save com flag --auto, gerar daily note se não existe, push no main.

## Quando roda
A cada 15 minutos, no VPS.

## O que entrega
Daily note do dia com capturas do buffer + push no repo pessoal.
```

## Não é obrigatório

Se {{FUNDADOR_1}} opera só via laptop on-demand (sem VPS), essa pasta fica vazia. Nada de rotina automática é obrigatória.
