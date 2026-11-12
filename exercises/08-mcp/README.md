# Exercício 08 - MCP

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Dar ao Claude acesso a um sistema externo através de MCP e usá-lo para diagnosticar um bug que não se vê no código.

## Ponto de partida

A tag `ex08-start`: o resultado do exercício 7 e a base de dados com dados já carregados em `data/workshop.db` (`make seed` regenera-a a partir de `scripts/seed.py`). A suite está toda verde. Mesmo assim, chegou este bug report dos organizadores:

> O evento 4 (Hackathon NEI, 25 lugares) mostra `available_seats: -2` em `GET /events/4`. A inscrição recusa toda a gente com 409 "event is full", mas na lista de inscritos há pessoas repetidas. Nos outros eventos está tudo bem.

## Tarefa

Liga o Claude Code à base de dados e descobre porque é que o evento 4 fica com lugares negativos só com estes dados. Corrige a causa, não o sintoma: um `max(0, ...)` no handler esconde o problema e deixa as repetições na base de dados.

## Critério de sucesso

A causa está identificada com evidência vinda dos dados, a correção está feita com um teste que a cobre, e `make seed` deixa de reproduzir o problema.

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
      "args": ["mcp-sqlite", "data/workshop.db"]
    }
  }
}
```

O equivalente na linha de comandos é `claude mcp add --scope project workshop-db -- uvx mcp-sqlite data/workshop.db`. Reinicia a sessão e confirma com `/mcp` que está ligado e que aparecem `sqlite_get_catalog` e `sqlite_execute`.

</details>

<details>
<summary>Dica 3</summary>

Pede ao Claude que reproduza o caminho de `GET /events/4` com queries reais à base de dados e compare o que encontra com o que o código assume. Conta inscrições por evento, depois agrupa participantes por email com e sem `lower(trim(email))`. A diferença é o bug.

</details>

## Desafio extra

Restringe o servidor MCP a leitura e verifica que uma tentativa de `UPDATE` é recusada. O `mcp-sqlite` não tem flag para isso; há duas vias: negar a ferramenta de SQL livre nas permissões do projeto (`"deny": ["mcp__workshop-db__sqlite_execute"]` em `.claude/settings.json`) e expor só queries predefinidas através de um ficheiro de metadata (`uvx mcp-sqlite data/workshop.db -m queries.yml`), ou apontar o servidor para uma cópia da base de dados só de leitura no sistema de ficheiros.

## Pergunta de debrief

Que hipótese o Claude te deu antes de ter acesso aos dados, e quão longe estava da causa real?
