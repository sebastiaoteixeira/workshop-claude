# Exercício 01 - Explorar o código

## Objetivo

Aprendes a usar o Claude como guia para perceber um projeto desconhecido e seguir um pedido HTTP pelo código, sem leres ficheiro a ficheiro.

## Ponto de partida

Corre `/ex 01`. O código é a solução de referência do exercício 0. O exercício 0 não altera código, por isso a tag `ex01-start` é igual a `ex00-start`. O teu trabalho anterior não está aqui.

A app é uma API de inscrições em eventos do NEI, feita com FastAPI e SQLite. As rotas estão em `app/routes/`, as queries SQL em `app/repositories/`, e as tabelas são criadas pelos ficheiros em `migrations/`.

A suite tem os mesmos três testes a falhar do exercício 0. Não fazem parte deste exercício.

## Tarefa

Neste exercício não alteras código. O Claude lê o código por ti e tu confirmas o que ele diz.

1. Pede ao Claude que te explique como a app está organizada: que pastas existem e o que faz cada uma.
2. Pede ao Claude que siga o pedido da pergunta 3, `POST /events/{id}/registrations`, desde a rota até ao SQL, passando por todas as funções que o pedido chama.
3. Com a ajuda do Claude, responde às três perguntas abaixo. Para cada resposta, anota o ficheiro e a linha que a justificam.
4. Abre cada ficheiro na linha que anotaste e confirma que diz o que a resposta afirma.
5. Escreve as respostas fora do repositório, por exemplo num ficheiro de notas noutra pasta. Um ficheiro novo dentro do repositório fica como alteração por guardar, e o `/ex 02` recusa avançar enquanto ela existir.

Perguntas:

1. Sobre apagar um evento:
   - A API não tem nenhuma rota para apagar eventos. Imagina um `DELETE FROM events` corrido diretamente na base de dados. O que acontece às inscrições desse evento?
   - E se a ligação à base de dados for aberta com `sqlite3.connect` diretamente, sem passar por `app/db.py`?
2. Sobre a inscrição num evento cheio:
   - Que camada da app decide responder 409 quando alguém tenta inscrever-se num evento cheio?
   - Como é que esse 409 chega ao cliente sem que o `handler` (a função que trata o pedido) em `app/routes/registrations.py` o construa?
3. Traça o caminho de `POST /events/{id}/registrations` desde o `router` (o objeto que liga cada URL à sua função) até ao SQL. Que funções são chamadas, por que ordem, e em que ficheiro está cada uma?

Nenhuma das três se responde com um `grep` (pesquisa de texto) ou com o `README.md` da app. Todas exigem juntar dois ou mais ficheiros.

## Critério de sucesso

- As três respostas estão corretas.
- Cada resposta tem anotado o ficheiro e a linha que a justificam.
- Abriste cada um desses ficheiros e a linha diz o que a resposta afirma.
- `git status` não mostra alterações: o exercício não mexe no repositório.

## Dicas

<details>
<summary>Dica 1</summary>

Perguntas gerais dão respostas gerais. Pede o mapa da arquitetura primeiro e só depois desce ao pedido concreto.

</details>

<details>
<summary>Dica 2</summary>

Pede ao Claude que siga um endpoint específico e te mostre, por ordem, cada função chamada com o caminho do ficheiro. Uma pergunta de cada vez evita respostas misturadas.

</details>

<details>
<summary>Dica 3</summary>

Quando uma resposta te parecer vaga, pede a linha exata e abre o ficheiro. Verificar uma resposta é mais barato do que acreditar numa errada.

</details>

## Desafio extra

Pede ao Claude um diagrama em Mermaid (linguagem de diagramas escrita em texto) do caminho do pedido da pergunta 3. Confirma que corresponde ao que viste no código.

## Pergunta de debrief

Em que ponto deixaste de confirmar as respostas do Claude e passaste a confiar nelas? Foi cedo demais?
