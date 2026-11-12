# Exercício 06 - Subagent de revisão

## Objetivo

Aprendes a usar um revisor independente, com contexto limpo e sem poder de escrita, sobre código que os testes verdes fazem parecer pronto.

## Ponto de partida

Corre `/ex 06`. O código é a solução de referência do exercício 5. O teu trabalho anterior não está aqui.

A lista de espera do exercício 4 está em `app/routes/waitlist.py` e `app/repositories/waitlist.py`. É a da solução de referência, não a tua. A [especificação do exercício 4](../04-tdd/README.md#especificação-lista-de-espera) descreve a feature.

A suite está toda verde. Mesmo assim, o código do exercício 4 tem três problemas introduzidos de propósito, que os testes não apanham:

- um de autorização;
- um de desempenho;
- um de validação de input.

Ainda não existe nenhum `subagent` (um assistente separado, com contexto próprio e ferramentas limitadas) em `.claude/agents/`.

## Tarefa

1. Corre `git diff --stat ex03-solution ex04-solution`. Cada exercício tem uma tag `exNN-solution` com a sua solução de referência, por isso este comando lista os ficheiros que o exercício 4 alterou. Anota os ficheiros de `app/`.
2. Define um `subagent` de revisão de código. A definição é um ficheiro em `.claude/agents/`, que escreves tu ou pedes ao Claude que escreva. O prompt do revisor escreves tu: é parte do exercício. O revisor só pode ler ficheiros. Não pode editar, criar ficheiros nem correr comandos. O Claude Code pede autorização antes de escrever dentro de `.claude/`: aprova.
3. Abre uma sessão nova com `claude` e pergunta ao Claude que subagents tem disponíveis. Confirma que o revisor aparece.
4. Pede ao Claude que use o revisor sobre os ficheiros que anotaste no passo 1. O revisor não corre `git diff`, por isso não vê o diff: dá-lhe a lista de ficheiros.
5. Lê o relatório. Não precisas de corrigir os problemas: o exercício é sobre a revisão.

## Critério de sucesso

- Numa sessão nova, o Claude inclui o revisor quando lhe perguntas que subagents tem disponíveis.
- A definição do revisor em `.claude/agents/` não lhe dá ferramentas para editar, criar ficheiros nem correr comandos.
- O relatório aponta pelo menos um dos três problemas introduzidos de propósito, com ficheiro e linha. Abre o ficheiro nessa linha e confirma que o problema está lá.

## Dicas

<details>
<summary>Dica 1</summary>

Um subagent é um ficheiro Markdown com `frontmatter` (o bloco YAML entre `---` no topo do ficheiro). O que o distingue de uma pergunta na conversa principal é o contexto limpo e o conjunto de ferramentas restrito.

</details>

<details>
<summary>Dica 2</summary>

Cria `.claude/agents/reviewer.md` com `tools: Read, Grep, Glob` e `model: haiku`. Sem `Edit`, `Write` nem `Bash`, o revisor não consegue alterar nada por construção, e não precisas de lho proibir por instrução. Como não tem `Bash`, não corre `git diff`: diz-lhe na conversa principal que ficheiros rever. O `/agents` já não lista subagents: para confirmar que foi carregado, pergunta ao Claude numa sessão nova.

</details>

<details>
<summary>Dica 3</summary>

Diz ao revisor o que procurar em concreto (rotas sem autorização, queries dentro de ciclos, inputs não validados) e pede o resultado num formato fixo: uma linha por problema, com `ficheiro:linha`, severidade e a correção sugerida. Revisores sem foco encontram só estilo.

</details>

## Desafio extra

Cria um segundo subagent que só verifica segurança. Corre os dois sobre os mesmos ficheiros e compara o que cada um encontrou.

## Pergunta de debrief

Terias apanhado estes problemas se tivesses aprovado este código no exercício 4 olhando só para os testes verdes? O que é que isso diz sobre a revisão feita no mesmo contexto que escreveu o código?
