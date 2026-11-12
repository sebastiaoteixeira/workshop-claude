# Exercício 04 - TDD

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Usar testes como especificação: fixar o comportamento esperado em git antes de pedir uma única linha de implementação.

## Ponto de partida

A tag `ex04-start`: o `CLAUDE.md` do exercício 3, a suite toda verde, e uma feature nova por implementar: a lista de espera, especificada abaixo.

### Especificação: lista de espera

Quando um evento está cheio, quem tenta inscrever-se recebe 409 e fica sem alternativa. O NEI quer uma lista de espera por evento, por ordem de chegada, de onde os organizadores vão buscando pessoas à medida que há cancelamentos.

- `POST /events/{id}/waitlist` com `{"name": ..., "email": ...}` coloca o participante na lista de espera. Responde 201 com a entrada criada: `event_id`, `position` (1 para o primeiro), `participant` (com `id`, `name` e `email`) e `created_at`. Responde 409 se o evento ainda tem lugares, se o participante já está inscrito ou se já está na lista; 404 se o evento não existe. Tal como na inscrição, um participante é identificado pelo email: se já existir, reutiliza-se.
- `GET /events/{id}/waitlist` devolve a lista por ordem de chegada. Para cada entrada, inclui a posição e o nome e email do participante, para os organizadores saberem a quem ligar.
- `POST /events/{id}/waitlist/promote` é o que os organizadores usam depois de um cancelamento: tira o primeiro da lista e inscreve-o no evento. Responde 201 com a inscrição criada (o mesmo formato de `POST /events/{id}/registrations`); 409 se o evento continua cheio, 404 se a lista está vazia ou o evento não existe. Depois da promoção, quem estava em segundo passa a primeiro.
- O cancelamento (`DELETE /events/{id}/registrations/{participant_id}`) continua a libertar o lugar; não promove ninguém por si.

## Tarefa

Escreve os testes da feature, confirma que falham pelas razões certas e faz commit. Só depois pede a implementação. Os ficheiros de teste não podem mudar a partir desse commit.

## Critério de sucesso

Todos os testes passam e `git diff <commit> -- tests/` está vazio, onde `<commit>` é o commit com os testes.

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

Acrescenta uma regra ao `CLAUDE.md` que proíba alterar ficheiros de teste sem autorização explícita e verifica se é respeitada no exercício seguinte.

## Pergunta de debrief

Houve algum momento em que o teste que escreveste estava errado e a implementação certa? Como decidiste qual dos dois corrigir?
