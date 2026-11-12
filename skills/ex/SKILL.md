---
name: ex
description: Vai buscar as tags, coloca o repositório no ponto de partida do exercício NN, corre os testes e mostra o link do enunciado
argument-hint: <NN>
disable-model-invocation: true
allowed-tools: Glob Bash(git fetch --tags) Bash(git rev-parse *) Bash(git status *) Bash(git checkout *) Bash(make test)
---

Prepara o exercício NN, onde NN é `$0` com dois dígitos (acrescenta um zero à esquerda se vier com um só).

1. Corre `git fetch --tags`: as tags de cada exercício são publicadas ao longo do workshop. Se `git rev-parse --verify --quiet refs/tags/exNN-start` não encontrar a tag, diz que o exercício NN ainda não abriu e para aqui.
2. Corre `git status --porcelain`. Se houver saída, avisa que a working tree tem alterações por guardar, mostra-as e para aqui: só avanças depois de o estudante dizer o que fazer com elas.
3. Corre `git checkout exNN-start`.
4. Corre `make test` e resume numa linha quantos testes passaram e quais falharam.
5. Procura o único diretório que corresponde a `${CLAUDE_PLUGIN_ROOT}/exercises/NN-*/README.md` e termina com o link do enunciado, `https://github.com/sebastiaoteixeira/workshop-claude/blob/main/exercises/<diretório>/README.md`, e nada mais: não resumas nem comentes o exercício.
