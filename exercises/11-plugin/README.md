# Exercício 11 - Plugin

## Objetivo

Aprendes a distribuir a configuração do Claude Code como um `plugin` (pacote que outra pessoa instala com um comando).

## Ponto de partida

Corre `/ex 11`. O código é a solução de referência do exercício 10. O teu trabalho anterior não está aqui.

A configuração feita ao longo do workshop está espalhada pelo repositório:

- `scripts/hooks/protect.sh`: o `hook` (comando que o Claude Code corre sozinho antes ou depois de usar uma ferramenta) que bloqueia escritas em `.env` e em `migrations/`. Está ligado em `.claude/settings.json`, em `PreToolUse`, para `Edit|Write`.
- `.claude/agents/reviewer.md`: o `subagent` (um assistente separado, com contexto próprio e ferramentas limitadas) `reviewer`, que revê código sem editar.
- `.claude/skills/changelog/SKILL.md`: a `skill` (instruções guardadas que o Claude carrega quando precisa) `/changelog`, que gera notas de release a partir do `git log`.

Há mais dois scripts que não entram no plugin: `scripts/hooks/lint.sh` (hook `PostToolUse` que corre o `ruff`) e `scripts/ci/review_secrets.sh` (o passo de CI do exercício 10).

Ainda não existe nenhum diretório `nei-toolkit/` nem `.claude-plugin/` no repositório.

O teu clone aponta (`origin`) para `sebastiaoteixeira/workshop-claude-app`, onde não tens permissão de push.

`/ex` deixa o repositório em `detached HEAD` (sem branch). Cria já o branch onde vais fazer commit do plugin:

```bash
git switch -c ex11
```

## Especificação: plugin `nei-toolkit`

> Isto é o comportamento que o Claude tem de construir. Ainda não existe no código. Não é um prompt: não o copies. O pedido ao Claude escreve-lo tu.

Um colega deve ter o mesmo hook, subagent e skill sem copiar ficheiros à mão.

- O plugin chama-se `nei-toolkit` e vive no diretório `nei-toolkit/`, na raiz da app.
- Contém o hook de `scripts/hooks/protect.sh`, o subagent `reviewer` e a skill `/changelog`.
- Não contém `lint.sh` nem `review_secrets.sh`.
- É autocontido: o script do hook está dentro de `nei-toolkit/`. O plugin não depende de `scripts/hooks/` nem de `.claude/`.
- Depois de instalado, o hook bloqueia escritas em `.env` e em `migrations/`, como hoje.
- A raiz do repositório é um `marketplace` (catálogo de plugins instaláveis) chamado `workshop-claude-app`, que lista o `nei-toolkit`.

## Tarefa

1. Pede ao Claude que construa o plugin descrito na Especificação.
2. Lê o que o Claude criou (`git status`, `git diff`). Confirma que `nei-toolkit/` tem a sua própria cópia de `protect.sh`.
3. Faz commit no branch `ex11`.
4. No GitHub, faz fork de `sebastiaoteixeira/workshop-claude-app` para a tua conta.
5. Adiciona o fork como `remote` (outro endereço para onde fazer push) e publica o branch:

   ```bash
   git remote add fork git@github.com:<utilizador>/workshop-claude-app.git
   git push fork ex11
   ```

6. Escolhe um repositório de destino que não tenha nada disto:
   - o repositório de um colega, que instala o plugin a partir do teu fork;
   - ou uma cópia limpa da app em `ex00-start`, sem hook, subagent nem skill, criada assim:

     ```bash
     git worktree add ../app-limpa ex00-start
     cd ../app-limpa
     ```

7. Instala o plugin no repositório de destino com `--scope local`, para ficar ativo só nesse repositório (ver Dica 3). Não alteres `.claude/` nem `scripts/` à mão: tudo tem de vir do plugin.
8. Se o repositório de destino não tiver commits `feat` ou `fix` depois da última versão do `CHANGELOG.md`, o `/changelog` não tem nada para escrever. É o caso da cópia limpa. Faz lá primeiro um commit descartável: `git commit --allow-empty -m "feat: teste do plugin"`.
9. Confirma lá cada ponto do Critério de sucesso. No fim, corre `git restore CHANGELOG.md`.

## Critério de sucesso

No repositório de destino, depois de instalar o plugin:

- `git status` não mostra alterações em `.claude/` nem em `scripts/`.
- Pedes ao Claude que escreva em `.env` e o hook bloqueia a escrita com uma mensagem que começa por `Blocked:` e diz que o `.env` está protegido (`Blocked: <caminho>/.env is protected. ...`).
- Numa sessão nova, o Claude inclui o `reviewer` do plugin quando lhe perguntas que subagents tem disponíveis.
- `/changelog` (pode aparecer como `/nei-toolkit:changelog`) gera notas no formato da [especificação do exercício 7](../07-skill-changelog/README.md#especificação-skill-changelog): secção `## [versão] - data`, subsecções `### Adicionado`, `### Corrigido` e `### Alterado` (só as que têm bullets), e cada bullet termina com o hash curto do commit entre parênteses.

## Dicas

<details>
<summary>Dica 1</summary>

Um plugin é a mesma estrutura de `.claude/` com um manifesto por cima. O que muda é a forma de distribuição.

</details>

<details>
<summary>Dica 2</summary>

O diretório `nei-toolkit/` leva `.claude-plugin/plugin.json` (`name`, `description`, `version`) e, ao lado, `hooks/hooks.json`, `scripts/protect.sh`, `agents/reviewer.md` e `skills/changelog/SKILL.md`. Agentes e skills nestes diretórios são descobertos sem os declarar no manifesto. O `hooks.json` tem a mesma forma do bloco `hooks` do `settings.json`, embrulhado numa chave `hooks`. O comando usa `"${CLAUDE_PLUGIN_ROOT}"/scripts/protect.sh` para não depender de onde o plugin é instalado. `claude plugin validate ./nei-toolkit` apanha erros de estrutura.

</details>

<details>
<summary>Dica 3</summary>

Testa primeiro sem instalar: `claude --plugin-dir ./nei-toolkit` carrega o plugin só nessa sessão. Para o marketplace, cria `.claude-plugin/marketplace.json` na raiz da app, com `"name": "workshop-claude-app"` e uma entrada que aponta para `./nei-toolkit`. Depois do push, no repositório de destino, adiciona o fork e instala o plugin:

```bash
claude plugin marketplace add <utilizador>/workshop-claude-app#ex11 --scope local
claude plugin install nei-toolkit@workshop-claude-app --scope local
```

O `#ex11` escolhe o branch do fork onde está o plugin. Sem `--scope local`, o plugin fica ativo em todos os teus projetos, incluindo o repositório do exercício, que já tem o mesmo hook em `.claude/settings.json`.

Na cópia limpa não precisas do fork: o teu clone, no branch `ex11`, já é um marketplace. Dentro de `../app-limpa`, troca o primeiro comando por `claude plugin marketplace add ../workshop-claude-app --scope local`.

</details>

## Desafio extra

Acrescenta ao plugin o servidor MCP do exercício 8 (o `workshop-db` de `.mcp.json`), num `.mcp.json` na raiz de `nei-toolkit/`. Verifica com `/mcp` que fica disponível após a instalação.

## Pergunta de debrief

Olhando para o plugin, o que é específico desta app e o que serviria em qualquer projeto? Como separarias os dois?
