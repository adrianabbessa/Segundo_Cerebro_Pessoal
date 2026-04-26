---
name: cerebro
description: Carrega em paralelo os CLAUDE.md dos cérebros disponíveis em `~/brains/` (pessoal, time, diretoria). Use quando a sessão está aberta a partir de `~/brains/` (pasta-mãe) e os contextos precisam estar ativos — Claude Code só auto-carrega o CLAUDE.md do cwd, não desce em subpastas.
---

# /cerebro — Carregamento dos cérebros disponíveis

> Claude Code só carrega automaticamente o `CLAUDE.md` do diretório atual (e pastas pai). Quando a sessão é aberta em `~/brains/` (pasta-mãe), os `CLAUDE.md` dos cérebros irmãos **não** são lidos. Esta skill resolve em reads paralelos.

## O que faz

Detecta os cérebros presentes em `~/brains/` e lê o `CLAUDE.md` de cada um (1 mensagem, N tool calls Read em paralelo):

- `{{FUNDADOR_1_SLUG}}-second-brain/CLAUDE.md` — cérebro pessoal de {{FUNDADOR_1}} (agente: {{AGENTE_NOME}})
- `{{EMPRESA_SLUG}}-second-brain/CLAUDE.md` — cérebro do time (agente: {{AGENTE_TIME_NOME}})
- `{{EMPRESA_SLUG}}-diretoria/CLAUDE.md` — cérebro da diretoria (agente: {{AGENTE_DIRETORIA_NOME}})

Membros do time que só têm 1 cérebro (`{{EMPRESA_SLUG}}-second-brain`) também podem rodar — nesse caso é no-op (Claude Code já carrega o CLAUDE.md do cwd se a sessão abriu direto no repo). Útil mesmo pra 3 cérebros.

## Quando rodar

- **Início de sessão** em `~/brains/` se for atravessar múltiplos cérebros
- **Após `/clear` ou compactação**, pra reativar os contextos
- Quando o usuário pergunta algo que pode envolver qualquer um dos cérebros e você não tem certeza do conteúdo

## Fluxo

1. Detectar cérebros presentes: `ls ~/brains/ | grep -v '^\.'` (ignorar `.claude/`)
2. Ler os `CLAUDE.md` encontrados em paralelo (1 turno, N tool calls Read)
3. Se algum symlink estiver quebrado ou permissão falhar, reportar qual falhou e seguir com os que carregou
4. Confirmar em **1 linha curta**, listando agente de cada cérebro:

   > 3 cérebros carregados: {{AGENTE_NOME}} (pessoal), {{AGENTE_TIME_NOME}} (time), {{AGENTE_DIRETORIA_NOME}} (diretoria).

   Se faltou algum:

   > 2/3 cérebros carregados: {{AGENTE_NOME}} ✓, {{AGENTE_TIME_NOME}} ✓, diretoria ✗ (symlink quebrado).

## O que NÃO faz

- Não faz `git pull` — pra sincronizar com remoto, rodar manualmente.
- Não distribui capturas — pra isso, `/team-sync`.
- Não persiste sessão — pra isso, `/save`.
- Não cria daily note — {{AGENTE_NOME}} faz sob demanda.

## Relação com outras skills

| Skill | Quando roda | O que faz |
|-------|-------------|-----------|
| `setup-workstation` | **Uma vez** por máquina (instala layout + symlinks) | Setup inicial |
| `/cerebro` | **Toda sessão** multi-cérebro | Carrega contexto |
| `/save` | Fim de sessão / checkpoint | Flush buffer → pessoal |
| `/team-sync` | Explícito, quando quer distribuir | Pessoal → coletivos |

## Caminhos esperados

Default: `~/brains/{nome-do-cerebro}/CLAUDE.md`

Se a sessão foi aberta fora de `~/brains/`, usar path absoluto:

- `$HOME/brains/{{FUNDADOR_1_SLUG}}-second-brain/CLAUDE.md`
- `$HOME/brains/{{EMPRESA_SLUG}}-second-brain/CLAUDE.md`
- `$HOME/brains/{{EMPRESA_SLUG}}-diretoria/CLAUDE.md`

---

*Skill canônica do `template-second-brain-pessoal`. Adicionada em 2026-04-23 como complemento do `setup-workstation`.*
