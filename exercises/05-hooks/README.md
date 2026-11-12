# Exercício 05 - Hooks

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Impor regras que não dependem de o Claude se lembrar delas: o harness executa-as, aconteça o que acontecer.

## Ponto de partida

A tag `ex05-start`: o resultado do exercício 4, sem hooks configurados.

## Tarefa

Configura dois hooks: um que corre o linter do projeto depois de cada edição de ficheiro e devolve os erros ao Claude; outro que bloqueia qualquer escrita em `.env` e nos ficheiros de migração da base de dados. Depois pede ao Claude uma tarefa que o leve a tentar editar o `.env`.

## Critério de sucesso

A tentativa de editar `.env` é recusada pelo hook e o Claude explica que não pode fazê-lo. O linter corre a cada edição e os erros aparecem na conversa.

## Dicas

<details>
<summary>Dica 1</summary>

Uma regra no `CLAUDE.md` é um pedido; um hook é uma garantia. Procura a diferença entre os eventos que correm antes e depois de uma ferramenta.

</details>

<details>
<summary>Dica 2</summary>

Usa `/hooks` para configurar. O linter vai em `PostToolUse` sobre `Edit|Write`; o bloqueio vai em `PreToolUse`, lê o caminho do ficheiro do JSON em stdin e sai com código 2 para recusar.

</details>

<details>
<summary>Dica 3</summary>

O hook de bloqueio é um script pequeno: `jq -r '.tool_input.file_path'`, compara com os padrões proibidos, escreve a razão em stderr e `exit 2`. Guarda-o em `scripts/hooks/` e referencia-o em `.claude/settings.json` como `"$CLAUDE_PROJECT_DIR"/scripts/hooks/protect.sh`, para funcionar seja qual for o diretório atual. Testa-o sem o Claude: `echo '{"tool_input":{"file_path":"migrations/001_events.sql"}}' | scripts/hooks/protect.sh; echo $?` tem de imprimir a razão e `2`.

</details>

## Desafio extra

Acrescenta um hook `Stop` que corre a suite de testes e impede o Claude de terminar o turno enquanto houver testes a falhar.

## Pergunta de debrief

Que outra regra do `CLAUDE.md` devia ser um hook, e porque é que ainda não o é?
