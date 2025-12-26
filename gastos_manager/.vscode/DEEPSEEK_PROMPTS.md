# DeepSeek / Ollama - Exemplos de Prompts

Cole aqui prompts prontos para usar com DeepSeek (local via Ollama ou extensão DeepSeek). Copie e cole no chat, ou use os snippets `.vscode/deepseek-snippets.code-snippets`.

## Boas práticas
- Seja específico: inclua linguagem, objetivo e restrições.
- Ao pedir refatoração, inclua trechos essenciais de código.
- Peça exemplos de testes e casos de borda quando solicitar mudanças de lógica.

## Templates úteis

### 1) Explicar função (português)
"""
Explique o que faz a função abaixo em português simples e dê um resumo em 2 frases e uma lista de potenciais problemas ou casos de borda:

```dart
<cole_aqui_a_funcao>
```
"""

### 2) Refatorar para clareza e performance
"""
Refatore o código abaixo para melhorar legibilidade e desempenho sem alterar o comportamento. Explique as mudanças e forneça versão refatorada com comentários mínimos.

```dart
<cole_aqui_o_trecho>
```
"""

### 3) Gerar testes unitários (Dart/Flutter)
"""
Escreva testes unitários e de widget usando `flutter_test` para o componente abaixo. Inclua mocks necessários e casos de sucesso/erro.

```dart
<cole_aqui_o_widget_ou_servico>
```
"""

### 4) Criar commit message a partir de mudanças
"""
Gere um commit message conciso (linha subject <= 50 chars) e um corpo com bullet points descrevendo as principais mudanças e motivo, baseado neste diff/descrição:

<cole_aqui_descricao_ou_diff>
"""

### 5) Debug de Anúncios (AdMob)
"""
Analise estes trechos de log do Android/Flutter relacionados a anúncios e explique causas prováveis e ações práticas para teste em ambiente de desenvolvimento (usar ad units de teste, verificar App ID no manifest, etc.):

<cole_aqui_os_logs>
"""

### 6) Gerar README curto para nova feature
"""
Escreva um README curto (1-2 parágrafos + exemplos de uso e comandos) para a feature descrita abaixo.

<descrição_da_feature>
"""

### 7) Pedir melhoria de UX / A11y
"""
Analise a tela descrita abaixo e sugira melhorias de usabilidade e acessibilidade (contraste, labels, foco, leitura por screen readers):

<descrição_da_tela>
"""

## Prompt de sistema (para chat persistente)
"""
Você é um assistente de desenvolvimento técnico e especialista em Flutter/Dart. Responda em português, seja conciso e inclua trechos de código quando relevante. Sempre liste passos de verificação e comandos de terminal quando pedir ações para testar alterações.
"""

## Como usar
- Copie o template, substitua os marcadores `<...>` pelos seus dados e cole no DeepSeek/Ollama.
- Para validar rapidamente, peça também exemplos de testes e comandos para reproduzir localmente.
