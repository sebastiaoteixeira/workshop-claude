# Exercício 04 - TDD

## Objetivo

Aprendes a usar testes como especificação: ficam fechados num commit antes de o Claude escrever uma linha de implementação.

## Ponto de partida

Corre `/ex 04`. O código é a solução de referência do exercício 3. O teu trabalho anterior não está aqui.

O `CLAUDE.md` na raiz é o `CLAUDE.md` de referência do exercício 3, não o que escreveste. A suite (`make test`) está toda verde. Os testes estão em `tests/`, com as fixtures (dados e clientes de teste partilhados) em `tests/conftest.py`. A lista de espera, especificada abaixo, ainda não existe.

`/ex` deixa o repositório em `detached HEAD` (sem branch). Cria já um branch para os teus commits:

```bash
git switch -c ex04
```

## Especificação: lista de espera

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

Hoje, quem tenta inscrever-se num evento cheio recebe 409 e fica sem alternativa; a lista de espera guarda essas pessoas por ordem de chegada, para quando houver cancelamentos.

Entrar na lista de espera:

- Rota nova: `POST /events/{id}/waitlist`, com corpo `{"name": ..., "email": ...}`.
- O participante é identificado pelo `email`, como em `POST /events/{id}/registrations`: se já existe, é reutilizado.
- Responde 201 com a entrada criada: `event_id`, `position`, `participant` (com `id`, `name` e `email`) e `created_at`.
- `position` começa em 1 para o primeiro da lista.
- Responde 409 se o evento ainda tem lugares.
- Responde 409 se o participante já está inscrito no evento.
- Responde 409 se o participante já está na lista de espera.
- Responde 404 se o evento não existe.

Consultar a lista de espera:

- Rota nova: `GET /events/{id}/waitlist`.
- Devolve as entradas por ordem de chegada.
- Cada entrada inclui a posição e o nome e o email do participante, para os organizadores saberem a quem ligar.

Promover o primeiro da lista:

- Rota nova: `POST /events/{id}/waitlist/promote`. Os organizadores chamam-na depois de um cancelamento.
- Não tem autenticação, como `POST /events/{id}/registrations`.
- Tira o primeiro da lista de espera e inscreve-o no evento.
- Responde 201 com a inscrição criada, no mesmo formato de `POST /events/{id}/registrations`.
- Depois da promoção, quem estava em segundo passa a primeiro.
- Responde 409 se o evento continua cheio.
- Responde 404 se a lista de espera está vazia.
- Responde 404 se o evento não existe.

Cancelar uma inscrição:

- `DELETE /events/{id}/registrations/{participant_id}` continua a libertar o lugar.
- O cancelamento não promove ninguém da lista de espera.

## Tarefa

1. Pede ao Claude que escreva os testes da lista de espera em `tests/`, ainda sem implementação. O Claude não vê este enunciado: tens de lhe passar todas as regras da especificação, por palavras tuas, com os códigos de resposta exatos.
2. Corre `make test`. Os testes novos que esperam sucesso têm de falhar com 404 ou 405, porque as rotas ainda não existem. Os que esperam 404 podem já passar, pela mesma razão. Se algum falhar com erros de import ou de fixtures, pede ao Claude que o corrija e volta a correr.
3. Faz commit dos testes.
4. Anota o hash desse commit (`git rev-parse HEAD`). É o `<commit>` do critério de sucesso.
5. Pede ao Claude que implemente a feature. A partir deste passo, os ficheiros em `tests/` não podem mudar: nem tu nem o Claude lhes mexem.

## Critério de sucesso

- Todos os testes passam: `make test`.
- Os testes não mudaram desde o commit do passo 3: `git diff <commit> -- tests/` não mostra nada.

## Dicas

<details>
<summary>Dica 1</summary>

Separa o trabalho em duas sessões, ou pelo menos em dois pedidos com commit pelo meio. O Claude que escreve os testes não deve ser o mesmo contexto que os faz passar.

</details>

<details>
<summary>Dica 2</summary>

Ao pedir a implementação, diz explicitamente que os testes são a especificação e estão congelados. Se o Claude começar a "arranjar" um teste, interrompe com `Esc`.

</details>

<details>
<summary>Dica 3</summary>

Pede ao Claude que corra os testes e itere até passarem, sem te mostrar cada tentativa. Verifica no fim com o `git diff` do critério de sucesso.

</details>

## Desafio extra

Acrescenta ao `CLAUDE.md` uma regra que proíba alterar ficheiros de teste sem autorização explícita. Numa sessão nova, pede ao Claude que mude um teste e verifica se a respeita.

## Pergunta de debrief

Houve algum momento em que um teste do commit do passo 3 estava errado e a implementação certa? Como decidiste qual dos dois corrigir?
