# Exercício 07 - Skill changelog

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Transformar um procedimento repetitivo numa skill que o Claude invoca por nome ou sozinho quando reconhece a situação.

## Ponto de partida

A tag `ex07-start`: o resultado do exercício 6, com vários commits no histórico desde `ex00-start`. O `CHANGELOG.md` na raiz tem três releases escritas à mão no formato da equipa e a última, `[0.3.0]`, já não reflete o que está em `HEAD`.

## Tarefa

Cria uma skill `/changelog` que gera notas de release a partir do git log, no formato da equipa, que é o que já está no `CHANGELOG.md`:

```markdown
## [0.4.0] - 2026-11-13

### Adicionado

- Descrição curta em português, no infinitivo ou substantivada (a1b2c3d)

### Corrigido

- ...

### Alterado

- ...
```

Uma secção por versão, da mais recente para a mais antiga; `feat` vai para `### Adicionado`, `fix` para `### Corrigido`, `refactor` e `chore` para `### Alterado`; `docs` e `test` ficam de fora; cada bullet termina com o hash curto do commit entre parênteses; secções vazias não aparecem. Tem de funcionar quando a invocas diretamente e também quando pedes um changelog em linguagem natural sem a nomear.

## Critério de sucesso

`/changelog` produz notas no formato certo. Um pedido do género "prepara as notas para a release desta semana" invoca a mesma skill sem que a nomeies.

## Dicas

<details>
<summary>Dica 1</summary>

Uma skill é um diretório com um `SKILL.md`. O frontmatter decide quando é carregada; o corpo decide o que faz.

</details>

<details>
<summary>Dica 2</summary>

Cria `.claude/skills/changelog/SKILL.md`. O campo `description` é o que o Claude lê para decidir invocar a skill sozinho: descreve a situação, não só o nome.

</details>

<details>
<summary>Dica 3</summary>

Se a invocação automática falhar, a `description` é vaga demais ou não menciona as palavras que as pessoas usam ("notas de release", "changelog", "o que mudou desde"). Põe o formato de saída como exemplo literal dentro do `SKILL.md` e diz onde começa o intervalo: a última tag de versão, ou, se não houver, o último commit que tocou no `CHANGELOG.md`.

</details>

## Desafio extra

Faz a skill aceitar um argumento (tag ou intervalo de commits) e usar `$ARGUMENTS` para limitar o git log.

## Pergunta de debrief

O que puseste na `description` para a invocação automática funcionar, e o que puseste no corpo? Trocarias algo de sítio?
