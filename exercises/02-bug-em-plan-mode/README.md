# Exercício 02 - Bug em plan mode

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Corrigir um bug sem deixar o Claude tocar no código antes de teres lido, criticado e corrigido o plano dele.

## Ponto de partida

A tag `ex02-start`: um dos testes que falhava no exercício 0, `tests/test_events.py::test_list_events_second_page`, aponta para um bug real. O sintoma também se vê na base de dados de exemplo: com a app a correr (`make run`), `GET /events` devolve `total: 6` mas `items: []`, e `GET /events?page=2&page_size=2` devolve os eventos 5 e 6 em vez do 3 e do 4.

## Tarefa

Faz o teste passar. Antes de aprovar qualquer alteração, obtém um plano, encontra nele pelo menos um ponto errado ou desnecessário, corrige-o e só depois deixa o Claude executar.

## Critério de sucesso

O teste passa e nenhum outro teste que passava antes deixou de passar.

## Dicas

<details>
<summary>Dica 1</summary>

O Claude Code tem um modo em que só lê e propõe, sem editar. Começa por aí.

</details>

<details>
<summary>Dica 2</summary>

Entra em plan mode com `Shift+Tab` (ou `claude --permission-mode plan`). O plano que aparece é um documento que podes recusar e mandar refazer.

</details>

<details>
<summary>Dica 3</summary>

O primeiro plano tende a corrigir o sintoma onde o teste falha, não a causa. Pergunta onde o valor errado é produzido e exige que o plano mude isso.

</details>

## Desafio extra

Pede ao Claude que explique porque é que o bug não foi apanhado antes e que proponha um teste que o teria apanhado.

## Pergunta de debrief

O que havia no primeiro plano que terias aceitado se não tivesses sido obrigado a encontrar um erro nele?
