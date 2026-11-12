---
name: debrief
description: Mostra a pergunta de debrief do exercício atual e pede ao estudante uma resposta em três linhas
argument-hint: "[NN]"
arguments: [exercise]
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh *) Read
---

Exercício atual:

!`${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh $exercise`

Se `exercise` for `unknown`, pergunta qual é o exercício e para aqui.

Lê o enunciado, o ficheiro em `readme`, e transcreve, sem alterações, o conteúdo da secção "Pergunta de debrief". Pede ao estudante que responda em três linhas no máximo e para: não respondas tu.

Quando a resposta chegar, não uses ferramentas: comenta-a em exatamente duas frases, destacando o que ficou por considerar, e nada mais, sem títulos, listas nem perguntas.
