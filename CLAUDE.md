# CLAUDE.md — Cérebro Pessoal de {{FUNDADOR_1}}

> Instruções pro Claude Code / Cowork / OpenClaw operar neste cérebro pessoal.

## Contexto

Este é o **cérebro pessoal individual** de **{{FUNDADOR_1}}**, sócio-diretor da {{EMPRESA}}. Agente default: **{{AGENTE_NOME}}**.

Só o dono deste cérebro escreve aqui. Sem consolidação coletiva, sem staging, sem PRs. O que fica público pro time ou pra diretoria é distribuído via `/team-sync` pros respectivos cérebros coletivos.

## Papel do Claude

O Claude atua como **estação de trabalho individual** de {{FUNDADOR_1}}:
- Mantém o `CLAUDE.md` dos 3 cérebros em mente (se os outros 2 estiverem acessíveis — ver seção abaixo)
- Captura contexto durante a sessão em buffer mental
- **Salva automaticamente antes de compactar** (flush de fim de sessão) via skill `save`
- **Salva sob demanda** se o usuário rodar `/save`
- **Distribui pros cérebros coletivos** via skill `team-sync` (explícito)

## 🧠 Carregamento dos 3 cérebros (setup recomendado pra diretor)

Se {{FUNDADOR_1}} é diretor da {{EMPRESA}}, recomenda-se clonar os 3 cérebros lado a lado:

```
~/brains/
├── {{EMPRESA_SLUG}}-second-brain/        (cérebro do time)
├── {{EMPRESA_SLUG}}-diretoria/           (cérebro da diretoria)
└── {{EMPRESA_SLUG}}-{{AGENTE_SLUG}}/     (este — pessoal)
```

Ao abrir **qualquer uma** dessas 3 pastas no Claude Code/Cowork, a ferramenta deve:

1. Ler este `CLAUDE.md` (deste cérebro pessoal)
2. Se existirem `../{{EMPRESA_SLUG}}-second-brain/CLAUDE.md` e `../{{EMPRESA_SLUG}}-diretoria/CLAUDE.md`, também carregar esses
3. Manter os 3 contextos ativos durante a sessão

Se só este cérebro estiver acessível (ex: sessão no celular, ou em ambiente restrito), operar só localmente sem problema.

## Regra estrutural

Este cérebro é **mínimo**:

- `agentes/{{AGENTE_SLUG}}/` — config + memory local (daily notes)
- `empresa/contexto/` — conhecimento que o diretor acumula sobre a empresa
- `empresa/skills/` — skills (`/save`, `/team-sync`, `inicializar-cerebro`)
- `empresa/rotinas/` — automações pessoais

**Não há** `areas/` aqui (não é cérebro organizacional) nem `inbox/` (não há consolidação — tudo vai direto em `main`).

## Modelo de sincronização — só `main`

Tudo vive em `main`. Não há staging, não há PRs.

```bash
git pull --no-rebase origin main    # sempre merge, nunca rebase (conforme Amora)
# ... trabalho ...
# /save commita
git push origin main
```

## Regras duras

1. **Formatos aceitos: Markdown e HTML.** Outros (`.pdf`, `.pptx`, `.xlsx`, `.png`) ficam no Drive/S3 do dono — só URL no Markdown.
2. **`/save` é obrigatório** antes de compactar a sessão. Claude sempre sugere. Se o usuário esquecer, Claude lembra.
3. **Daily notes automáticas em `agentes/{{AGENTE_SLUG}}/memory/YYYY-MM-DD.md`** — criadas pelo agente durante uso.
4. **`/team-sync` é explícito.** Distribui pros 2 cérebros coletivos com quiz guiado por item. Default: não sincroniza (se o usuário não rodar, nada vai pros cérebros coletivos).
5. **Nunca edite direto os cérebros coletivos** a partir daqui. Sempre via `/team-sync` (que joga no `inbox/{nome}/` deles).

## Git merge, não rebase

Em caso de conflito ao fazer pull:

```bash
git pull --no-rebase origin main
# resolver conflito
git commit
git push origin main
```

Merge preserva história; rebase pode gerar estados inconsistentes no VPS vs laptop (os 2 escrevem neste repo).

## O que evitar

- **Não usar** `inbox/` — este cérebro não tem
- **Não editar** os outros 2 cérebros direto (use `/team-sync`)
- **Não commitar** binários grandes (PDFs, vídeos, imagens grandes) — URL pro Drive
- **Não usar** `git rebase` em pull/push

---

*Gerado a partir do `template-second-brain-pessoal` (Pixel AI Hub). Preencha os `{{...}}` via skill `inicializar-cerebro` no primeiro uso.*
