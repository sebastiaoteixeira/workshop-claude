---
name: hint
description: Dá a dica mais pequena que desbloqueia o estudante no ponto em que está no exercício atual
argument-hint: "[NN] [k]"
arguments: [exercise, level]
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh *) Read Bash(git status *) Bash(git diff *) Bash(make test)
---

Exercício atual:

!`${CLAUDE_PLUGIN_ROOT}/scripts/exercise.sh $exercise`

Dá uma dica ao estudante: a mais pequena que o desbloqueia, nem mais nem menos. NN é o número em `exercise`; se `exercise` for `unknown`, pergunta qual é o exercício e para aqui.

Corre cada comando sozinho e exatamente como está escrito, sem pipes, sem encadear comandos e sem redirecionamentos.

1. Situação. Corre `git status --porcelain`, `git diff exNN-start --stat` e `make test`. Junta o que a conversa já mostra: o que o estudante tentou, o que falhou, que dicas já recebeu nesta sessão.
2. Lê o enunciado, o ficheiro em `readme`: "Tarefa", "Critério de sucesso" e "Dicas".
3. Nível. O estudante pediu o nível `$level`. Se não estiver vazio, dá essa dica e não discutes a escolha. Se estiver vazio, escolhe a dica de nível mais baixo que responde ao bloqueio observado; se essa já foi dada nesta sessão, a seguinte. Sem alterações no repositório e sem tentativas na conversa, é a dica 1.
4. Resposta: uma frase a dizer o que observaste (exercício, estado dos testes, o que parece estar a travar) e depois o texto da dica escolhida, transcrito sem alterações nem comentários. Nada mais.

Nunca mostres as outras dicas nem o desafio extra. Nunca faças a tarefa nem escrevas o prompt pelo estudante. Se todas as dicas já foram dadas e o bloqueio continua, diz isso e sugere chamar o formador.
