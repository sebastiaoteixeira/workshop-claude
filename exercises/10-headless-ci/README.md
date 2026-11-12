# Exercício 10 - Headless em CI

## Objetivo

Aprendes a usar o Claude Code em modo `headless` (sem interface, como um comando) dentro de um script, e a converter a resposta dele em JSON e num `exit code` (código de saída do processo) que uma `pipeline` de CI (verificações automáticas a cada alteração) consegue interpretar.

## Ponto de partida

Corre `/ex 10`. O código é a solução de referência do exercício 9. O teu trabalho anterior não está aqui.

Não há `pipeline` de CI: não existe a pasta `.github/`, e `make test` e `make lint` correm à mão. A pasta `scripts/ci/` ainda não existe.

Há uma segunda tag, `ex10-poisoned`. Aponta para o commit seguinte a `ex10-start` (o seu filho direto). Esse commit acrescenta `tests/fixtures/aws_config.ini` com uma chave de acesso AWS (`AKIA...`) e o segredo correspondente. O segredo é falso, mas tem a forma de um verdadeiro. É com ele que vais testar o script.

## Especificação: script de revisão de segredos

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

Numa pipeline de CI, o script corre em cada pull request e bloqueia-o se o `diff` (as linhas alteradas) trouxer segredos.

- Ficheiro novo, executável: `scripts/ci/review_secrets.sh`.
- Recebe um argumento: a referência base, por exemplo `ex10-start`.
- Analisa o `diff` entre essa base e o commit atual (`HEAD`).
- Passa esse `diff` ao Claude Code em modo não interativo.
- Procura segredos: chaves, tokens, passwords.
- Se o Claude encontra segredos, o script sai com 1.
- Se não encontra, sai com 0.
- O output mostra, para cada segredo encontrado, o ficheiro e a razão.

## Tarefa

1. Pede ao Claude que escreva `scripts/ci/review_secrets.sh` segundo a especificação.
2. Corre o script com o repositório em `ex10-start`, primeiro com um `diff` vazio e depois com o `diff` do exercício 9, que não tem segredos:

   ```bash
   scripts/ci/review_secrets.sh ex10-start; echo "exit: $?"
   scripts/ci/review_secrets.sh ex09-start; echo "exit: $?"
   ```

   Os dois têm de sair com 0.
3. Corre `git checkout ex10-poisoned`. O script não está em nenhum commit, por isso continua no diretório de trabalho.
4. Corre o mesmo comando, com o mesmo argumento `ex10-start`. Agora o `diff` contém o segredo falso. Tem de sair com 1 e apontar `tests/fixtures/aws_config.ini`.
5. Se alguma das saídas não for a esperada, pede ao Claude que corrija o script. Volta a `ex10-start` com `git checkout ex10-start` e repete os passos 2 a 4.

## Critério de sucesso

- Em `ex10-start` (`git checkout ex10-start`), `scripts/ci/review_secrets.sh ex10-start; echo "exit: $?"` imprime `exit: 0`.
- Em `ex10-start`, `scripts/ci/review_secrets.sh ex09-start; echo "exit: $?"` imprime `exit: 0`: um `diff` sem segredos não dá falso positivo.
- Em `ex10-poisoned` (`git checkout ex10-poisoned`), `scripts/ci/review_secrets.sh ex10-start; echo "exit: $?"` imprime `exit: 1`.
- Nesse caso, o output nomeia `tests/fixtures/aws_config.ini` e a razão.

## Dicas

<details>
<summary>Dica 1</summary>

O Claude Code tem um modo não interativo que lê o prompt da linha de comandos e escreve a resposta em stdout.

</details>

<details>
<summary>Dica 2</summary>

`git diff ex10-start..HEAD | claude -p "..." --output-format json` dá-te uma resposta estruturada: o texto do Claude vem no campo `.result`. Pede-lhe um JSON com um campo fixo (por exemplo `{"secrets_found": true, "findings": [...]}`) e lê-o com `jq`. Mais robusto ainda: passa `--json-schema '<schema>'` e lê `.structured_output`, que só existe se a resposta respeitar o schema.

Se as tuas definições do Claude Code têm `verbose` ligado, o `--output-format json` devolve uma lista de eventos em vez de um objeto. Lê o último elemento com `type` igual a `"result"`, ou corre o `claude` do script com `--setting-sources project` para ignorar as tuas definições pessoais.

</details>

<details>
<summary>Dica 3</summary>

Em CI não há sessão interativa para aprovar ferramentas: como só precisas do texto, desliga-as todas com `--tools ""`. A chave de API vai numa variável de ambiente da pipeline (`ANTHROPIC_API_KEY`), nunca no repositório.

</details>

## Desafio extra

Integra o script numa pipeline do GitHub Actions (`.github/workflows/`) que corre em cada pull request, com a chave guardada como secret do repositório. Depois faz o script comentar o resultado no pull request em vez de só falhar a pipeline.

## Pergunta de debrief

O que é que um verificador baseado em LLM apanha que uma regex não apanha, e o contrário? Confiarias nele como única barreira?
