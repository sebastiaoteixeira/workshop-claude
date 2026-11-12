# Exercício 10 - Headless em CI

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Usar o Claude Code sem interface, como um comando que recebe um diff e devolve um veredicto que a pipeline consegue interpretar.

## Ponto de partida

A tag `ex10-start`: o resultado do exercício 9. Não há pipeline de CI: `make test` e `make lint` correm à mão. Existe um commit envenenado na tag `ex10-poisoned`, um commit acima de `ex10-start`, que acrescenta `tests/fixtures/aws_config.ini` com uma chave de acesso AWS (`AKIA...`) e o segredo correspondente. É um segredo falso, mas tem a forma de um verdadeiro.

## Tarefa

Escreve um script que passa um diff ao Claude e falha (saída diferente de 0) se ele encontrar segredos (chaves, tokens, passwords). Corre-o primeiro localmente: tem de passar em `ex10-start` e falhar em `ex10-poisoned`.

## Critério de sucesso

`scripts/ci/review_secrets.sh ex10-start` sai com 0 em `ex10-start` e com 1 em `ex10-poisoned`, com a razão visível no output.

## Dicas

<details>
<summary>Dica 1</summary>

O Claude Code tem um modo não interativo que lê o prompt da linha de comandos e escreve a resposta em stdout.

</details>

<details>
<summary>Dica 2</summary>

`git diff ex10-start..HEAD | claude -p "..." --output-format json` dá-te uma resposta estruturada: o texto do Claude vem no campo `.result`. Pede-lhe um JSON com um campo fixo (por exemplo `{"secrets_found": true, "findings": [...]}`) e lê-o com `jq`. Mais robusto ainda: passa `--json-schema '<schema>'` e lê `.structured_output`, que só existe se a resposta respeitar o schema.

</details>

<details>
<summary>Dica 3</summary>

Em CI não há sessão interativa para aprovar ferramentas: como só precisas do texto, desliga-as todas com `--tools ""`. A chave de API vai numa variável de ambiente da pipeline (`ANTHROPIC_API_KEY`), nunca no repositório.

</details>

## Desafio extra

Integra o script numa pipeline do GitHub Actions que corre em cada pull request, com a chave guardada como secret do repositório. Depois faz o script comentar o resultado no pull request em vez de só falhar a pipeline.

## Pergunta de debrief

O que é que um verificador baseado em LLM apanha que uma regex não apanha, e o contrário? Confiarias nele como única barreira?
