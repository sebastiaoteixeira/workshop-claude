# Exercício 00 - Setup

## Objetivo

Aprendes a pôr a app do workshop e o Claude Code a funcionar, e a distinguir os testes que falham de propósito das falhas do teu ambiente.

## Ponto de partida

Este é o único exercício que não começa com `/ex`: o plugin do workshop ainda não está instalado. Precisas de ter o Claude Code, o `git` e o [`uv`](https://docs.astral.sh/uv/) (gestor de pacotes e ambientes Python) instalados.

A app alvo é a aplicação em que trabalhas em todos os exercícios. Vive no repositório [`workshop-claude-app`](https://github.com/sebastiaoteixeira/workshop-claude-app), separado deste repositório de enunciados. É uma API de inscrições em eventos do NEI, feita com FastAPI e SQLite.

Neste exercício usas a tag `ex00-start` (nome fixo para um commit) da app alvo. Nessa tag:

- o código da API está em `app/`, com as rotas em `app/routes/` e as queries SQL em `app/repositories/`;
- os testes estão em `tests/`;
- há uma base de dados de exemplo em `data/workshop.db`;
- não há `CLAUDE.md` (ficheiro de instruções que o Claude lê no início de cada sessão);
- `.claude/settings.json` (configuração do Claude Code para este projeto) só define o modelo que o Claude usa;
- três testes falham de propósito: são o material dos exercícios seguintes.

Depois de clonar, as dependências ainda não estão instaladas.

## Tarefa

1. Clona a app alvo e entra no diretório:

   ```bash
   git clone https://github.com/sebastiaoteixeira/workshop-claude-app.git
   cd workshop-claude-app
   ```

2. Corre `uv sync`. Cria o ambiente virtual e instala todas as dependências, incluindo as de desenvolvimento.
3. Abre o Claude Code dentro de `workshop-claude-app/` e autentica-te. Escolhe um dos caminhos:
   - conta Claude Pro ou Max: corre `claude` e segue o login no browser;
   - chave de API: exporta `ANTHROPIC_API_KEY` e só depois corre `claude`.
4. Na sessão, corre `/doctor` (diagnóstico do Claude Code). Confirma que a instalação e a autenticação estão boas.
5. Sai da sessão com `/exit`. No terminal, instala o plugin do workshop, `nei-workshop` (pacote de comandos extra para o Claude Code). Vive no repositório destes enunciados, que é também um marketplace (catálogo de plugins):

   ```bash
   claude plugin marketplace add sebastiaoteixeira/workshop-claude
   claude plugin install nei-workshop@workshop-claude
   ```

6. Abre outra vez `claude` dentro de `workshop-claude-app/`.
7. Na sessão, corre `/ex 00`. O nome completo é `/nei-workshop:ex 00`: usa-o se outro comando já se chamar `/ex`. O mesmo vale para `/hint` e `/debrief`. O comando vai buscar as tags, faz o checkout de `ex00-start`, corre os testes e mostra o link deste enunciado. A partir daqui tens também:
   - `/hint`, que dá a dica mais pequena que te desbloqueia; `/hint NN k` pede a dica `k` do exercício `NN`;
   - `/debrief`, que faz a pergunta final do exercício.
8. Pede ao Claude que corra a suite de testes e te diga que testes falham.
9. Compara a lista do Claude com a do Critério de sucesso. Se houver outras falhas, corrige o teu ambiente antes de continuar.
10. Corre `make lint` (verifica o estilo do código com `ruff`).

## Critério de sucesso

- `make test` (equivale a `uv run pytest -q`) corre do princípio ao fim e termina com `3 failed, 11 passed`.
- Os testes falhados são exatamente estes três:
  - `tests/test_events.py::test_list_events_second_page`
  - `tests/test_events.py::test_get_event_includes_available_seats`
  - `tests/test_registrations.py::test_cancel_registration_frees_capacity`
- `make lint` termina sem erros: `All checks passed!` e nenhum ficheiro por formatar.

## Dicas

<details>
<summary>Dica 1</summary>

Abre o Claude Code dentro do diretório do repositório. Tudo o que ele sabe sobre o projeto vem do diretório onde é lançado.

</details>

<details>
<summary>Dica 2</summary>

Não precisas de saber como se corre a suite neste projeto. Pede ao Claude que descubra e corra. Ele lê o `Makefile` e o `pyproject.toml` por ti.

</details>

<details>
<summary>Dica 3</summary>

Pede uma lista dos testes falhados com uma linha de explicação cada e compara com a lista esperada. Se houver diferenças, o problema está no teu ambiente, não no código.

</details>

## Desafio extra

Descobre com `/cost` e `/context` quanto contexto a sessão já gastou só a fazer setup. Anota o número: vais voltar a ele no exercício 3.

## Pergunta de debrief

Que informação tiveste de descobrir sozinho que gostarias que o Claude já soubesse ao abrir o projeto?
