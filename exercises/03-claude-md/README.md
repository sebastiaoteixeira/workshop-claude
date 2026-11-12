# Exercício 03 - CLAUDE.md

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Dar ao Claude o contexto do projeto uma vez, por escrito, e medir a diferença que isso faz na tarefa seguinte.

## Ponto de partida

A tag `ex03-start`: o repositório sem `CLAUDE.md`, com o bug do exercício 2 corrigido e dois testes ainda a falhar, ambos a pedir uma pequena feature com a mesma forma (uma função nova no repositório, uma alteração numa rota):

- Tarefa A: `tests/test_registrations.py::test_cancel_registration_frees_capacity` pede `DELETE /events/{id}/registrations/{participant_id}`, que responde 204 e liberta o lugar.
- Tarefa B: `tests/test_events.py::test_get_event_includes_available_seats` pede o campo `available_seats` na resposta de `GET /events/{id}`.

## Tarefa

1. Faz a tarefa A sem `CLAUDE.md`. Conta quantas vezes tiveste de corrigir o Claude (SQL no sítio errado, `pytest` chamado à mão, `HTTPException` em vez das classes do projeto, resposta construída como dicionário) e anota o valor de `/context` no fim.
2. Gera um `CLAUDE.md`, lê-o com atenção e corrige-o à mão: remove o que é óbvio, acrescenta o que tiveste de explicar no passo 1 e nos exercícios anteriores (comando de testes, onde vive cada camada, ficheiros a não tocar). O projeto tem cinco convenções que nenhum gerador adivinha; descobre-as a ler `app/` e deixa-as escritas.
3. Numa sessão nova (`/clear`), faz a tarefa B e repete a contagem.

## Critério de sucesso

Na segunda tarefa fizeste menos correções ao Claude e a sessão gastou menos contexto do que no exercício 2.

## Dicas

<details>
<summary>Dica 1</summary>

Há um comando que inspeciona o projeto e escreve um primeiro rascunho do ficheiro de memória.

</details>

<details>
<summary>Dica 2</summary>

Corre `/init`. O resultado é um ponto de partida genérico; o valor está no que acrescentas à mão. Pensa no que tiveste de explicar nos exercícios 0 a 2.

</details>

<details>
<summary>Dica 3</summary>

Regras curtas e verificáveis funcionam melhor do que parágrafos. Usa `/context` no fim da segunda tarefa para medir o contexto gasto e compara com o número que anotaste.

</details>

## Desafio extra

Cria um `~/.claude/CLAUDE.md` pessoal com as tuas preferências de estilo e verifica que elas se aplicam sem contaminar o ficheiro do projeto.

## Pergunta de debrief

Que regra escreveste que tiveste de reescrever porque o Claude a interpretou de forma diferente do que pensavas?
