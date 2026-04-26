---
name: save
description: Flush de fim de sessão do cérebro pessoal. Materializa buffer mental do Claude em Markdown/HTML no repo. Roda automaticamente antes de compactar a sessão ou sob demanda via /save. Pergunta se há arquivos externos (Drive, etc.) — guarda só URL. Commit direto em main + push.
---

# /save — Cérebro Pessoal

> Flush de fim de sessão. Pega tudo que o Claude acumulou no buffer mental durante a conversa e materializa no repo como Markdown (ou HTML, quando faz sentido).

## Quando rodar

**Automático:**
- Antes de compactar a sessão (sempre — nunca compactar com buffer não salvo)

**Manual:**
- `/save` quando o usuário quer flush intermediário (pra não perder contexto num corte)

## Fluxo — 6 passos

### Passo 1 — Revisão mental

Reler toda a sessão desde o último `/save` (ou desde o início). Separar em categorias:
- **Daily note** — o que aconteceu na sessão (vai pra `agentes/{{AGENTE_SLUG}}/memory/YYYY-MM-DD.md`)
- **Contexto durável** — conhecimento que deve persistir (vai pra `empresa/contexto/`)
- **Referências externas** — arquivos em Drive/Notion/etc. que vale guardar URL

### Passo 2 — Perguntar sobre arquivos externos

Se durante a sessão o usuário mencionou arquivos em Drive/Notion/S3:

> _"Você mencionou [arquivo X]. Quer que eu guarde a URL do Drive dele aqui no cérebro? Se sim, me passa o link."_

Salvar como Markdown com link, não o arquivo em si.

### Passo 3 — Montar daily note

Criar/atualizar `agentes/{{AGENTE_SLUG}}/memory/YYYY-MM-DD.md`:

```markdown
# {{YYYY-MM-DD}}

## Sessões

### HH:MM — {tópico}
- {o que aconteceu, 1-3 bullets}
- decisões: {se houver}
- próximos passos: {se houver}

## Capturas pra empresa/contexto/
- {se atualizou empresa/contexto/{arquivo}, referenciar aqui}
```

Se já existe daily note do dia, **adicionar seção nova no fim** (não sobrescrever).

### Passo 4 — Atualizar empresa/contexto/ se tiver conhecimento durável

Se surgiu algo que vale como contexto persistente (não só do dia):
- Atualizar arquivo em `empresa/contexto/` apropriado (ex: `projetos.md`, `pessoas.md`, `decisoes.md`)
- Se o arquivo não existe ainda, criar com título claro
- Manter Markdown simples — sem frontmatter, sem sidecar

### Passo 5 — Git

```bash
git add -A
git commit -m "save: {resumo em 1 linha do que foi capturado}"
git pull --no-rebase origin main    # merge, nunca rebase
git push origin main
```

**Merge, não rebase.** Este cérebro pode ser escrito por você no laptop E pelo OpenClaw no VPS — rebase causa estados inconsistentes.

### Passo 6 — Confirmação curta ao humano

Resumir em 1-3 linhas o que foi salvo:

> _"Salvei. Daily note de hoje atualizada. Atualizei também `empresa/contexto/projetos.md` com o novo projeto X. Commit + push OK."_

## Regras duras

- **Só Markdown e HTML** no repo
- **Arquivos externos** → URL no Markdown, nunca o binário
- **Commit em `main`** — este cérebro não tem staging
- **Merge não rebase** em caso de conflito no pull
- Se há buffer importante e usuário não rodou `/save`, **rodar automaticamente** antes de compactar

## Edge cases

- **Sessão sem contexto importante** — rodar `/save` mesmo assim, só criar daily note com "sessão operacional, sem capturas duráveis". Mantém trilha.
- **Conflito no pull** — `git pull --no-rebase`, resolver conflito, commitar, push. Nunca `--force`.
- **Usuário cancela `/save`** — OK, não força. Mas avisa que buffer será perdido ao compactar.

---

*Inspirada no `/salve` do second-brain-amora.*
