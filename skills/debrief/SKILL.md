---
name: debrief
description: Mostra a pergunta de debrief do exercício atual e pede ao estudante uma resposta em três linhas
argument-hint: "[NN]"
disable-model-invocation: true
allowed-tools: Read Glob Bash(git describe *)
---

NN é `$0` se foi dado (dois dígitos; acrescenta um zero à esquerda se vier com um). Senão, `git describe --tags --match 'ex*-start' --abbrev=0` dá a tag de partida mais próxima; se não houver tag, pergunta qual é o exercício e para.

Lê o enunciado, o único ficheiro que corresponde a `${CLAUDE_PLUGIN_ROOT}/exercises/NN-*/README.md`, e transcreve, sem alterações, o conteúdo da secção "Pergunta de debrief".

Pede ao estudante que responda em três linhas no máximo e espera pela resposta. Não respondas tu. Quando a resposta chegar, comenta-a em duas frases, destacando o que ficou por considerar.
