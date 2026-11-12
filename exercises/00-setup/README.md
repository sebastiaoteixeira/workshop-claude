# Exercício 00 - Setup

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Ter o repositório da app alvo a correr localmente, o Claude Code autenticado e a suite de testes a correr, sabendo exatamente que testes falham e porquê.

## Ponto de partida

A tag `ex00-start` do repositório da app alvo, [`workshop-claude-app`](https://github.com/sebastiaoteixeira/workshop-claude-app): acabado de clonar, sem `CLAUDE.md`, sem dependências instaladas e com `.claude/settings.json` a fixar apenas o modelo. A app alvo é uma API de inscrições em eventos do NEI (FastAPI + SQLite) em `app/`, com testes em `tests/` e uma base de dados de exemplo em `data/workshop.db`.

## Tarefa

1. Clona a app alvo (`git clone https://github.com/sebastiaoteixeira/workshop-claude-app.git`), entra no diretório e instala as dependências. O projeto usa [`uv`](https://docs.astral.sh/uv/): `uv sync` cria o ambiente e instala tudo, incluindo as dependências de desenvolvimento.
2. Autentica o Claude Code. Há dois caminhos, escolhe um:
   - conta Claude Pro ou Max: corre `claude` e segue o login no browser;
   - chave de API: exporta `ANTHROPIC_API_KEY` antes de correr `claude`.
   Em ambos os casos, `/doctor` dentro da sessão confirma que a instalação e a autenticação estão boas.
3. Instala o plugin do workshop, `nei-workshop`. Vive no repositório deste enunciado, que é também um marketplace:

   ```bash
   claude plugin marketplace add sebastiaoteixeira/workshop-claude
   claude plugin install nei-workshop@workshop-claude
   ```

   Numa sessão aberta na app alvo, `/nei-workshop:ex 00` (ou apenas `/ex 00`) vai buscar as tags, faz o checkout de `ex00-start`, corre os testes e mostra o link deste enunciado. `/hint` dá a dica mais pequena que te desbloqueia (`/hint NN k` pede a dica `k`) e `/debrief` faz a pergunta final.
4. Corre a suite de testes: `make test` (equivale a `uv run pytest -q`). Alguns testes falham de propósito: são o material dos exercícios seguintes. Identifica quais são e confirma que não falha mais nenhum.

## Critério de sucesso

A suite corre do princípio ao fim, `make lint` não acusa nada, e os testes falhados são exatamente estes três:

- `tests/test_events.py::test_list_events_second_page`
- `tests/test_events.py::test_get_event_includes_available_seats`
- `tests/test_registrations.py::test_cancel_registration_frees_capacity`

## Dicas

<details>
<summary>Dica 1</summary>

Abre o Claude Code dentro do diretório do repositório. Tudo o que ele sabe sobre o projeto vem do diretório onde é lançado.

</details>

<details>
<summary>Dica 2</summary>

Não precisas de saber como se corre a suite neste projeto. Pede ao Claude que descubra e corra; ele lê o `Makefile` e o `pyproject.toml` por ti.

</details>

<details>
<summary>Dica 3</summary>

Pede uma lista dos testes falhados com uma linha de explicação cada e compara com a lista esperada. Se houver diferenças, o problema está no teu ambiente, não no código.

</details>

## Desafio extra

Descobre com `/cost` e `/context` quanto contexto a sessão já gastou só a fazer setup. Vais voltar a este número no exercício 3.

## Pergunta de debrief

Que informação tiveste de descobrir sozinho que gostarias que o Claude já soubesse ao abrir o projeto?
