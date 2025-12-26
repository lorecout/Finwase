# Configurando o Codeium (Windsurf) para este workspace

Passos rápidos para começar a usar o Codeium no VS Code:

1. Abra o VS Code e verifique se a extensão **Codeium** aparece em Extensões (Ctrl+Shift+X).
2. Faça login na extensão (se solicitado) seguindo o fluxo de login da extensão (normalmente em um input no canto inferior ou na paleta de comandos).
3. As configurações de workspace já habilitam sugestões inline (ghost text):
   - `editor.inlineSuggest.enabled: true` (arquivo `.vscode/settings.json`).
4. Teste escrevendo código (ex.: um comentário descrevendo uma função) e veja sugestões aparecerem automaticamente como ghost text; pressione `Tab` ou `Enter` para aceitar.
5. Para abrir o chat do Codeium, procure na paleta `>Codeium: Open Chat` ou no painel lateral da extensão.

Dicas:
- Se não ver sugestões: abra a paleta (Ctrl+Shift+P) e execute `Editor: Trigger Inline Suggest` ou `Trigger Suggest`.
- Se a extensão pedir permissões ou login, siga as instruções e depois reinicie o VS Code se necessário.

O que foi aplicado para você ✅
- Atalhos adicionados (workspace e usuário):
  - **Alt+\\** → Trigger Inline Suggest (forçar sugestões inline)
  - **Ctrl+Shift+C** → Abrir Chat do Codeium
  - **Ctrl+Alt+O** → Abrir Chat do Codeium no editor (pane)
  - **Alt+[ / Alt+]** → Navegar entre completions
- Configurações globais (usuário) habilitadas:
  - `editor.inlineSuggest.enabled: true`
  - `editor.acceptSuggestionOnEnter: "on"`
  - `editor.suggestSelection: "first"`
  - `editor.tabCompletion: "on"`
  - `codeium.enableInComments: true`
  - `codeium.enableCodeLens: true`

Se quiser, eu posso remover duplicatas de keybindings ou ajustar atalhos (ex.: usar outras combinações). Também posso reverter as alterações globais se preferir manter apenas no workspace.
