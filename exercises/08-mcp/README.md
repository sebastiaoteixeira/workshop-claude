# Exercício 08 - MCP

## Objetivo

Aprendes a dar ao Claude acesso a um sistema externo através de MCP (Model Context Protocol, a forma de ligar ferramentas externas ao Claude) e a usá-lo para confirmar nos dados a causa de um bug que o código só sugere.

## Ponto de partida

Corre `/ex 08`. O código é a solução de referência do exercício 7. O teu trabalho anterior não está aqui.

- A base de dados `data/workshop.db` já tem dados carregados.
- `make seed` apaga `data/workshop.db` e gera-a de novo a partir de `scripts/seed.py`.
- A suite está toda verde (`make test`).
- O projeto ainda não tem nenhum servidor MCP configurado: não existe `.mcp.json`.
- O `hook` do exercício 5 (comando que o Claude Code corre sozinho antes de cada edição) está ativo: `scripts/hooks/protect.sh` bloqueia qualquer escrita do Claude em `.env` e em `migrations/`.

Os organizadores reportaram isto:

> O evento 4 (Hackathon NEI, 25 lugares) mostra `available_seats: -2` em `GET /events/4`. A inscrição recusa toda a gente com 409 "event is full", mas na lista de inscritos há pessoas repetidas. Nos outros eventos está tudo bem.

## Tarefa

1. Abre o Claude Code na raiz do projeto. Pede ao Claude uma hipótese para a causa do bug, só a partir do código, sem consultar `data/workshop.db`. Anota a hipótese.
2. Adiciona ao projeto um servidor MCP de SQLite que dê ao Claude acesso a `data/workshop.db`. A configuração fica em `.mcp.json`, na raiz do projeto. Fazes este passo tu, não o Claude.
3. Reinicia o Claude Code. Ao arrancar, ele pede-te que aproves os servidores MCP do projeto: aprova `workshop-db`. Corre `/mcp` e confirma que o servidor aparece ligado. Se aparecer como falhado, corre o comando do servidor num terminal e lê o erro.
4. Leva o Claude a investigar o bug com queries à base de dados através do servidor MCP. Anota as queries que mostram a causa e o resultado de cada uma.
5. Pede ao Claude que corrija a causa em `app/`, com um teste novo em `tests/` que falha sem a correção. Neste passo, um `max(0, ...)` no cálculo de `available_seats` em `app/routes/events.py` não conta: esconde o número negativo e deixa as pessoas repetidas na base de dados.
6. Se a correção precisar de uma migração nova (um ficheiro SQL numerado em `migrations/`), o hook bloqueia o Claude. Pede-lhe o SQL e cria tu o ficheiro com o número seguinte, `migrations/005_<nome>.sql`.
7. Pede ao Claude que ajuste `scripts/seed.py` para que `make seed` deixe de gerar dados com o problema. Corre `make seed`.

## Critério de sucesso

- As tuas notas têm as queries do passo 4 e os resultados delas, e esses resultados mostram a causa.
- `make test` passa e inclui o teste novo do passo 5.
- `git diff app/routes/events.py` não mostra nenhum `max(0, ...)`.
- Depois de `make seed` e `make run`, `curl -s localhost:8000/events/4` mostra `available_seats` maior ou igual a 0.
- `curl -s localhost:8000/events/4/registrations` não mostra a mesma pessoa duas vezes.

## Dicas

<details>
<summary>Dica 1</summary>

O Claude só vê o que as suas ferramentas lhe mostram. Sem acesso aos dados, vai especular a partir do código.

</details>

<details>
<summary>Dica 2</summary>

Adiciona um servidor MCP de SQLite ao `.mcp.json` do projeto. `mcp-sqlite` (PyPI) corre com `uvx`, sem instalação:

```json
{
  "mcpServers": {
    "workshop-db": {
      "command": "uvx",
      "args": ["--with", "mcp<2", "mcp-sqlite", "data/workshop.db"]
    }
  }
}
```

O equivalente na linha de comandos é:

```bash
claude mcp add --scope project workshop-db -- uvx --with "mcp<2" mcp-sqlite data/workshop.db
```

O `--with "mcp<2"` é necessário: o `mcp-sqlite` não arranca com a versão 2 da biblioteca `mcp`.

Reinicia a sessão e confirma com `/mcp` que está ligado e que aparecem as ferramentas `sqlite_get_catalog` e `sqlite_execute`.

</details>

<details>
<summary>Dica 3</summary>

Pede ao Claude que reproduza o caminho de `GET /events/4` com queries reais à base de dados e compare o que encontra com o que o código assume. Conta inscrições por evento. Depois agrupa participantes por email, com e sem `lower(trim(email))`. A diferença é o bug.

</details>

## Desafio extra

O `mcp-sqlite` abre a base de dados só de leitura. Pede ao Claude que mude a capacidade do evento 4 com um `UPDATE` através do servidor MCP. Confirma que é recusado (`attempt to write a readonly database`) e que a capacidade não mudou.

Depois restringe o servidor a queries predefinidas:

- Nega a ferramenta de SQL livre nas permissões do projeto, com `"deny": ["mcp__workshop-db__sqlite_execute"]` em `.claude/settings.json`.
- Expõe só as queries de que o diagnóstico precisa num ficheiro de metadata (YAML com as queries permitidas), passado com `-m queries.yml` no comando do servidor.

## Pergunta de debrief

Que hipótese o Claude te deu antes de ter acesso aos dados, e o que é que as queries confirmaram ou corrigiram nela?
