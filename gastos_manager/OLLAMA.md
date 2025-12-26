Usando Ollama localmente com DeepSeek
===================================

Este documento explica como usar o Ollama localmente e integrá-lo ao VS Code (útil para usar o DeepSeek localmente).

Pré-requisitos
--------------

- Ollama instalado no Windows (https://ollama.com/download)
- Extensão DeepSeek (Kingleo) no VS Code (opcional)

1) Verificar instalação
------------------------

Abra o terminal do VS Code e rode:

```powershell
ollama --version
```

Se o comando não for reconhecido, adicione o diretório de instalação ao `PATH` do usuário (ex.: `C:\Users\Lorena\AppData\Local\Programs\Ollama`). Feche e reabra o VS Code.

2) Iniciar o servidor Ollama
----------------------------

No terminal:

```powershell
ollama serve
```

Para iniciar em background (Windows PowerShell):

```powershell
Start-Process -FilePath 'C:\Users\<seu_usuario>\AppData\Local\Programs\Ollama\ollama.exe' -ArgumentList 'serve' -WindowStyle Hidden
```

3) Variáveis de ambiente (recomendado)
-------------------------------------

Defina as variáveis para permitir acesso local:

```powershell
[Environment]::SetEnvironmentVariable('OLLAMA_HOST','0.0.0.0','User')
[Environment]::SetEnvironmentVariable('OLLAMA_ORIGINS','*','User')
```

Reinicie o VS Code para aplicar.

4) Testar um modelo
--------------------

Lista de modelos:

```powershell
ollama list
```

Executar modelo (ex.: `gemma3`):

```powershell
ollama run gemma3 "Olá!" --keepalive 1m
```

5) Abrir a UI do Ollama no VS Code
----------------------------------

- Use a task `Open Ollama UI` (Terminal → Run Task...)
- Ou use `Open URL` e cole `http://127.0.0.1:11434`.

6) Integração com DeepSeek
--------------------------

- Em `.vscode/settings.json` já foi adicionada uma configuração apontando para `http://127.0.0.1:11434` e o modelo padrão foi definido como `gemma3` (já instalado localmente).
- Use o botão do DeepSeek na barra de status ou abra a URL no editor.
- Para testar rapidamente, execute a task `Run Ollama Test (gemma3)` no menu `Terminal → Run Task...`.

Usando DeepSeek no VS Code
--------------------------

- **Instale a extensão**: procure por `Kingleo.deepseek` nas extensões do VS Code (recomendada em `.vscode/extensions.json`).
- **Inicie o servidor**: rode a task `Start Ollama Serve` ou execute `ollama serve` em um terminal.
- **Abra o DeepSeek**: use o botão na barra de status da extensão ou o comando correspondente (pode variar por versão). Também é possível abrir a UI do Ollama com a task `Open Ollama UI`.
- **Use os snippets**: temos prompts úteis em `.vscode/deepseek-snippets.code-snippets` e templates em `.vscode/DEEPSEEK_PROMPTS.md` — experimente `ds-tests` para gerar testes unitários.
- **Configuração rápida**: em `.vscode/settings.json` definimos `deepseek.model` e `deepseek.ollama.model` para `gemma3` — isso faz o DeepSeek apontar para o modelo local.

Exemplo rápido
--------------

1. Selecione um trecho de código no editor (por exemplo um widget).
2. Abra o DeepSeek e cole o template `ds-tests` (ou use o snippet `ds-tests`).
3. Envie a mensagem — o `gemma3` (local) irá gerar os testes. Para testar localmente, aplique os trechos sugeridos e rode `flutter test`.

Se quiser, eu configuro um comando de atalho ou adiciono um template específico para gerar testes do `gastos_manager` automaticamente.

Snippet útil: `ds-tests-selection`
--------------------------------

Você pode selecionar um widget (ou qualquer trecho de código) e usar o snippet `ds-tests-selection` para inserir automaticamente a seleção no template de geração de testes. Recomendo mapear um atalho de teclado para acelerar o fluxo (posso adicionar se quiser).

Keybinding (atalho) para enviar seleção ao DeepSeek
---------------------------------------------------

1. Adicionei um exemplo de keybinding em `.vscode/keybindings.json` que mapeia `Ctrl+Alt+D` para o comando `deepseek.runSelection` quando há seleção no editor.
2. Observação: o `command` usado é um placeholder — se o DeepSeek usar outro id de comando, abra o **Command Palette** (Ctrl+Shift+P), digite `DeepSeek` para localizar o comando certo (por exemplo `DeepSeek: Run selection`), e substitua `deepseek.runSelection` pelo id real no arquivo `.vscode/keybindings.json`.
3. Para testar: selecione o código, pressione `Ctrl+Alt+D` e verifique se a UI do DeepSeek abre com o prompt preenchido.

Se quiser, eu tento detectar automaticamente o comando real (se a extensão estiver instalada) e atualizo o keybinding — quer que eu tente? 

7) Troubleshooting
------------------

- `ollama` não encontrado: adicione o diretório de instalação ao `PATH` do usuário.
- `pull` falha: modelo não publicado no registry.
- Chat para após reinício do VS Code: abra manualmente via `Open URL`.

Posso ajudar a automatizar tarefas e a baixar/puxar modelos específicos se você quiser.
