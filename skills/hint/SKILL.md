---
name: hint
description: Dá a dica mais pequena que desbloqueia o estudante no ponto em que está no exercício atual
argument-hint: "[NN] [k]"
disable-model-invocation: true
allowed-tools: Read Glob Bash(git describe *) Bash(git status *) Bash(git diff *) Bash(make test)
---

Dá uma dica ao estudante: a mais pequena que o desbloqueia, nem mais nem menos.

1. Exercício. NN é `$0` se foi dado (dois dígitos; acrescenta um zero à esquerda se vier com um). Senão, `git describe --tags --match 'ex*-start' --abbrev=0` dá a tag de partida mais próxima. Se não houver tag, pergunta qual é o exercício e para.
2. Situação. Corre `git status --porcelain`, `git diff exNN-start --stat` e `make test`. Junta o que a conversa já mostra: o que o estudante tentou, o que falhou, que dicas já recebeu nesta sessão.
3. Lê o enunciado, o único ficheiro que corresponde a `${CLAUDE_PLUGIN_ROOT}/exercises/NN-*/README.md`: "Tarefa", "Critério de sucesso" e "Dicas".
4. Nível. Se `$1` foi dado, é esse. Senão, escolhe a dica de nível mais baixo que responde ao bloqueio observado; se essa já foi dada nesta sessão, a seguinte. Sem alterações no repositório e sem tentativas na conversa, é sempre a dica 1.
5. Resposta: uma frase a dizer o que observaste (exercício, estado dos testes, o que parece estar a travar) e depois o texto da dica escolhida, transcrito sem alterações nem comentários. Nada mais.

Nunca mostres as outras dicas nem o desafio extra. Nunca faças a tarefa nem escrevas o prompt pelo estudante. Se todas as dicas já foram dadas e o bloqueio continua, diz isso e sugere chamar o formador.
