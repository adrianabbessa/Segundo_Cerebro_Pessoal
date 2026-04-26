# template-second-brain-pessoal

Template de **cérebro pessoal individual** — um por diretor (ou por cargo de diretoria, no futuro). Construído pela Pixel Educação como parte do Pixel AI Hub.

> **Não confundir com** `template-second-brain-empresa` (cérebro coletivo do time) ou `template-second-brain-diretoria` (cérebro coletivo sensível da diretoria). Este template é **individual** — só o dono escreve nele.

## Quando usar

- Você é sócio-diretor e quer um espaço de trabalho pessoal conectado ao operacional da empresa
- Você opera em múltiplas frentes da empresa e precisa de contexto acumulado, decisões registradas, pendências rastreadas — sem passar por consolidação coletiva
- Você já tem (ou vai ter) um **OpenClaw pessoal 24/7** em VPS próprio — este cérebro é o workspace canônico dele

## Filosofia

Modelo **minimalista** inspirado em [second-brain-amora](https://github.com/okjpg/second-brain-amora):

- **Só `main`.** Sem staging, sem PRs, sem consolidação noturna. Você é o único dono.
- **Só Markdown e HTML.** Outros formatos (PDF, PPTX, XLSX, PNG) são referenciados com URL pro Drive dentro de um Markdown.
- **Captura explícita via `/save`.** Nada sobe automaticamente em tempo real. Você decide o que fica.
- **`/team-sync` distribui pros cérebros coletivos** quando algo deve sair do pessoal pra empresa ou diretoria.

## O que você ganha clonando

- Estrutura mínima (agente + empresa/contexto/skills/rotinas)
- Agente pessoal pré-configurado com placeholders
- **4 skills essenciais:**
  - `inicializar-cerebro` — primeiro uso (preenche placeholders, renomeia pasta do agente)
  - `save` — captura explícita de fim de sessão
  - `team-sync` — distribui pros cérebros coletivos com quiz guiado
  - `setup-estacao-pessoal` — herdada (útil se você também quiser estações dentro deste cérebro, mas normalmente não precisa)

## Integração com os 2 cérebros coletivos

Quando você é diretor, você opera **3 cérebros em paralelo:**

```
~/brains/
├── grupo-vab-second-brain/        ← cérebro do time (clonado do template-empresa)
├── grupo-vab-diretoria/           ← cérebro da diretoria (clonado do template-diretoria)
└── grupo-vab-ada/     ← este cérebro pessoal
```

Ao abrir o Claude Code/Cowork neste cérebro pessoal, o `CLAUDE.md` instrui a ferramenta a **carregar também** os outros 2 cérebros paralelos (lê `CLAUDE.md` + `MAPA.md` de cada). Contexto completo numa sessão só.

## Começar

Leia [`onboarding/SETUP.md`](onboarding/SETUP.md).

## Estrutura

```
template-second-brain-pessoal/
├── README.md
├── CLAUDE.md
├── MAPA.md
├── LICENSE
├── .gitignore
├── onboarding/
│   └── SETUP.md
├── agentes/
│   └── ada/
│       ├── IDENTITY.md, SOUL.md, USER.md, AGENTS.md, TOOLS.md, HEARTBEAT.md, MEMORY.md
│       ├── .env.example, .gitignore
│       └── memory/
│           └── YYYY-MM-DD.md  (daily notes)
└── empresa/
    ├── contexto/         ← o que eu sei/lembro sobre a empresa
    ├── rotinas/          ← automações (se houver)
    └── skills/
        ├── inicializar-cerebro/
        ├── save/
        ├── team-sync/
        └── _templates/
```

## Licença

Uso restrito aos assinantes do Pixel AI Hub. Ver [LICENSE](LICENSE).
