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

## Pergunta

Se `exercise` for `unknown`, pergunta qual é o exercício e para aqui.

Lê o enunciado, o ficheiro em `readme`, e transcreve, sem alterações, o conteúdo da secção "Pergunta de debrief". Pede ao estudante que responda em três linhas no máximo e para: não respondas tu.

## Comentário à resposta

Quando o estudante responder, não chames nenhuma ferramenta: já tens o que precisas. Escreve exatamente duas frases, a segunda a destacar o que ficou por considerar. Nada mais: sem terceira frase, títulos, listas nem perguntas.
