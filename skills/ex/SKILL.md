---
name: ex
description: Vai buscar as tags, coloca o repositório no ponto de partida do exercício NN, corre os testes e mostra o link do enunciado
argument-hint: <NN>
arguments: [exercise]
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh *) Bash(git fetch --tags) Bash(git rev-parse *) Bash(git status *) Bash(git checkout *) Bash(git config --local workshop.exercise *) Bash(make test)
---

Exercício pedido:

!`${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh $exercise`

Prepara este exercício, onde NN é o número em `exercise`. Se `exercise` for `unknown`, diz ao estudante que corra `/ex NN` com o número do exercício e para aqui.

Corre cada comando sozinho e exatamente como está escrito, sem pipes, sem encadear comandos e sem redirecionamentos.

1. Corre `git fetch --tags`: as tags de cada exercício são publicadas ao longo do workshop. Se `git rev-parse --verify --quiet refs/tags/exNN-start` não encontrar a tag, diz que o exercício NN ainda não abriu e para aqui.
2. Corre `git status --porcelain`. Se houver saída, mostra as alterações por guardar, diz ao estudante que as guarde com `git stash` ou faça commit delas e volte a correr `/ex NN`, e para aqui, sem esperar resposta.
3. Corre `git checkout exNN-start` e depois `git config --local workshop.exercise NN`, para que `/hint` e `/debrief` saibam em que exercício o estudante está.
4. Corre `make test` e resume numa linha quantos testes passaram e quais falharam.
5. Termina com o `link` do enunciado acima e nada mais: não resumas nem comentes o exercício.
