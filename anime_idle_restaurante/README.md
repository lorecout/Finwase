# Anime Idle Restaurante

## Visão Geral
Um jogo idle fofo de gerenciamento de restaurante com estética anime super colorida. O jogador começa com um pequeno café temático e expande para uma rede de restaurantes mágicos, automatizando cozinheiros, garçons mascotes e estações especializadas.

## Fantasia Principal
- Você é o(a) gerente prodígio de um "Restaurante dos Espíritos" onde personagens chibi ajudam a cozinhar pratos fantásticos.
- Atmosfera: aconchegante, pastel vibrante, partículas suaves (corações, estrelas, vapor kawaii).
- Personagens colecionáveis com traços de personalidade que impactam produção.

## Loop Central (Core Loop)
1. Produzir pratos automaticamente (cada estação gera pratos por minuto).
2. Servir clientes -> ganhar Moedas (currency primária).
3. Usar Moedas para melhorar estações / contratar staff -> aumenta produção por tick.
4. Desbloquear novos pratos e áreas -> aumenta valor por prato.
5. Reset/Prestígio ("Banquete Celestial") -> converte progresso em Essências que dão bônus permanente.

## Economias
- Moedas: ganho base por pratos servidos.
- Gemas: premium (compras, eventos, conquistas).
- Essências: obtidas em prestígio; multiplicadores passivos.
- Tickets de Evento: temporários para missões sazonais.

## Mecânicas-Chave
- Estações (Fogão, Chapa, Forno Mágico, Bar de Sobremesas).
- Staff: Cozinheiro, Assistente, Garçom, Mascote Motivador (buff global).
- Upgrades: velocidade, valor do prato, capacidade de fila.
- Combo de Receitas: sequência correta por tempo limitado para bônus.
- Clientes VIP: aparecem raramente e pagam multiplicado.
- Missões Diárias / Semanais.
- Sistema de Eventos (Temporada Sakura, Festival de Lanternas).
- Prestígio após atingir meta de reputação.

## Progressão
- Fases visuais do restaurante (Nível 1 Barraca, Nível 2 Café, Nível 3 Restaurante, Nível 4 Salão Imperial, etc.).
- Desbloqueio de novas receitas por nível de reputação.
- Árvores de Pesquisa (Automação, Qualidade, Marketing).

## Monetização (Justa)
- IAP: Pacotes de Gemas, Personagens exclusivos, Passe de Temporada.
- Ads recompensadas: multiplicador temporário de produção, acelerar cooldown de eventos.
- Sem paywall duro: progression sempre avança mesmo sem gastar.

## Arte e UI
- Paleta principal: Rosa (#FF8FB1), Azul claro (#8FD9FF), Amarelo suave (#FFE68F), Verde menta (#9FFFCB), Lilás (#CDA8FF).
- Fonte título: estilizada (ex: "Fredoka" ou "Baloo 2").
- Cartões arredondados, fundos com gradientes diagonais suaves.
- Partículas sutis no background (canvas overlay).

## Estrutura Técnica (Flutter)
- Camadas: presentation (UI), domain (lógica), data (persistência).
- State Management: Riverpod ou Bloc (preferência: Riverpod pela simplicidade).
- Persistência local: Hive ou Isar para performance (preferência: Isar).
- Sincronização opcional: Firebase (Cloud Firestore + Auth anônimo / Google).
- Sistema Idle: Timer gerenciado + cálculo offline (timestamp delta ao relogar).

## Cálculo Offline
Ao abrir o app: `recursos_ganhos = producao_por_segundo * (agora - ultimo_timestamp_salvo)` com limites para evitar overflow.

## Estrutura de Dados (Exemplo)
```dart
class Station {
  final String id;
  int level;
  double baseRatePerSec;
  double valuePerDish;
  double multipliers; // somatório de buffs
}

class StaffMember {
  final String id;
  final String role; // chef, waiter, mascot
  int rarity; // 1-5
  double productionBuff;
  double speedBuff;
}
```

## Roadmap Alto Nível
1. Prototipar loop de produção + upgrade.
2. Implementar persistência e cálculo offline.
3. Adicionar staff e buffs.
4. Interface principal (dashboard restaurante).
5. Sistema de prestígio.
6. Eventos temporários.
7. Monetização ética.
8. Polimento final (animações, partículas, áudio).

## Próximos Passos
- Refinar números iniciais de produção vs upgrades.
- Criar mock de telas no Figma (opcional).
- Iniciar base do projeto Flutter.

## Referências de Inspiração
- "Food Truck Pup" (estética fofa)
- "Cats & Soup" (idle relaxante)
- "Potion Permit" (paleta e charme)

---
Esta especificação será expandida conforme definirmos detalhes de balanceamento e conteúdo sazonal.
