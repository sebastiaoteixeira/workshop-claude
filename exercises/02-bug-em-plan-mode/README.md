# Exercício 02 - Bug em plan mode

## Objetivo

Aprendes a rever, criticar e corrigir o plano do Claude antes de ele tocar no código.

## Ponto de partida

Corre `/ex 02`. O código é a solução de referência do exercício 1. O teu trabalho anterior não está aqui.

`make test` falha nos mesmos três testes do exercício 0. Este exercício trata de um deles: `tests/test_events.py::test_list_events_second_page`. Os outros dois ficam para exercícios seguintes.

Este teste aponta para um bug real na paginação de `GET /events`. A rota aceita os parâmetros `page` (começa em 1) e `page_size`. Com a base de dados de exemplo, `data/workshop.db`, que tem 6 eventos:

- `GET /events` devolve `total: 6` mas `items: []`.
- `GET /events?page=2&page_size=2` devolve os eventos 5 e 6, em vez do 3 e do 4.

## Tarefa

1. Confirma o sintoma. Num segundo terminal, corre `make run`. Abre `http://127.0.0.1:8000/events?page=2&page_size=2` no browser, ou corre `curl 'http://127.0.0.1:8000/events?page=2&page_size=2'`. Para o servidor com `Ctrl+C`.
2. Entra em `plan mode` (modo em que o Claude só lê e propõe, sem editar). No terminal do Claude, carrega em `Shift+Tab` até aparecer `plan mode on` no fundo do ecrã.
3. Pede ao Claude um plano para corrigir o bug.
4. Lê o plano. Encontra pelo menos um ponto errado ou desnecessário. Anota-o: vais precisar dele no debrief.
5. Recusa o plano. Diz ao Claude o que está errado e pede-lhe que o refaça. Repete os passos 4 e 5 até concordares com todos os pontos do plano.
6. Aprova o plano. Só a partir daqui o Claude pode editar ficheiros. Não aproves um plano que altere `tests/`.
7. Corre `make test`.

## Critério de sucesso

- `make test` mostra `tests/test_events.py::test_list_events_second_page` a passar.
- `make test` termina com `2 failed, 12 passed`. Os dois que falham são os que já falhavam antes:
  - `tests/test_events.py::test_get_event_includes_available_seats`
  - `tests/test_registrations.py::test_cancel_registration_frees_capacity`
- `git diff -- tests/` não mostra nada: o teste não foi alterado.

## Dicas

<details>
<summary>Dica 1</summary>

O `plan mode` só serve se entrares nele antes do primeiro pedido. Se o Claude já está a editar, é tarde.

</details>

<details>
<summary>Dica 2</summary>

Além de `Shift+Tab`, podes arrancar já em `plan mode` com `claude --permission-mode plan`. O plano que aparece é um documento que podes recusar e mandar refazer.

</details>

<details>
<summary>Dica 3</summary>

O primeiro plano tende a corrigir o sintoma onde o teste falha, não a causa. Pergunta onde o valor errado é produzido e exige que o plano mude isso.

</details>

## Desafio extra

Pede ao Claude que explique porque é que o bug não foi apanhado antes e que proponha um teste que o teria apanhado.

## Pergunta de debrief

O que havia no primeiro plano que terias aceitado se não tivesses sido obrigado a encontrar um erro nele?
