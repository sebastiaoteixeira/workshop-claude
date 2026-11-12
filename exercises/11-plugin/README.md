# Exercício 11 - Plugin

A tarefa é descrita como um problema, nunca como um prompt: escrever o prompt faz parte do exercício.

## Objetivo

Empacotar tudo o que configuraste ao longo do workshop num plugin que outra pessoa instala com um comando.

## Ponto de partida

A tag `ex11-start`: o resultado do exercício 10, com o hook de bloqueio (`scripts/hooks/protect.sh`, ligado em `.claude/settings.json`), o subagent revisor (`.claude/agents/reviewer.md`) e a skill `/changelog` (`.claude/skills/changelog/SKILL.md`) espalhados pelo repositório.

## Tarefa

Cria um plugin `nei-toolkit` que contenha o hook, o subagent e a skill e publica-o no teu fork de `workshop-claude-app`. Um colega instala-o a partir desse fork no repositório dele (ou numa cópia limpa da app alvo em `ex00-start`, que não tem nada disto) e confirma que os três funcionam lá.

## Critério de sucesso

No repositório do colega, sem qualquer configuração manual, o hook bloqueia a escrita em `.env`, o subagent aparece em `/agents` e `/changelog` gera notas no formato certo.

## Dicas

<details>
<summary>Dica 1</summary>

Um plugin é a mesma estrutura de `.claude/` com um manifesto por cima. O que muda é a forma de distribuição.

</details>

<details>
<summary>Dica 2</summary>

Cria um diretório com `.claude-plugin/plugin.json` (`name`, `description`, `version`) e, ao lado, `hooks/hooks.json`, `agents/reviewer.md` e `skills/changelog/SKILL.md`: agentes e skills nestes diretórios são descobertos sem os declarar no manifesto. O `hooks.json` tem a mesma forma do bloco `hooks` do `settings.json`, embrulhado numa chave `hooks`, e o comando usa `"${CLAUDE_PLUGIN_ROOT}"/scripts/protect.sh` para não depender de onde o plugin é instalado. `claude plugin validate ./nei-toolkit` apanha erros de estrutura.

</details>

<details>
<summary>Dica 3</summary>

Testa primeiro sem instalar: `claude --plugin-dir ./nei-toolkit` carrega o plugin só nessa sessão. Para o colega instalar, o teu fork tem de ser um marketplace: `.claude-plugin/marketplace.json` na raiz, com `"name": "workshop-claude-app"` e uma entrada que aponta para o diretório do plugin. Faz push para o fork; o colega adiciona-o com `claude plugin marketplace add <utilizador>/workshop-claude-app` e instala com `claude plugin install nei-toolkit@workshop-claude-app`.

</details>

## Desafio extra

Acrescenta ao plugin um servidor MCP (o do exercício 8, num `.mcp.json` na raiz do plugin) e verifica que fica disponível após a instalação.

## Pergunta de debrief

Olhando para o plugin, o que é específico desta app e o que serviria em qualquer projeto? Como separarias os dois?
