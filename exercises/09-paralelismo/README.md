# Exercício 09 - Paralelismo

## Objetivo

Aprendes a pôr duas sessões do Claude Code a trabalhar ao mesmo tempo sem pisarem os ficheiros uma da outra.

## Ponto de partida

Corre `/ex 09`. O código é a solução de referência do exercício 8. O teu trabalho anterior não está aqui. A suite está toda verde. As duas features abaixo ainda não existem.

`/ex` deixa o repositório em `detached HEAD` (sem branch). Cria já o branch base, onde vais fazer os `merges` (juntar um branch noutro) no fim:

```bash
git switch -c ex09
```

As rotas HTTP vivem em `app/routes/`. Todo o SQL vive em `app/repositories/`. Os modelos das respostas vivem em `app/schemas.py`. Cada router novo é registado em `app/main.py`.

## Especificação: feature A, exportar inscrições em CSV

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

- Rota nova: `GET /events/{id}/registrations.csv`.
- Responde 200 com `Content-Type: text/csv`.
- A primeira linha é o cabeçalho `name,email,created_at`.
- Cada linha seguinte é uma inscrição do evento.
- As linhas vêm pela mesma ordem de `GET /events/{id}/registrations`.
- A coluna `created_at` usa o mesmo formato do campo `created_at` de `GET /events/{id}/registrations`.
- Se o evento não existe, responde 404.
- É a única rota da API que não responde JSON.
- As queries SQL ficam em `app/repositories/`, como no resto da app. A rota só converte o resultado para CSV.

Formato esperado:

```csv
name,email,created_at
Ana Martins,ana.martins@ua.pt,<created_at, como em GET /events/{id}/registrations>
Bruno Silva,bruno.silva@ua.pt,<created_at, como em GET /events/{id}/registrations>
```

## Especificação: feature B, health check

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

O monitor dos servidores do NEI vai usar esta rota para confirmar que a API responde e que a base de dados está acessível.

- Rota nova: `GET /health`.
- Responde 200 com o JSON abaixo.
- `events`, `participants` e `registrations` são o número de linhas de cada uma dessas tabelas.
- Não há caso de erro a especificar: se a base de dados estiver inacessível, o erro 500 do FastAPI chega para o monitor.

Formato esperado:

```json
{"status": "ok", "events": 3, "participants": 12, "registrations": 20}
```

## Tarefa

1. Corre `git switch -c ex09`, se ainda não o fizeste.
2. Cria dois `worktrees` (pastas de trabalho extra ligadas ao mesmo repositório git), cada um no seu branch a partir de `ex09`: `feat/export-csv` para a feature A e `feat/health` para a feature B. Depois corre `uv sync` em cada um, porque o `.venv` não vai com o worktree:

   ```bash
   git worktree add ../nei-export-csv -b feat/export-csv
   git worktree add ../nei-health -b feat/health
   (cd ../nei-export-csv && uv sync)
   (cd ../nei-health && uv sync)
   ```

3. Abre uma sessão do Claude Code em cada worktree, por exemplo `cd ../nei-export-csv && claude`.
4. Na sessão de `feat/export-csv`, pede ao Claude que implemente a feature A. Na sessão de `feat/health`, pede ao Claude que implemente a feature B. As duas sessões trabalham ao mesmo tempo.
5. Em cada worktree, revê o trabalho do Claude e faz commit no branch respetivo.
6. No diretório original, ainda no branch `ex09`, corre `git merge feat/export-csv`.
7. No worktree de `feat/health`, corre `git rebase ex09` (reaplica os commits do branch por cima do `ex09`, que já tem a feature A).
8. No diretório original, corre `git merge feat/health`.

## Critério de sucesso

- `git rebase ex09`, no worktree de `feat/health`, termina sem conflitos.
- `git merge feat/export-csv` e `git merge feat/health` são `fast-forward` (o branch `ex09` só avança, sem commit de merge).
- `make test` passa no branch `ex09` depois do segundo merge.

## Dicas

<details>
<summary>Dica 1</summary>

Duas sessões no mesmo diretório editam os mesmos ficheiros. As edições de uma estragam o trabalho da outra. Precisas de dois diretórios com o mesmo repositório.

</details>

<details>
<summary>Dica 2</summary>

Cada worktree partilha o mesmo `.git`. O `CLAUDE.md`, o `.claude/settings.json` com os hooks e o `.mcp.json` vão com o repositório, por isso as duas sessões seguem as mesmas regras.

`git worktree list` mostra os dois. `git worktree remove` apaga-os no fim.

</details>

<details>
<summary>Dica 3</summary>

Antes de lançar as sessões, lista os ficheiros que cada feature vai querer mudar: rota, repositório, `app/schemas.py`, `app/main.py`. Os ficheiros que aparecem nas duas listas são onde nasce um conflito.

A ordem dos passos 6 a 8 (merge do primeiro, `rebase` do segundo sobre o resultado, merge do segundo) apanha qualquer conflito no `rebase`, dentro do worktree, e não no `ex09`.

</details>

## Desafio extra

1. Repete o exercício com a flag `--worktree` do Claude Code em vez de criares os worktrees à mão. `claude --worktree export-csv` cria `.claude/worktrees/export-csv` num branch próprio. Acrescenta `.claude/worktrees/` ao `.gitignore`. Compara os dois fluxos.
2. Lança uma terceira feature que entra em conflito de propósito com a A: `GET /events.csv`, a exportação da lista de eventos em CSV. Esta feature vai querer extrair a escrita de CSV para uma função partilhada, que a A também toca. Resolve o conflito no `rebase`.

## Pergunta de debrief

Que decisão tiveste de tomar antes de lançar as duas sessões para que o merge corresse bem, e terias pensado nela sem este exercício?
