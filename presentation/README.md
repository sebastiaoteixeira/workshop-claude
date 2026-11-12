# Apresentação

Guião da parte teórica e fonte dos slides. Um bloco de abertura antes do exercício 00 e, depois, um slot curto antes de cada exercício que usa o tema.

| Slot | Duração | Antes de |
|---|---|---|
| [Abertura](#abertura) | ~25 min | 00 |
| [Comandos](#comandos) | ~5 min | 01 e 02 |
| [Personalização](#personalização) | ~5 min | 03 |
| [Hooks, permissões e segurança](#hooks-permissões-e-segurança) | ~5 min | 05 |
| [Subagents](#subagents) | ~5 min | 06 |
| [Skills](#skills) | ~5 min | 07 |
| [MCP](#mcp) | ~5 min | 08 |
| [Workflows](#workflows) | ~5 min | 09 e 10 |
| [Plugins](#plugins) | ~5 min | 11 |

## Abertura

### Disclaimer

- A IA não te faz o curso: o que não percebes não consegues rever, e o que não revês não é teu
- Quando não usar: a aprender um conceito pela primeira vez, em avaliações, quando não consegues verificar a resposta
- Tu continuas responsável por cada linha que entra no repositório

### Evolução da IA no desenvolvimento

- Autocomplete: sugere a linha seguinte dentro do editor
- Chat: responde a perguntas, mas copias o código à mão e o contexto és tu que o dás
- Agêntico: lê o projeto, corre comandos, edita ficheiros e verifica o resultado sozinho

### O que é um agente

- Um ciclo: o modelo decide, uma ferramenta executa, o resultado volta ao modelo
- Modelo + ferramentas + contexto; tirar qualquer um dos três estraga o ciclo
- O agente só sabe o que as ferramentas lhe mostram e o que está no contexto

### Claude Code e OpenCode

- Claude Code: agente de terminal da Anthropic, modelos Claude, plugins, hooks, skills, subagents e MCP
- OpenCode: agente de terminal open source, independente do fornecedor do modelo
- Os conceitos deste workshop (contexto, ferramentas, permissões, MCP) transferem-se entre os dois

### Escolha do modelo e custo

- Opus: o mais capaz e o mais caro, para raciocínio difícil e planeamento
- Sonnet: o modelo de trabalho do dia a dia; é o que a app alvo fixa em `.claude/settings.json`
- Haiku: rápido e barato, para tarefas mecânicas e subagents simples
- Esforço (`/effort`): mais raciocínio custa mais tokens e mais tempo; sobe só quando a tarefa o pede
- `model:` no frontmatter de um subagent escolhe o modelo por agente
- `/model` troca de modelo a meio; `/cost` mostra o gasto da sessão

### Janela de contexto

- Tudo o que o Claude sabe numa sessão: prompt, ficheiros lidos, output de comandos, respostas
- É finita e enche depressa; quanto mais cheia, pior a atenção ao que importa
- Uma sessão por tarefa; `/clear` entre tarefas não relacionadas

### Prompting

- Descreve o problema, não a instrução: o que está mal, não que linha mudar
- Contexto: onde está o problema, o que já tentaste, o que sabes que ele não sabe
- Restrições: o que não pode mudar, que convenções seguir
- Critério de sucesso: como sabes que ficou feito (um teste, um comando, um output)

## Comandos

- Plan mode (`Shift+Tab`): só lê e propõe; o plano é um documento que recusas e mandas refazer
- `/context`: o que está a ocupar a janela de contexto
- `/compact`: resume a conversa para libertar contexto, com instruções sobre o que manter
- `/init`: gera um primeiro `CLAUDE.md` a partir do projeto
- `Esc` interrompe; `/rewind` volta a um ponto anterior da conversa e do código

## Personalização

- `CLAUDE.md`: memória do projeto, carregada em todas as sessões; regras curtas e verificáveis
- Níveis: `~/.claude/CLAUDE.md` pessoal, `CLAUDE.md` do projeto, `CLAUDE.local.md` não versionado
- `.claude/settings.json` versionado para a equipa; `.claude/settings.local.json` só teu
- Permissões: `allow`, `ask` e `deny` por ferramenta e padrão, por exemplo `Bash(make test)`

## Hooks, permissões e segurança

- Uma regra no `CLAUDE.md` é um pedido; um hook é uma garantia executada pelo harness
- Eventos: `PreToolUse` pode bloquear, `PostToolUse` reage depois, `Stop` decide se o turno acaba
- O hook recebe JSON em stdin; `exit 2` bloqueia e devolve o stderr ao Claude
- Permissões em camadas: `deny` ganha a `allow`; modos de permissão por sessão
- Segredos fora do contexto: `.env` protegido, chaves em variáveis de ambiente, nunca no repositório
- Hooks de projeto correm na tua máquina com as tuas permissões: lê-os antes de aceitar

## Subagents

- Um agente com contexto limpo, prompt próprio e ferramentas restritas
- Ficheiro Markdown em `.claude/agents/` com frontmatter: `tools`, `model`, `description`
- Restringir ferramentas é mais forte do que proibir por instrução
- Bom para revisão independente e para pesquisa que não deve encher o contexto principal
- `/agents` lista e cria subagents

## Skills

- Um diretório com `SKILL.md`: frontmatter decide quando carrega, corpo decide o que faz
- Invocadas à mão (`/nome`) ou pelo Claude quando a `description` corresponde à situação
- Só a `description` fica no contexto até a skill ser usada
- `$ARGUMENTS` e `$0`, `$1` recebem os argumentos da invocação

## MCP

- Protocolo aberto para ligar o agente a sistemas externos: bases de dados, APIs, browsers
- Servidores locais (stdio) ou remotos (HTTP); configuração em `.mcp.json` ou `claude mcp add`
- Cada servidor expõe ferramentas que passam pelas mesmas permissões das outras
- `/mcp` mostra o estado e as ferramentas de cada servidor
- Dar acesso a dados reais é dar poder de escrita: restringe ao mínimo

## Workflows

- Worktrees: vários diretórios do mesmo repositório, uma sessão em cada, sem pisar ficheiros
- `claude --worktree` cria e gere o worktree por ti
- Headless: `claude -p` recebe o prompt e escreve a resposta em stdout, sem interface
- `--output-format json` e `--json-schema` dão output que um script consegue interpretar
- Em CI não há ninguém para aprovar ferramentas: liga só as que precisas
- A chave de API vive nos secrets da pipeline, nunca no repositório

## Plugins

- Empacotam skills, subagents, hooks e servidores MCP num só sítio
- `.claude-plugin/plugin.json` com o manifesto; componentes descobertos pelas pastas por omissão
- `${CLAUDE_PLUGIN_ROOT}` aponta para onde o plugin foi instalado
- Distribuídos por marketplaces: `claude plugin marketplace add` e `claude plugin install`
- `claude plugin validate` antes de publicar; `claude --plugin-dir` para testar sem instalar
