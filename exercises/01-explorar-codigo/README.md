# Exercício 01 - Explorar o código

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Perceber a arquitetura de um projeto desconhecido e traçar o caminho completo de um pedido HTTP, usando o Claude como guia em vez de ler ficheiro a ficheiro.

## Ponto de partida

A tag `ex01-start`: o estado do exercício anterior, ambiente a funcionar.

## Tarefa

Descobre como a app está organizada e segue um pedido HTTP desde a rota até à resposta, passando por tudo o que ele toca pelo caminho. No fim, responde às três perguntas:

1. O que acontece às inscrições de um evento quando esse evento é apagado da base de dados? E se a ligação for aberta com `sqlite3.connect` diretamente, sem passar por `app/db.py`?
2. Que camada decide o 409 quando alguém tenta inscrever-se num evento cheio, e como é que esse 409 chega ao cliente sem que o handler da rota o construa?
3. Traça o caminho de `POST /events/{id}/registrations` desde o router até ao SQL: que funções são chamadas, por que ordem, e em que ficheiro está cada uma.

Nenhuma das três se responde com um `grep` ou com o `README`: todas dependem de juntar dois ou mais ficheiros.

## Critério de sucesso

As três respostas estão corretas e consegues apontar, para cada uma, o ficheiro e a linha que a justificam.

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

Pede um diagrama em Mermaid do caminho do pedido e verifica se corresponde ao que viste no código.

## Pergunta de debrief

Em que ponto deixaste de confirmar as respostas do Claude e passaste a confiar nelas? Foi cedo demais?
