# Exercício 07 - Skill changelog

## Objetivo

Aprendes a transformar um procedimento repetitivo numa `skill` (instruções guardadas que o Claude carrega quando precisa), que invocas com `/changelog` ou que o Claude carrega sozinho quando reconhece o pedido.

## Ponto de partida

Corre `/ex 07`. O código é a solução de referência do exercício 6. O teu trabalho anterior não está aqui.

- O `CHANGELOG.md` na raiz tem três versões escritas à mão: `[0.1.0]`, `[0.2.0]` e `[0.3.0]`.
- A versão `[0.3.0]` foi escrita no commit `5c1cb53` (`docs: changelog for 0.3.0`). É o último commit que tocou no `CHANGELOG.md`.
- Os commits feitos depois desse (commits de testes e os commits `exNN` dos exercícios 2 a 6) ainda não estão no `CHANGELOG.md`.
- O repositório não tem tags de versão (`v*`, como `v0.3.0`). As tags `exNN-start` e `exNN-solution` marcam os exercícios do workshop, não versões.
- A pasta `.claude/` tem `agents/reviewer.md` e `settings.json`. Ainda não existe nenhuma skill.
- O Claude Code pede autorização antes de escrever dentro de `.claude/`. Na invocação automática, pede também para usar a skill e para editar o `CHANGELOG.md`. Aprova estes pedidos.

## Especificação: skill `/changelog`

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

A skill gera as notas de release (o resumo do que mudou numa versão) a partir do `git log`, no formato que a equipa já usa no `CHANGELOG.md`.

Intervalo de commits:

- Começa na última tag de versão (`v*`).
- Se não houver tag de versão, começa no último commit que tocou no `CHANGELOG.md`.
- Acaba em `HEAD`.

Conteúdo:

- `feat` vai para `### Adicionado`.
- `fix` vai para `### Corrigido`.
- `refactor` e `chore` vão para `### Alterado`.
- `docs` e `test` ficam de fora.
- Commits sem estes prefixos (como `ex04: waitlist`) são classificados pelo que descrevem.
- Commits que só mudam ferramentas de desenvolvimento (`.claude/`, `scripts/hooks/`) vão para `### Alterado`.
- Cada bullet é uma descrição curta em português. Pode ser substantivada ("Limite de 100 para `page_size`") ou no infinitivo ("Limitar `page_size` a 100").
- Cada bullet termina com o hash curto do commit entre parênteses.
- Uma secção sem bullets não aparece.

Versão e ficheiro:

- A versão nova é a seguinte à mais recente do `CHANGELOG.md`: `[0.3.0]` passa a `[0.4.0]`.
- A data é a do dia em que a skill corre, no formato `AAAA-MM-DD`.
- A skill escreve a secção nova no `CHANGELOG.md`, logo antes de `## [0.3.0]`. As versões ficam da mais recente para a mais antiga.
- A skill não faz commit.

Formato esperado:

```markdown
## [0.4.0] - 2026-11-13

### Adicionado

- Lista de espera por evento (1a20555)

### Corrigido

- ...

### Alterado

- ...
```

## Tarefa

1. Pede ao Claude que crie a skill `/changelog`. O Claude não vê este enunciado: tens de lhe passar todas as regras da especificação, por palavras tuas. O critério de sucesso verifica-as todas.
2. Corre `/changelog`.
3. Lê o resultado com `git diff CHANGELOG.md` e compara-o com a especificação.
4. Se algo não bate certo, corre `git restore CHANGELOG.md` para desfazer a secção gerada. Depois leva o Claude a corrigir a skill, não o `CHANGELOG.md`, e volta ao passo 2.
5. Corre `git restore CHANGELOG.md` e depois `/clear` (limpa a conversa).
6. Escreve um pedido como "prepara as notas para a release desta semana", sem nomear a skill.

## Critério de sucesso

- Depois de `/changelog`, `git diff CHANGELOG.md` mostra uma secção `## [0.4.0]` nova antes de `## [0.3.0]`, com o intervalo, o conteúdo e o formato da especificação.
- No passo 6 da Tarefa, a conversa mostra que o Claude carregou a skill `changelog` sem que a tenhas nomeado, e `git diff CHANGELOG.md` mostra a mesma estrutura.

## Dicas

<details>
<summary>Dica 1</summary>

Uma skill é um diretório com um `SKILL.md`. O `frontmatter` (o bloco entre `---` no topo do ficheiro) decide quando é carregada. O corpo decide o que faz.

</details>

<details>
<summary>Dica 2</summary>

A skill vive em `.claude/skills/changelog/SKILL.md`. O campo `description` é o que o Claude lê para decidir invocar a skill sozinho: descreve a situação, não só o nome.

</details>

<details>
<summary>Dica 3</summary>

Se a invocação automática falhar, a `description` é vaga demais ou não menciona as palavras que as pessoas usam ("notas de release", "changelog", "o que mudou desde"). Põe o formato de saída como exemplo literal dentro do `SKILL.md`. Escreve lá também a regra do intervalo de commits da especificação.

</details>

## Desafio extra

Faz a skill aceitar um argumento (uma tag ou um intervalo de commits) e usar `$ARGUMENTS` (o texto escrito a seguir a `/changelog`) para limitar o `git log`.

## Pergunta de debrief

O que puseste na `description` para a invocação automática funcionar, e o que puseste no corpo? Trocarias algo de sítio?
