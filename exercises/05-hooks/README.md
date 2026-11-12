# Exercício 05 - Hooks

## Objetivo

Aprendes a impor regras com `hooks` (comandos que o Claude Code corre sozinho em momentos fixos), que se aplicam mesmo quando o Claude se esquece delas.

## Ponto de partida

Corre `/ex 05`. O código é a solução de referência do exercício 4. O teu trabalho anterior não está aqui. A suite está toda verde.

- `.claude/settings.json` existe, mas só define o modelo. Não há hooks configurados.
- O linter do projeto é o `ruff`. `make lint` corre `ruff check` e `ruff format --check`.
- As migrações da base de dados vivem em `migrations/`, de `001_events.sql` a `004_waitlist.sql`.
- O `CLAUDE.md` proíbe editar uma migração já aplicada: uma alteração ao esquema é um ficheiro numerado novo.
- O `.env` (segredos locais) ainda não existe. Só existe o `.env.example`, que documenta as variáveis.

## Especificação: hook de lint

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

- Corre depois de cada edição ou criação de ficheiro pelo Claude (ferramentas `Edit` e `Write`).
- Ignora ficheiros que não sejam `.py`.
- Corre o `ruff` sobre o ficheiro editado.
- Os erros que sobram chegam ao Claude como mensagem, para ele os corrigir.
- O script fica em `scripts/hooks/` e é registado em `.claude/settings.json`.

## Especificação: hook de proteção

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

- Corre antes de cada edição ou criação de ficheiro pelo Claude (ferramentas `Edit` e `Write`) e pode impedi-la.
- Recusa qualquer escrita no `.env`.
- Recusa qualquer escrita em `migrations/`, incluindo ficheiros novos. Quando é precisa uma migração nova, o Claude propõe o SQL e és tu que crias o ficheiro.
- Deixa passar todos os outros ficheiros.
- Quando recusa, escreve a razão em stderr e sai com código 2. O Claude recebe essa razão.
- O script chama-se `scripts/hooks/protect.sh` e é registado em `.claude/settings.json`.

## Tarefa

1. Pede ao Claude que crie os dois hooks das especificações.
2. Corre `/hooks` e confirma que os dois aparecem.
3. Testa o hook de proteção sem o Claude, a partir da raiz do projeto:

   ```bash
   echo '{"tool_input":{"file_path":"migrations/001_events.sql"}}' | scripts/hooks/protect.sh; echo $?
   echo '{"tool_input":{"file_path":".env"}}' | scripts/hooks/protect.sh; echo $?
   echo '{"tool_input":{"file_path":"app/main.py"}}' | scripts/hooks/protect.sh; echo $?
   ```

4. Pede ao Claude que acrescente a um ficheiro em `app/` uma linha com mais de 100 caracteres (o limite do `ruff` neste projeto). Observa a mensagem do hook de lint na conversa.
5. Pede ao Claude uma tarefa que o leve a tentar escrever no `.env`, por exemplo guardar um `ADMIN_TOKEN` local diferente do de desenvolvimento.

## Critério de sucesso

- `/hooks` mostra os dois hooks, ambos sobre `Edit|Write`.
- No passo 3, os dois primeiros comandos imprimem uma razão e `2`. O terceiro imprime só `0`.
- No passo 4, a conversa mostra a mensagem do hook de lint com o erro do `ruff` (`E501`).
- No passo 5, a conversa mostra a escrita no `.env` bloqueada pelo hook, com a razão do script.
- `ls .env` continua a falhar: o ficheiro não foi criado.

## Dicas

<details>
<summary>Dica 1</summary>

Uma regra no `CLAUDE.md` é um pedido; um hook é uma garantia. Procura a diferença entre os eventos que correm antes e depois de uma ferramenta.

</details>

<details>
<summary>Dica 2</summary>

A configuração vive em `.claude/settings.json`; `/hooks` só a mostra. O linter vai em `PostToolUse` sobre `Edit|Write`; o bloqueio vai em `PreToolUse`, lê o caminho do ficheiro do JSON em stdin e sai com código 2 para recusar. No `PostToolUse` o código 2 já não impede a edição, mas é o que faz o stderr chegar ao Claude.

</details>

<details>
<summary>Dica 3</summary>

O hook de bloqueio é um script pequeno: `jq -r '.tool_input.file_path'`, compara com os padrões proibidos (o `.env` e qualquer ficheiro em `migrations/`), escreve a razão em stderr e `exit 2`. Referencia-o em `.claude/settings.json` como `"$CLAUDE_PROJECT_DIR"/scripts/hooks/protect.sh`, para funcionar seja qual for o diretório atual. Testa-o sem o Claude como no passo 3 da Tarefa.

</details>

## Desafio extra

Acrescenta um hook `Stop` (corre quando o Claude acaba o turno) que corre a suite de testes e impede o Claude de terminar o turno enquanto houver testes a falhar.

## Pergunta de debrief

Que outra regra do `CLAUDE.md` devia ser um hook, e porque é que ainda não o é?
