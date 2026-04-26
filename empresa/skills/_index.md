# Skills — Cérebro Pessoal

Skills inclusas neste template.

## Ordem de uso após clonar

1. **`inicializar-cerebro`** — primeiro uso (preenche placeholders, renomeia pasta do agente). Roda uma vez.
2. A partir daí: `cerebro`, `save` e `team-sync` são as skills do dia a dia.

## Skills essenciais

| Skill | Quando usar |
|-------|-------------|
| `inicializar-cerebro` | **Primeiro uso** após clone. Preenche placeholders + renomeia `agentes/ada/` pro slug escolhido. Tutorial curto (este template é mais simples que os coletivos). |
| `cerebro` | **Início de cada sessão** aberta em `~/brains/` (pasta-mãe) — carrega os `CLAUDE.md` dos cérebros irmãos em paralelo. **Fonte canônica da skill vive no cérebro do TIME** (`grupo-vab-second-brain/empresa/skills/cerebro/`) — universal, funcionário e diretor recebem. Cópia aqui é espelho; `setup-workstation` prefere a versão do time ao criar o symlink. |
| `save` | Fim de sessão (automático antes de compactar) ou sob demanda (`/save` explícito). Materializa o buffer mental do Claude no repo. Pergunta sobre arquivos em Drive (guarda só URL). Commit + push em `main`. |
| `team-sync` | Distribuir capturas pros cérebros coletivos (time e/ou diretoria). Quiz item-a-item. Só roda explicitamente. |

## O que este template **não** tem (propositalmente)

- `/rotina` — briefing diário não é escopo deste template.
- `consolidar-estacoes` — não há consolidação coletiva; Adriana Bessa escreve direto em `main`.
- `setup-estacao-pessoal` — cérebro pessoal é individual por natureza. Não faz sentido criar estações dentro.
- `inbox/` — sem buffer coletivo. Tudo é direto em canônico do cérebro pessoal.

---

Adicione skills próprias em `empresa/skills/{nome}/SKILL.md`.
