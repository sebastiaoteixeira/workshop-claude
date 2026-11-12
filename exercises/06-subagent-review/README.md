# Exercício 06 - Subagent de revisão

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Criar um revisor independente, com contexto limpo e sem poder de escrita, e usá-lo sobre código que já consideravas pronto.

## Ponto de partida

A tag `ex06-start`: o resultado do exercício 5. A lista de espera do exercício 4 passa todos os testes, mas a [especificação do exercício 4](../04-tdd/README.md#especificação-lista-de-espera) pede mais do que os testes cobrem, e a implementação ficou com problemas que ninguém apanhou: de autorização, de desempenho e de validação de input. Os ficheiros em causa são os que o exercício 4 tocou: `git diff --stat ex03-solution ex04-solution` lista-os.

## Tarefa

Define um subagent de revisão de código que só pode ler, nunca editar nem executar comandos que alterem estado. Aplica-o ao diff do exercício 4.

## Critério de sucesso

O revisor encontra pelo menos um dos problemas plantados e reporta-o com ficheiro e linha.

## Dicas

<details>
<summary>Dica 1</summary>

Um subagent é um ficheiro Markdown com frontmatter. O que o distingue de uma pergunta na conversa principal é o contexto limpo e o conjunto de ferramentas restrito.

</details>

<details>
<summary>Dica 2</summary>

Cria `.claude/agents/reviewer.md` com `tools: Read, Grep, Glob` e `model: haiku`. Sem `Edit`, `Write` nem `Bash`, o revisor não consegue alterar nada por construção, e não precisas de lho proibir por instrução. Como não tem `Bash`, não corre `git diff`: diz-lhe na conversa principal que ficheiros rever. Usa `/agents` para verificar que foi carregado.

</details>

<details>
<summary>Dica 3</summary>

Diz ao revisor o que procurar em concreto (rotas sem autorização, queries dentro de ciclos, inputs não validados) e pede o resultado num formato fixo: uma linha por problema, com `ficheiro:linha`, severidade e a correção sugerida. Revisores sem foco encontram só estilo.

</details>

## Desafio extra

Cria um segundo subagent que só verifica segurança e compara o que cada um encontrou no mesmo diff.

## Pergunta de debrief

O revisor encontrou algo que tu, ao aprovar o diff no exercício 4, deixaste passar? O que é que isso diz sobre a revisão feita no mesmo contexto que escreveu o código?
