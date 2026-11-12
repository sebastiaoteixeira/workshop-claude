# Exercício 09 - Paralelismo

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Ter duas sessões do Claude Code a trabalhar em features diferentes ao mesmo tempo, sem pisarem os ficheiros uma da outra.

## Ponto de partida

A tag `ex09-start`: o resultado do exercício 8 e duas features independentes por implementar, especificadas abaixo.

### Feature A: exportar inscrições em CSV

`GET /events/{id}/registrations.csv` devolve as inscrições do evento como CSV, com `Content-Type: text/csv`, uma linha de cabeçalho `name,email,created_at` e as inscrições pela mesma ordem de `GET /events/{id}/registrations`. É a única rota da API que não responde JSON; 404 se o evento não existe. O SQL continua a viver no repositório: a rota só muda o formato.

### Feature B: health check

`GET /health` responde 200 com `{"status": "ok", "events": N, "participants": N, "registrations": N}`, onde cada número é a contagem da tabela respetiva. Serve para o monitor dos servidores do NEI confirmar que a API responde e que a base de dados está acessível.

## Tarefa

Implementa as duas features em simultâneo, cada uma no seu branch (`feat/export-csv` e `feat/health`) e no seu diretório de trabalho, com uma sessão do Claude Code em cada um. No fim, faz merge de ambas.

## Critério de sucesso

Os dois branches fazem merge sem conflitos e a suite de testes passa depois do segundo merge.

## Dicas

<details>
<summary>Dica 1</summary>

Duas sessões no mesmo diretório vêem as mesmas edições e corrompem-se mutuamente. Precisas de dois diretórios com o mesmo repositório.

</details>

<details>
<summary>Dica 2</summary>

`git worktree add ../nei-export-csv -b feat/export-csv` cria uma cópia de trabalho ligada ao mesmo `.git`; repete para `../nei-health -b feat/health`. Abre um Claude Code em cada worktree (`cd ../nei-export-csv && claude`). O `CLAUDE.md`, o `.claude/settings.json` com os hooks e o `.mcp.json` vão com o repositório; o `.venv` não, por isso corre `uv sync` em cada um. `git worktree list` mostra os dois; `git worktree remove` limpa-os no fim.

</details>

<details>
<summary>Dica 3</summary>

Se as features tocam num ficheiro comum, decide antes qual branch o altera. Aqui só a feature B toca em `app/main.py` (regista o router novo) e as duas tocam em `app/schemas.py` se a A criar um modelo para a linha do CSV, o que não precisa. Faz merge do primeiro, faz `rebase` do segundo sobre o resultado e só depois o segundo merge.

</details>

## Desafio extra

Repete com a flag `--worktree` do Claude Code em vez de criares os worktrees à mão (`claude --worktree export-csv` cria `.claude/worktrees/export-csv` num branch próprio; acrescenta `.claude/worktrees/` ao `.gitignore`) e compara o fluxo. Depois lança uma terceira feature que conflitua de propósito com a A: `GET /events.csv`, a exportação da lista de eventos, que vai querer extrair a escrita de CSV para uma função partilhada que a A também toca. Resolve o conflito no rebase.

## Pergunta de debrief

Que decisão tiveste de tomar antes de lançar as duas sessões para que o merge corresse bem? Terias tomado essa decisão sem este exercício?
