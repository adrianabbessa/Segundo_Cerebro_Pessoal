---
name: inicializar-cerebro
description: Configurar o cérebro pessoal pela primeira vez após clonar o template-second-brain-pessoal. Preenche placeholders (Grupo VAB, Ada, Adriana Bessa, etc.) em todos os arquivos, renomeia a pasta do agente pro slug escolhido. Roda UMA VEZ após o clone — aborta se já foi executada.
---

# Inicializar Cérebro — Template Pessoal

> Tutorial + configurador. Roda **uma única vez** no primeiro uso do repo clonado.

## Pré-condição

- Você já é sócio-diretor da empresa (ou vai ser)
- Clonou este template via "Use this template" no GitHub (na sua conta pessoal, não na Org da empresa)
- Clonou o repo localmente

## Fluxo — 5 passos

### Passo 1 — Contexto do modelo

Explicar ao humano (se ele nunca operou cérebro antes):

- Este é o **cérebro pessoal individual** dele (diretor), separado dos cérebros coletivos
- Três cérebros no total:
  - Time (coletivo, operacional)
  - Diretoria (coletivo, sensível)
  - **Este** (pessoal, só dele)
- Aqui: **só Markdown e HTML**, **só main** (sem staging), captura via `/save` e distribuição via `/team-sync`
- Daily notes sobem automaticamente aqui conforme ele usa o agente

Pergunte: _"Entendeu o papel deste cérebro?"_

### Passo 2 — Coleta de dados

1. **Nome da empresa** → `Grupo VAB` (ex: "Acme Corp")
2. **Slug da empresa** → `grupo-vab` (ex: "acme")
3. **Domínio** → `grupovab.com.br` (ex: "acme.com")
4. **Seu nome completo** → `Adriana Bessa`
5. **Seu slug pessoal** → `adriana` (ex: "ana-s") — usado também no team-sync (vai pra `inbox/{slug}/` dos coletivos)
6. **Seu email** → `adrianabezerrabessa@gmail.com`
7. **Seu cargo** → `CFO e Fundadora` (ex: "CEO", "COO")
8. **Escopo resumido** → `CFO do Lojão do Brás, fundadora da Pagmoda, professora de ML e coach de corrida` (1-2 linhas do que você faz)
9. **Timezone** → `America/Sao_Paulo` (default: `America/Sao_Paulo`)
10. **Idioma** → `pt-BR` (default: `pt-BR`)
11. **Nome do seu agente pessoal** → `Ada` (ex: "Amora", "Jarvis")
12. **Slug do agente** → `ada` (ex: "amora", "jarvis")
13. **Nome do agente do time** (pra referências cross-repo) → `Iris` (ex: "Oliver")
14. **Nome do agente da diretoria** (pra referências cross-repo) → `Atena` (ex: "Atena")

### Passo 3 — Confirmação + aplicação

Mostrar resumo dos valores e confirmar. Aplicar via `scripts/inicializar.sh`:

```bash
bash empresa/skills/inicializar-cerebro/scripts/inicializar.sh \
  --empresa "Acme Corp" \
  --empresa-slug "acme" \
  --empresa-dominio "acme.com" \
  --fundador "Ana Silva" \
  --fundador-slug "ana-s" \
  --fundador-email "ana@acme.com" \
  --fundador-cargo "CEO" \
  --fundador-escopo "Estratégia, vendas, funding" \
  --timezone "America/Sao_Paulo" \
  --idioma "pt-BR" \
  --agente-nome "Amora" \
  --agente-slug "amora" \
  --agente-time-nome "Oliver" \
  --agente-diretoria-nome "Atena"
```

### Passo 4 — Setup dos paths dos cérebros coletivos (opcional)

Pra o Claude conseguir **carregar os 3 cérebros juntos** quando abrir este, você precisa ter clonado os 3 lado a lado:

```
~/brains/
├── acme-second-brain/          (cérebro do time — template-empresa clonado)
├── acme-diretoria/             (cérebro da diretoria — template-diretoria clonado)
└── acme-amora/                 (este — pessoal)
```

Se ainda não clonou os outros 2, tudo bem — este cérebro funciona sozinho. O cross-load é ativado assim que os 3 estiverem presentes.

### Passo 5 — Roadmap de próximos passos

```
✅ Cérebro pessoal inicializado.

Próximos passos:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1) AGORA — teste uma captura com /save
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Me pergunte qualquer coisa (ex: "me ajude a pensar sobre X").
Depois rode `/save` — vou materializar o que capturei dessa conversa
em empresa/contexto/ ou memory/{data}.md e commitar em main.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2) DEPOIS — clone os 2 cérebros coletivos (se ainda não)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Se você é diretor e precisa acessar também o cérebro do time e
o da diretoria:

cd ~/brains
git clone git@github.com:adrianabbessa/grupo-vab-second-brain.git
git clone git@github.com:adrianabbessa/grupo-vab-diretoria.git

Depois disso, o Claude carrega os 3 juntos automaticamente quando
você abrir qualquer um dos 3 no Cowork/Claude Code.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3) DEPOIS — subir em VPS (opcional)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Se você quer agente pessoal rodando 24/7, suba OpenClaw no VPS
apontando pro workspace deste repo. Scripts de apoio em
agentes/ada/HEARTBEAT.md.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4) USO DIÁRIO — /save automático antes de compactar
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Não precisa lembrar. Claude sempre executa /save antes de compactar
sessão. Você pode rodar manualmente também, em qualquer momento.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5) USO DIÁRIO — /team-sync quando quiser distribuir
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sempre que tiver conteúdo que vale compartilhar com time ou diretoria,
rode /team-sync. Quiz item-a-item. Nada sai daqui sem você confirmar.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Regras de segurança

- **Não sobrescrever `.cerebro-inicializado`** — se existe, skill aborta
- **Commit em `main`** — este cérebro não tem staging
- **Backup:** tag `pre-inicializacao-{timestamp}` criada antes dos sed

## Recursos

- `scripts/inicializar.sh` — script bash idempotente

## Arquivo de trava

Após a execução, o arquivo `.cerebro-inicializado` é criado:

```yaml
inicializado_em: 2026-04-21T15:32:00-03:00
tipo: pessoal
empresa: Acme Corp
fundador: Ana Silva
agente: Amora
versao_template: 1.0
```

---

*Skill de primeira execução. Roda 1 vez.*
