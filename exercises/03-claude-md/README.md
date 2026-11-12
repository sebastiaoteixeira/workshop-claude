# Exercício 03 - CLAUDE.md

## Objetivo

Aprendes a dar ao Claude o contexto do projeto uma só vez, por escrito, e a medir a diferença que isso faz.

## Ponto de partida

Corre `/ex 03`. O código é a solução de referência do exercício 2. O teu trabalho anterior não está aqui.

Não há `CLAUDE.md` (ficheiro de instruções que o Claude lê no início de cada sessão) na raiz do repositório. `make test` mostra 12 testes a passar e 2 a falhar. Cada teste que falha descreve uma das duas features abaixo, que ainda não existem. As duas são pequenas e do mesmo tamanho, para as poderes comparar.

## Especificação: feature A, cancelar uma inscrição

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

- Rota nova: `DELETE /events/{id}/registrations/{participant_id}`.
- Remove a inscrição desse participante nesse evento.
- Responde 204.
- Responde 404 se o evento não existe ou se o participante não está inscrito nele.
- O lugar fica livre: um evento que estava cheio volta a aceitar uma inscrição.
- O teste `tests/test_registrations.py::test_cancel_registration_frees_capacity` já descreve este comportamento.

## Especificação: feature B, lugares disponíveis

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

- A resposta de `GET /events/{id}` ganha o campo `available_seats`.
- `available_seats` é a capacidade do evento menos o número de inscrições nele.
- O teste `tests/test_events.py::test_get_event_includes_available_seats` já descreve este comportamento.

## Tarefa

Uma correção é cada mensagem em que pedes ao Claude para refazer algo que não segue o padrão do código em `app/` ou o modo de correr os testes do projeto.

1. Pede ao Claude que implemente a feature A.
2. Conta as correções que tiveste de fazer até o teste da feature A passar. Anota o número.
3. Corre `/context` (mostra quanto contexto, o texto que o Claude tem presente na sessão, já foi gasto). Anota o total de tokens em uso, que aparece no topo.
4. Sai do Claude Code com `/exit` e abre uma sessão nova com `claude`, na mesma pasta. Nessa sessão nova, gera um primeiro rascunho do `CLAUDE.md` com o comando do Claude Code que inspeciona o projeto e escreve esse ficheiro. Se não souberes qual é, abre a Dica 1.
5. Lê o rascunho com atenção e corrige-o à mão: remove o que é óbvio ou que o Claude descobre sozinho a ler o código.
6. Lê `app/` e o `Makefile`. O projeto segue cinco convenções que o código só sugere e que nenhum gerador adivinha. Encontra-as e escreve cada uma no `CLAUDE.md` como uma regra de uma linha. Se alguma correção do passo 2 não estiver coberta por estas cinco, acrescenta-a também como regra.
7. Sai do Claude Code com `/exit` e abre uma sessão nova com `claude`, na mesma pasta. A sessão nova não tem a conversa anterior e lê o `CLAUDE.md` que escreveste.
8. Pede ao Claude que implemente a feature B. Conta as correções como no passo 2 e anota o número.
9. Com o teste da feature B a passar, corre `/context` e anota o total de tokens em uso.

## Critério de sucesso

- `make test`: os 14 testes passam.
- `cat CLAUDE.md`: o ficheiro existe na raiz e tem as cinco convenções, uma regra por linha.
- Na feature B não fizeste mais correções do que na feature A (números dos passos 2 e 8).
- Na feature B a sessão não gastou mais contexto do que na feature A (números dos passos 3 e 9). Conta com uma diferença pequena: boa parte do contexto de cada sessão é fixa (instruções de sistema e ferramentas).

## Dicas

<details>
<summary>Dica 1</summary>

Escreve `/` no Claude Code e percorre a lista de comandos. Procura o que inicializa o projeto.

</details>

<details>
<summary>Dica 2</summary>

Corre `/init`. O resultado é um ponto de partida genérico; o valor está no que acrescentas à mão. Pensa no que tiveste de explicar nos exercícios 0 a 2.

</details>

<details>
<summary>Dica 3</summary>

Regras curtas e verificáveis funcionam melhor do que parágrafos. O `/context` do passo 9 mede o contexto gasto na feature B; compara-o com o número que anotaste no passo 3.

</details>

## Desafio extra

Cria um `~/.claude/CLAUDE.md` pessoal (lido em todos os teus projetos) com as tuas preferências de estilo. Corre `/memory` para confirmar que o Claude carrega os dois ficheiros. Verifica que as preferências se aplicam e que nenhuma foi parar ao `CLAUDE.md` do projeto.

## Pergunta de debrief

Que regra do teu `CLAUDE.md` teve mais efeito na feature B, e qual o Claude teria seguido mesmo sem estar escrita?
