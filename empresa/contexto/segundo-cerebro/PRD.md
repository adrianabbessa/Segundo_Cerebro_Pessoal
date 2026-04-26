# PRD — Implementação dos 3 Segundo Cérebros

**Ordem definida:** Pessoal → Empresa → Diretoria  
**Responsável funcional:** Adriana Bessa  
**Executor operacional:** Ada  
**Data:** 2026-04-26  
**Repositórios locais analisados:**

1. `/root/Segundo_Cerebro_Pessoal`
2. `/root/Segundo_Cerebro_Empresa`
3. `/root/Segundo_Cerebro_Diretoria`

---

## 0. Visão Geral

A arquitetura proposta opera com **3 cérebros complementares**, cada um com função, governança e nível de sensibilidade próprios:

| cérebro | função | acesso | branch principal | captura | consolidação |
|---|---|---|---|---|---|
| **Pessoal** | memória individual da Adriana/Ada | só Adriana | `main` | direta via `/save` | sem PR, sem staging |
| **Empresa** | memória operacional do time | time autorizado | `staging` + `main` | via `inbox/{slug}` | automática, pode promover direto |
| **Diretoria** | memória sensível da diretoria | sócios/diretoria | `staging` + `main` | via `inbox/{diretor}` | sempre via PR com revisão humana |

A implantação deve respeitar os papéis:

- **Ada / Adriana pessoal:** dona do cérebro pessoal.
- **Agente geral da empresa:** gestor do cérebro operacional.
- **Agente da diretoria:** gestor do cérebro sensível.
- **Humanos e agentes pessoais:** visitantes nos cérebros coletivos; escrevem via `inbox/`, nunca diretamente no canônico.

---

# 1. PRD — Cérebro Pessoal

## 1.1 Objetivo

Implantar o cérebro pessoal da Adriana como fonte individual de memória, decisões, contexto estratégico e trabalho diário, conectado aos cérebros coletivos por fluxo explícito de sincronização.

Este cérebro deve funcionar como o workspace pessoal canônico da Ada, sem staging, sem PR e sem consolidação noturna coletiva.

## 1.2 Escopo

### Inclui

- Inicializar o template pessoal com dados da Adriana.
- Renomear agente placeholder para Ada.
- Configurar estrutura mínima de memória pessoal.
- Habilitar uso das skills:
  - `inicializar-cerebro`
  - `save`
  - `team-sync`
  - `cerebro`
- Definir relação com os cérebros Empresa e Diretoria.
- Criar rotina operacional de captura e sincronização.

### Não inclui

- Consolidação automática noturna.
- Branch `staging`.
- PRs.
- Escrita direta nos cérebros coletivos.
- Armazenamento de binários grandes no Git.

## 1.3 Usuários

| usuário | papel |
|---|---|
| Adriana | dona do cérebro pessoal |
| Ada | agente pessoal 24/7 |
| Agente Empresa | recebe conteúdo via `/team-sync` |
| Agente Diretoria | recebe conteúdo sensível via `/team-sync` |

## 1.4 Skills existentes a utilizar

### `inicializar-cerebro`

**Uso:** primeiro setup.  
**Função:** substituir placeholders, renomear pasta do agente, preparar estrutura pessoal.

Campos esperados para Adriana:

| placeholder | valor sugerido |
|---|---|
| `Adriana Bessa` | Adriana Bessa |
| `adriana` | adriana |
| `Grupo VAB` | Holding Adriana Bessa / Grupo VAB *(confirmar nome jurídico/operacional desejado)* |
| `grupo-vab` | grupo-vab *(confirmar)* |
| `Ada` | Ada |
| `ada` | ada |

### `save`

**Uso:** fim de sessão, checkpoint ou antes de compactação.  
**Função:** transformar o buffer da conversa em memória persistente no cérebro pessoal.

Deve salvar em:

- `agentes/ada/memory/YYYY-MM-DD.md`
- `empresa/contexto/` quando o conteúdo for contexto permanente
- `empresa/rotinas/` quando virar rotina pessoal

### `team-sync`

**Uso:** quando algo pessoal deve ser enviado ao cérebro Empresa ou Diretoria.  
**Função:** quiz item-a-item decidindo destino:

- Só pessoal
- Empresa
- Diretoria
- Ambos, se houver parte operacional e parte sensível separáveis

Regra: nunca editar os cérebros coletivos diretamente. Sempre escrever no `inbox/adriana/` deles.

### `cerebro`

**Uso:** início de sessão multi-cérebro.  
**Função:** carregar contexto dos 3 cérebros quando estiverem disponíveis lado a lado.

## 1.5 Arquitetura-alvo

```text
/root/brains ou /root/.openclaw/workspace/brains
├── grupo-vab-ada/              # cérebro pessoal
├── grupo-vab-second-brain/     # cérebro empresa
└── grupo-vab-diretoria/        # cérebro diretoria
```

No estado atual, os templates estão em:

```text
/root/Segundo_Cerebro_Pessoal
/root/Segundo_Cerebro_Empresa
/root/Segundo_Cerebro_Diretoria
```

Recomendação: manter os templates intactos e criar cópias/forks finais com nomes operacionais.

## 1.6 Requisitos funcionais

### RF-P01 — Inicialização personalizada

O sistema deve substituir todos os placeholders `{{...}}` pelos dados reais da Adriana/Ada.

**Critério de aceite:**

```bash
grep -R "{{" /path/do/cerebro-pessoal
```

retorna vazio ou apenas exemplos intencionais documentados.

### RF-P02 — Captura diária

O cérebro pessoal deve permitir captura diária via `/save`.

**Critério de aceite:** arquivo `agentes/ada/memory/YYYY-MM-DD.md` criado após a primeira sessão.

### RF-P03 — Sincronização controlada

O cérebro pessoal deve permitir envio seletivo para Empresa/Diretoria via `/team-sync`.

**Critério de aceite:** uma captura teste aparece em:

- Empresa: `inbox/adriana/`
- Diretoria: `inbox/adriana/`

com sidecar `.meta.yaml` quando aplicável.

### RF-P04 — Sem staging

O cérebro pessoal deve operar apenas em `main`.

**Critério de aceite:** não há dependência operacional de branch `staging`.

## 1.7 Requisitos não funcionais

- Apenas Markdown/HTML no Git.
- Binários grandes ficam no Drive/S3, referenciados por URL.
- Sem conteúdo sensível enviado automaticamente aos coletivos.
- Pull/push com merge, nunca rebase obrigatório no pessoal.

## 1.8 Fases de implementação

### Fase P1 — Preparação

1. Definir nome final do repo pessoal.
2. Confirmar slug da empresa.
3. Confirmar se será GitHub pessoal da Adriana ou organização privada.
4. Criar repo privado a partir do template.

### Fase P2 — Inicialização

1. Rodar skill `inicializar-cerebro`.
2. Preencher dados.
3. Renomear agente para `ada`.
4. Validar ausência de placeholders.

### Fase P3 — Primeira captura

1. Rodar uma sessão teste.
2. Executar `/save`.
3. Confirmar criação da daily note.
4. Commit/push em `main`.

### Fase P4 — Integração com coletivos

1. Garantir que Empresa e Diretoria estejam lado a lado.
2. Rodar skill `cerebro`.
3. Executar `/team-sync` com uma captura operacional.
4. Executar `/team-sync` com uma captura sensível fictícia.
5. Validar destinos corretos.

## 1.9 Riscos

| risco | mitigação |
|---|---|
| Misturar pessoal com diretoria | usar `/team-sync` com quiz explícito |
| Conteúdo sensível ir para Empresa | aplicar regra dos 3 gatilhos antes de sync |
| Git com arquivos grandes | regra Markdown/HTML + URL externa |
| Perder contexto por não salvar | `/save` obrigatório antes de compactar |

## 1.10 Definition of Done — Pessoal

- [ ] Repo pessoal privado criado.
- [ ] Skill `inicializar-cerebro` executada.
- [ ] Ada configurada como agente.
- [ ] Placeholders removidos.
- [ ] `/save` testado.
- [ ] Daily note criada.
- [ ] `/team-sync` testado com Empresa.
- [ ] `/team-sync` testado com Diretoria.
- [ ] Log atualizado.

---

# 2. PRD — Cérebro Empresa

## 2.1 Objetivo

Implantar o cérebro operacional coletivo da empresa, servindo como fonte de verdade para áreas não sensíveis: marketing, vendas, atendimento, operações e produto.

Este cérebro deve capturar conhecimento do time via `inbox/`, consolidar diariamente e promover conteúdo maduro ao canônico.

## 2.2 Escopo

### Inclui

- Inicialização do template Empresa.
- Configuração de branch `staging`.
- Criação de estações pessoais do time.
- Configuração do agente gestor da empresa em OpenClaw.
- Rotina de consolidação noturna.
- Sidecars `.meta.yaml` obrigatórios.
- Regras de promoção, PR e arquivamento.

### Não inclui

- Conteúdo sensível de diretoria.
- Avaliação nominal de pessoas.
- Salários, bônus, comissões individuais.
- Contratos jurídicos sensíveis.
- Acesso do time ao cérebro Diretoria.

## 2.3 Áreas canônicas

| área | escopo |
|---|---|
| `areas/marketing` | conteúdo, campanhas, tráfego, marca |
| `areas/vendas` | funil, pipeline, oportunidades, metas comerciais |
| `areas/atendimento` | suporte, relacionamento, clientes |
| `areas/operacoes` | processos, infraestrutura, automações, rotinas |
| `areas/produto` | roadmap, features, ideias, melhorias |
| `empresa/contexto` | princípios, arquitetura, segurança e contexto transversal |

## 2.4 Skills existentes a utilizar

### `inicializar-cerebro`

Primeira skill do setup. Preenche placeholders, ensina o modelo e cria `.cerebro-inicializado`.

### `setup-estacao-pessoal`

Cria `inbox/{slug}/` para membros do time e salva identidade local.

### `setup-agente-openclaw`

Configura o agente gestor da empresa no VPS/OpenClaw.

Deve operar em dois modos:

- **NOVO:** VPS limpo.
- **MERGE:** workspace existente, preservando customizações.

Para este ambiente, o modo provável é **MERGE**, porque já existe Ada/OpenClaw rodando.

### `consolidar-estacoes`

Rotina noturna de consolidação. Lê `inbox/*`, classifica por sidecar, promove, abre PRs, arquiva e gera digest.

### `save`

Captura de sessão humana ou agente visitante para `inbox/{slug}`.

### `team-sync`

Distribuição de capturas do cérebro pessoal para Empresa.

### `onboarding-membro-time`

Fluxo guiado para novos membros do time.

## 2.5 Arquitetura Git

```text
main      = verdade canônica
staging   = trabalho diário/inboxes
```

Fluxo padrão:

```bash
git checkout staging
git pull --rebase origin staging
# pessoa/agente visitante escreve apenas em inbox/{slug}
git add inbox/{slug}/
git commit
git push origin staging
```

Consolidação:

- agente gestor lê `staging`
- promove conteúdo maduro
- abre PR para casos incertos
- arquiva processados
- sincroniza `main` e `staging`

## 2.6 Regra dos 3 gatilhos

Se qualquer conteúdo tiver:

1. dinheiro com nome próprio;
2. pessoa específica;
3. peso contratual/jurídico sensível;

então **não pertence ao cérebro Empresa**. Deve ir para Diretoria.

## 2.7 Sidecar obrigatório

Todo arquivo capturado em `inbox/{slug}/` deve ter sidecar irmão:

```yaml
autor: adriana
data: 2026-04-26T20:00:00Z
fonte: conversa | captura-solo | pesquisa-web | screenshot | reuniao | brainstorm
tipo: nota | draft | proposta-canonica | diario | referencia
maturidade: cru | draft | pronto-para-canonico
destino_sugerido: areas/operacoes/contexto/exemplo.md
relacionado: []
tags: []
```

## 2.8 Requisitos funcionais

### RF-E01 — Inicialização do repo

Substituir placeholders, renomear agente geral e criar marker `.cerebro-inicializado`.

### RF-E02 — Branch staging

Criar e publicar branch `staging`.

### RF-E03 — Estações pessoais

Criar `inbox/adriana/` e, depois, estações dos membros do time.

### RF-E04 — Captura operacional

Permitir captura via `/save` e `/team-sync`.

### RF-E05 — Consolidação noturna

Registrar cron OpenClaw para rodar `consolidar-estacoes` diariamente.

Sugestão: 02:00 BRT = 05:00 UTC.

### RF-E06 — Digest de consolidação

Gerar `empresa/consolidacao/YYYY-MM-DD.md` com:

- promovidos;
- PRs abertos;
- arquivados;
- mantidos no inbox;
- problemas;
- heartbeat de uso por estação.

### RF-E07 — Promoção segura

Conteúdo `pronto-para-canonico` com `destino_sugerido` válido pode ser promovido direto.

## 2.9 Requisitos não funcionais

- Nunca usar `git add .` para visitantes.
- Visitantes só escrevem em `inbox/{slug}/`.
- Agente gestor pode escrever em canônico.
- Privacidade default: público ao time.
- `privado/` é opt-in explícito e gitignored.
- Conflito de merge deve parar a rotina e alertar.
- Volume anômalo deve virar PR, não promoção automática.

## 2.10 Fases de implementação

### Fase E1 — Fork e clone

1. Criar repo privado na organização.
2. Nome sugerido: `grupo-vab-second-brain`.
3. Clonar lado a lado com os outros cérebros.
4. Criar branch `staging`.

### Fase E2 — Inicializar

1. Rodar `inicializar-cerebro`.
2. Preencher placeholders:

| campo | valor sugerido |
|---|---|
| Empresa | Grupo VAB / Lojão do Brás / Holding Adriana Bessa *(confirmar escopo)* |
| Empresa slug | `grupo-vab` |
| Agente empresa | sugestão: `Atlas`, `Íris` ou `Geral Empresa` |
| Agente slug | `geral-empresa` ou nome escolhido |
| Fundadora | Adriana Bessa |
| Fundadora slug | `adriana` |

3. Validar placeholders.
4. Commit inicial em `staging`.

### Fase E3 — Estação da Adriana

1. Rodar `setup-estacao-pessoal`.
2. Criar `inbox/adriana/`.
3. Fazer captura teste.
4. Validar sidecar.

### Fase E4 — Agente gestor OpenClaw

1. Escolher VPS:
   - opção A: mesmo VPS atual, com isolamento por workspace;
   - opção B: VPS separado para agente Empresa.
2. Rodar `setup-agente-openclaw`.
3. Se modo MERGE: criar backup antes.
4. Registrar rotinas nativas do OpenClaw com base em `areas/*/rotinas/*.md`.

### Fase E5 — Consolidação

1. Rodar `consolidar-estacoes` manualmente com captura teste.
2. Validar promoção para canônico.
3. Validar digest.
4. Validar sync `staging` ↔ `main`.
5. Agendar cron diário.

### Fase E6 — Onboarding do time

1. Usar `onboarding-membro-time`.
2. Criar `inbox/{slug}` por pessoa.
3. Treinar regra dos 3 gatilhos.
4. Treinar criação de sidecar.

## 2.11 Riscos

| risco | mitigação |
|---|---|
| Conteúdo sensível no repo Empresa | regra dos 3 gatilhos + revisão em consolidação |
| Captura sem sidecar | não promover; reportar no digest |
| Pessoa editar canônico | regra operacional + branch protection |
| Conflito de merge | parar e alertar, nunca resolver sozinho |
| Agente misturar autoria | nunca `git add .` incluindo inbox de visitante |

## 2.12 Definition of Done — Empresa

- [ ] Repo privado criado.
- [ ] Branch `staging` publicada.
- [ ] `inicializar-cerebro` executada.
- [ ] Placeholders removidos.
- [ ] `inbox/adriana/` criada.
- [ ] Captura teste com sidecar criada.
- [ ] Agente gestor configurado no OpenClaw.
- [ ] `consolidar-estacoes` testado manualmente.
- [ ] Digest gerado.
- [ ] Cron diário registrado.
- [ ] Regra dos 3 gatilhos documentada no onboarding.
- [ ] Log atualizado.

---

# 3. PRD — Cérebro Diretoria

## 3.1 Objetivo

Implantar o cérebro sensível da diretoria para registrar, organizar e revisar conteúdo que envolve dinheiro nominal, pessoas específicas, jurídico/contratual sensível e governança.

Este cérebro deve operar com isolamento, privacidade por padrão e revisão humana obrigatória em toda promoção ao canônico.

## 3.2 Escopo

### Inclui

- Inicialização do template Diretoria.
- Configuração de branch `staging`.
- Branch protection obrigatória no GitHub.
- Criação de estações pessoais dos diretores.
- Configuração de agente gestor da diretoria.
- Consolidação noturna com PR único diário.
- Backup encriptado offsite.
- Onboarding de diretor.

### Não inclui

- Conteúdo operacional comum.
- Marketing, vendas, atendimento, produto e operações não sensíveis.
- Acesso do time geral.
- Promoção direta para `main`.

## 3.3 Áreas canônicas

| área | escopo |
|---|---|
| `areas/financeiro` | fluxo de caixa, obrigações, remuneração, informações financeiras sensíveis |
| `areas/rh` | avaliações, conflitos, contratações, desligamentos |
| `areas/juridico` | contratos, compliance, LGPD, litígios |
| `areas/governanca` | decisões estratégicas, atas, relação com investidores, board |

## 3.4 Skills existentes a utilizar

### `inicializar-cerebro`

Primeira skill. Preenche placeholders e prepara o cérebro sensível.

### `setup-estacao-pessoal`

Cria `inbox/{diretor}/`, com privacidade default.

### `setup-agente-openclaw`

Configura agente gestor da diretoria em VPS dedicado.

Regra forte: idealmente **não usar o mesmo VPS do agente Empresa**.

### `consolidar-estacoes`

Rotina de consolidação sensível. Diferente da Empresa:

- nunca promove direto para `main`;
- sempre abre PR único diário;
- revisão humana obrigatória;
- staging pode ficar à frente de main enquanto PR não for aprovado.

### `onboarding-diretor`

Fluxo de entrada de novo diretor/sócio no sistema.

### `save` e `team-sync`

Captura e distribuição controlada a partir do cérebro pessoal.

## 3.5 Arquitetura Git

```text
main      = canônico sensível, protegido
staging   = capturas e trabalho diário
PR diário = única via de entrada no main
```

Fluxo:

1. Diretor ou agente pessoal escreve em `inbox/adriana/`.
2. Agente Diretoria consolida.
3. Cria branch `consolidacao/YYYY-MM-DD`.
4. Abre PR para `main`.
5. Sócio revisa.
6. Só após aprovação entra no canônico.

## 3.6 Regra de pertencimento

Conteúdo só pertence ao cérebro Diretoria se disparar ao menos um dos gatilhos:

1. dinheiro com nome próprio;
2. pessoa específica;
3. contrato/jurídico sensível/governança.

Se não disparar, deve ir para Empresa.

## 3.7 Privacidade

Default invertido em relação à Empresa:

- Diretoria = **privado por padrão**.
- `inbox/{diretor}/privado/` é gitignored.
- Só conteúdo explicitamente compartilhável com a diretoria sai do privado.

## 3.8 Branch protection obrigatória

Antes do primeiro uso real, configurar no GitHub:

- Require pull request before merging.
- Require approvals: mínimo 1.
- Require review from Code Owners.
- Dismiss stale approvals.
- Restrict who can push to `main`.
- Opcional: require linear history.

Sem isso, a política de revisão humana obrigatória fica apenas verbal.

## 3.9 Requisitos funcionais

### RF-D01 — Inicialização segura

Substituir placeholders, criar agente Diretoria, remover estado de template.

### RF-D02 — Branch staging

Criar branch `staging` para capturas e consolidação.

### RF-D03 — Branch protection

Proteger `main` antes da operação real.

### RF-D04 — Estação Adriana

Criar `inbox/adriana/` com política default privado.

### RF-D05 — Consolidação via PR

Toda consolidação deve abrir PR. Nenhum conteúdo entra direto em `main`.

### RF-D06 — Canal privado de alerta

Notificações da diretoria devem ir para canal privado, nunca para grupo geral.

### RF-D07 — Backup seguro

Configurar backup encriptado offsite semanal.

## 3.10 Requisitos não funcionais

- VPS separado recomendado.
- Repo privado obrigatório.
- Acesso restrito a sócios/diretoria.
- Sem compartilhamento automático com Empresa.
- Contratos assinados ficam em storage encriptado, com referência no Git.
- Conflitos param a rotina.
- Conteúdo privado nunca é processado pela consolidação.

## 3.11 Fases de implementação

### Fase D0 — Checklist de maturidade

O template recomenda abrir Diretoria apenas depois de:

- Empresa rodando idealmente há 60+ dias;
- time com estações funcionais;
- consolidação noturna estável;
- primeiro caso real de gatilho sensível.

**Adaptação para Adriana:** como já existem demandas financeiras, jurídicas e de governança, é aceitável preparar a estrutura agora, mas operar com cuidado e sem convidar time geral.

### Fase D1 — Fork e clone

1. Criar repo privado na organização.
2. Nome sugerido: `grupo-vab-diretoria`.
3. Clonar ao lado dos outros cérebros.
4. Criar branch `staging`.

### Fase D2 — Branch protection

Configurar proteção de `main` antes de capturas reais.

### Fase D3 — Inicialização

1. Rodar `inicializar-cerebro`.
2. Preencher placeholders:

| campo | valor sugerido |
|---|---|
| Empresa | Grupo VAB / Holding Adriana Bessa *(confirmar)* |
| Empresa slug | `grupo-vab` |
| Agente diretoria | sugestão: `Guardião`, `Nora`, `Diretoria` *(confirmar tom desejado)* |
| Agente slug | `geral-diretoria` ou nome escolhido |
| Fundadora | Adriana Bessa |
| Fundadora slug | `adriana` |

3. Validar placeholders.
4. Commit inicial em `staging`.

### Fase D4 — Estação da Adriana

1. Rodar `setup-estacao-pessoal`.
2. Criar `inbox/adriana/`.
3. Validar `privado/` gitignored.
4. Criar captura sensível fictícia.

### Fase D5 — Agente gestor Diretoria

1. Definir VPS dedicado.
2. Rodar `setup-agente-openclaw`.
3. Configurar canal privado de notificação.
4. Configurar backup encriptado.
5. Registrar rotinas.

### Fase D6 — Consolidação PR-only

1. Rodar `consolidar-estacoes` manualmente com captura teste.
2. Validar criação de branch `consolidacao/YYYY-MM-DD`.
3. Validar PR criado.
4. Validar que `main` não recebeu commit direto.
5. Validar digest.

### Fase D7 — Onboarding de diretores

1. Rodar `onboarding-diretor` para cada diretor.
2. Criar estação individual.
3. Reforçar regra dos 3 gatilhos.
4. Reforçar default privado.

## 3.12 Riscos

| risco | mitigação |
|---|---|
| Informação sensível vazar para Empresa | regra de pertencimento + `/team-sync` explícito |
| Main sem proteção | branch protection obrigatória antes da operação |
| Promoção direta indevida | consolidar-estacoes da Diretoria sempre PR-only |
| VPS compartilhado expor dados | VPS dedicado recomendado |
| Contratos no Git | armazenar fora, registrar apenas referência e resumo |

## 3.13 Definition of Done — Diretoria

- [ ] Repo privado criado.
- [ ] Branch `staging` criada.
- [ ] Branch protection ativa em `main`.
- [ ] `inicializar-cerebro` executada.
- [ ] Placeholders removidos.
- [ ] `inbox/adriana/` criada.
- [ ] Política `privado/` validada.
- [ ] Agente Diretoria configurado em VPS dedicado ou workspace isolado.
- [ ] Canal privado configurado.
- [ ] Backup encriptado definido.
- [ ] Consolidação teste abriu PR.
- [ ] Nenhum commit direto em `main`.
- [ ] Log atualizado.

---

# 4. Plano Integrado de Implementação

## Ordem recomendada

### Etapa 1 — Pessoal

Motivo: Ada/Adriana precisa ser a fonte individual e a ponte para os coletivos.

Entregáveis:

- cérebro pessoal inicializado;
- Ada configurada;
- `/save` funcional;
- daily note funcional.

### Etapa 2 — Empresa

Motivo: é o cérebro coletivo operacional e base para o time.

Entregáveis:

- staging/main;
- inbox/adriana;
- agente empresa;
- consolidação noturna;
- primeiro digest.

### Etapa 3 — Diretoria

Motivo: maior sensibilidade; precisa de regras já maduras.

Entregáveis:

- branch protection;
- inbox/adriana privado;
- agente diretoria;
- PR-only validado.

## 4.1 Dependências entre cérebros

| dependência | descrição |
|---|---|
| Pessoal → Empresa | `/team-sync` manda conteúdo operacional para `inbox/adriana` |
| Pessoal → Diretoria | `/team-sync` manda conteúdo sensível para `inbox/adriana` |
| Empresa ↔ Diretoria | disjuntos; ponte humana/diretor, nunca sync automático livre |
| Diretoria → Empresa | somente conteúdo explicitamente sanitizado pode virar proposta operacional |

## 4.2 Roadmap sugerido

| semana | foco | entregáveis |
|---|---|---|
| Semana 1 | Pessoal | inicialização, Ada, `/save`, primeira captura |
| Semana 2 | Empresa | staging, estação Adriana, agente gestor, consolidação teste |
| Semana 3 | Empresa com time piloto | onboarding 2–3 pessoas, primeira rotina real |
| Semana 4 | Diretoria | branch protection, estação Adriana, PR-only teste |
| Semana 5 | Integração | `/team-sync` ponta a ponta e ajustes |

## 4.3 Decisões pendentes

Antes da execução, Adriana precisa confirmar:

1. Nome/slug oficial da empresa para os repos.
2. Se os repos serão no GitHub pessoal ou organização.
3. Nome do agente gestor da Empresa.
4. Nome do agente gestor da Diretoria.
5. Se haverá VPS separado para Diretoria.
6. Quem terá acesso inicial ao cérebro Diretoria.
7. Canal privado de alertas da Diretoria.

## 4.4 Critério de sucesso global

O sistema estará implementado quando:

- Adriana conseguir capturar no cérebro pessoal via `/save`.
- Adriana conseguir enviar uma nota operacional para Empresa via `/team-sync`.
- Adriana conseguir enviar uma nota sensível para Diretoria via `/team-sync`.
- Empresa consolidar captura teste para canônico.
- Diretoria abrir PR de consolidação sem commit direto em `main`.
- Logs e digests forem gerados nos locais corretos.

---

# 5. Checklists Operacionais

## 5.1 Checklist Pessoal

- [ ] Confirmar nome final do repo.
- [ ] Criar/forkar repo privado.
- [ ] Rodar `inicializar-cerebro`.
- [ ] Configurar Ada.
- [ ] Validar placeholders.
- [ ] Rodar `/save`.
- [ ] Validar daily note.
- [ ] Testar `cerebro`.
- [ ] Testar `/team-sync`.

## 5.2 Checklist Empresa

- [ ] Confirmar escopo: Grupo VAB, Lojão, Pagmoda ou holding.
- [ ] Criar/forkar repo privado.
- [ ] Criar `staging`.
- [ ] Rodar `inicializar-cerebro`.
- [ ] Criar `inbox/adriana`.
- [ ] Criar captura teste + sidecar.
- [ ] Configurar agente gestor.
- [ ] Rodar consolidação manual.
- [ ] Validar digest.
- [ ] Registrar cron.
- [ ] Planejar onboarding do time.

## 5.3 Checklist Diretoria

- [ ] Confirmar lista de diretores/sócios.
- [ ] Criar/forkar repo privado.
- [ ] Criar `staging`.
- [ ] Configurar branch protection.
- [ ] Rodar `inicializar-cerebro`.
- [ ] Criar `inbox/adriana`.
- [ ] Validar `privado/`.
- [ ] Configurar agente gestor em VPS isolado.
- [ ] Configurar canal privado.
- [ ] Rodar consolidação manual.
- [ ] Validar PR-only.
- [ ] Configurar backup encriptado.

---

# 6. Observações finais

Os três templates estão bem estruturados, mas ainda estão em estado de template. A implantação real não deve começar editando arquivos soltos manualmente; deve seguir as skills existentes, porque elas foram desenhadas para preservar a governança:

1. `inicializar-cerebro` para transformar template em repo real.
2. `setup-estacao-pessoal` para criar estações/inboxes.
3. `setup-agente-openclaw` para agentes gestores.
4. `save` para capturas.
5. `team-sync` para distribuição entre cérebros.
6. `consolidar-estacoes` para rotina noturna.

A ordem correta é: **Pessoal primeiro, Empresa segundo, Diretoria terceiro**.
