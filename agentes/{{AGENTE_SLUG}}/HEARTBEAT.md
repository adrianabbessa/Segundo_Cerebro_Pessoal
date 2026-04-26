# HEARTBEAT — {{AGENTE_NOME}}

## Rotinas ativas (quando rodando em VPS 24/7)

| rotina                        | frequência       | skill                 |
|-------------------------------|------------------|-----------------------|
| Auto-save + pull/push         | a cada 15 min    | wrapper do /save      |
| Team-sync periódico           | 1x/dia (09:00)   | /team-sync            |

## Como agendar (opcional — só se rodando em VPS)

Scheduled Task ou cron:

```cron
# a cada 15 min: save automático + pull/push do cérebro pessoal
*/15 * * * * cd ~/brains/{{EMPRESA_SLUG}}-{{AGENTE_SLUG}} && /path/to/autosave-and-sync.sh

# 1x/dia às 09:00: team-sync com quiz (se houver coisa nova)
0 12 * * * cd ~/brains/{{EMPRESA_SLUG}}-{{AGENTE_SLUG}} && /path/to/team-sync.sh --interactive
```

## No laptop (sem VPS)

Sem crons. `/save` é chamado manualmente ou automático antes de compactar. `/team-sync` é manual quando o diretor quer distribuir.

## Verificações periódicas

### 1. Daily notes do dia
- Se a pasta `memory/` não tem `YYYY-MM-DD.md` da data atual, criar no primeiro `/save` do dia

### 2. Saúde do sync
- `git status` limpo antes de compactar
- Se há conflito, resolver com merge (nunca rebase — ver CLAUDE.md)

### 3. Verificar buffer não salvo
- Antes de compactar a sessão, checar se há contexto importante não materializado — rodar `/save` automaticamente se sim

---

*Template: ajuste timing e integrações conforme uso real. Heartbeat é opcional — só ativa se você rodar em VPS.*
