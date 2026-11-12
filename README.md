# Workshop Claude Code - NEI

Workshop prático de Claude Code para o NEI (Núcleo de Estudantes de Informática, Universidade de Aveiro). Ao longo de doze exercícios vais trabalhar sobre uma única aplicação alvo, uma API de inscrições em eventos (FastAPI + SQLite), e usar o Claude Code para a explorar, corrigir, testar e estender, acabando com um plugin que empacota tudo o que configuraste e que um colega instala no repositório dele.

Criado e dado por Sebastião Teixeira e Vicente Barros.

## Os repositórios

- **[workshop-claude](https://github.com/sebastiaoteixeira/workshop-claude)** (este): os enunciados dos exercícios e o plugin `nei-workshop`, com os comandos `/ex`, `/hint` e `/debrief`. O repositório é também o marketplace de onde o plugin se instala.
- **[workshop-claude-app](https://github.com/sebastiaoteixeira/workshop-claude-app)**: a app alvo. É este que clonas e onde trabalhas.

## Como funciona

Cada exercício começa na solução de referência do anterior, não no teu trabalho: no exercício 4 o Claude lê o `CLAUDE.md` de referência do exercício 3, os hooks de referência do exercício 5 ficam ativos até ao fim, e assim sucessivamente. Assim ninguém fica bloqueado. Cada exercício tem uma tag git na app alvo, `exNN-start`, que marca o estado em que começa. As tags vão sendo publicadas à medida que o grupo avança: `/ex NN` vai buscá-las e, se a do exercício ainda não existir, diz-te que ele ainda não abriu.

Quando um exercício pede uma feature, o enunciado tem uma secção `Especificação` com o comportamento a construir. Não é um prompt: o pedido ao Claude escreves tu, e decidir o que lhe dizer faz parte do exercício.

## Pré-requisitos

- Conta Claude (plano Pro ou Max) ou uma `ANTHROPIC_API_KEY`
- [Claude Code](https://code.claude.com/docs/en/setup)
- [`uv`](https://docs.astral.sh/uv/) (instala o Python 3.12+ se não o tiveres)
- git e `make`

## Setup

1. Clona a app alvo e instala as dependências:

   ```bash
   git clone https://github.com/sebastiaoteixeira/workshop-claude-app.git
   cd workshop-claude-app
   uv sync
   ```

2. Adiciona este repositório como marketplace e instala o plugin do workshop:

   ```bash
   claude plugin marketplace add sebastiaoteixeira/workshop-claude
   claude plugin install nei-workshop@workshop-claude
   ```

3. Abre o Claude Code dentro de `workshop-claude-app` (`claude`) e corre `/ex 00`.

Comandos do plugin, sempre numa sessão aberta na app alvo:

| Comando | O que faz |
|---|---|
| `/ex NN` | Vai buscar as tags, faz checkout de `exNN-start`, corre os testes e mostra o link do enunciado |
| `/hint [NN] [k]` | Dá a dica mais pequena que te desbloqueia, ou a dica `k` |
| `/debrief [NN]` | Faz a pergunta de debrief e comenta a tua resposta |

## Sequência

| Nº | Exercício | Critério de sucesso |
|---|---|---|
| 00 | [Setup](exercises/00-setup/README.md) | A suite de testes corre e os testes que falham são os esperados |
| 01 | [Explorar o código](exercises/01-explorar-codigo/README.md) | Respondes a três perguntas sobre o repositório, com ficheiro e linha |
| 02 | [Bug em plan mode](exercises/02-bug-em-plan-mode/README.md) | O teste passa sem regressões |
| 03 | [CLAUDE.md](exercises/03-claude-md/README.md) | Com o `CLAUDE.md`, uma tarefa semelhante não precisa de mais correções nem de mais contexto |
| 04 | [TDD](exercises/04-tdd/README.md) | Testes verdes sem alterar ficheiros de teste |
| 05 | [Hooks](exercises/05-hooks/README.md) | Uma tentativa de editar `.env` é recusada |
| 06 | [Subagent de revisão](exercises/06-subagent-review/README.md) | O revisor encontra pelo menos um dos problemas introduzidos de propósito |
| 07 | [Skill changelog](exercises/07-skill-changelog/README.md) | Funciona invocada à mão e quando se pede um changelog sem a nomear |
| 08 | [MCP](exercises/08-mcp/README.md) | Causa do bug encontrada nos dados e corrigida |
| 09 | [Paralelismo](exercises/09-paralelismo/README.md) | Duas features feitas em paralelo entram no mesmo branch sem conflitos |
| 10 | [Headless em CI](exercises/10-headless-ci/README.md) | O script falha no commit com um segredo falso e passa nos commits sem segredos |
| 11 | [Plugin](exercises/11-plugin/README.md) | Funciona noutro repositório sem configuração manual |

## Estrutura do repositório

```
.claude-plugin/        Manifesto do plugin nei-workshop e do marketplace workshop-claude
skills/                /ex, /hint e /debrief
scripts/exercise.sh    Resolve o exercício atual e o enunciado para os três comandos
exercises/
  NN-<slug>/README.md  Um enunciado por exercício
presentation/          Apresentação da parte teórica (PDF)
```

## Licença

[MIT](LICENSE)
