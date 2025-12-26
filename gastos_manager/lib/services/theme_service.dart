import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe para temas personalizados
class CustomThemeData {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Brightness brightness;
  final Color? tertiaryColor;
  final Color? errorColor;

  const CustomThemeData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.brightness,
    this.tertiaryColor,
    this.errorColor,
  });

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor, // Usar surface como background
        error: errorColor ?? Colors.red,
        onPrimary: _getContrastColor(primaryColor),
        onSecondary: _getContrastColor(secondaryColor),
        onSurface: brightness == Brightness.dark
            ? Colors.white
            : Colors.black, // Manter compatibilidade
        onError: Colors.white,
        brightness: brightness,
        tertiary: tertiaryColor,
        onTertiary: tertiaryColor != null
            ? _getContrastColor(tertiaryColor!)
            : null,
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryColor': primaryColor.toARGB32(),
      'secondaryColor': secondaryColor.toARGB32(),
      'backgroundColor': backgroundColor.toARGB32(),
      'surfaceColor': surfaceColor.toARGB32(),
      'brightness': brightness.name,
      'tertiaryColor': tertiaryColor?.toARGB32(),
      'errorColor': errorColor?.toARGB32(),
    };
  }

  factory CustomThemeData.fromJson(Map<String, dynamic> json) {
    return CustomThemeData(
      name: json['name'],
      primaryColor: Color(json['primaryColor']),
      secondaryColor: Color(json['secondaryColor']),
      backgroundColor: Color(json['backgroundColor']),
      surfaceColor: Color(json['surfaceColor']),
      brightness: Brightness.values.firstWhere(
        (b) => b.name == json['brightness'],
        orElse: () => Brightness.light,
      ),
      tertiaryColor: json['tertiaryColor'] != null
          ? Color(json['tertiaryColor'])
          : null,
      errorColor: json['errorColor'] != null ? Color(json['errorColor']) : null,
    );
  }
}

class ThemeService with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  static const String _premiumThemeKey = 'premium_theme';

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blue;
  String _premiumTheme = 'default';
  final Map<String, ThemeData> _premiumThemes = {};
  final Map<String, CustomThemeData> _customThemes = {};

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  String get premiumTheme => _premiumTheme;
  Map<String, ThemeData> get premiumThemes => Map.unmodifiable(_premiumThemes);
  Map<String, CustomThemeData> get customThemes =>
      Map.unmodifiable(_customThemes);

  // Cores por categoria
  static const Map<String, Color> categoryColors = {
    'Alimentação': Color(0xFFFF6B6B),
    'Transporte': Color(0xFF4ECDC4),
    'Moradia': Color(0xFF45B7D1),
    'Saúde': Color(0xFF96CEB4),
    'Educação': Color(0xFFFECA57),
    'Entretenimento': Color(0xFFFF9FF3),
    'Compras': Color(0xFFFC427B),
    'Outros': Color(0xFF6C5CE7),
    'Salário': Color(0xFF00B894),
    'Freelance': Color(0xFF00CEC9),
    'Investimentos': Color(0xFF74B9FF),
    'Vendas': Color(0xFFE84393),
  };

  // Temas premium
  ThemeService() {
    _initializePremiumThemes();
  }

  void _initializePremiumThemes() {
    // Tema oceano (premium)
    _premiumThemes['ocean'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006994),
        brightness: Brightness.light,
        primary: const Color(0xFF006994),
        secondary: const Color(0xFF4FC3F7),
        tertiary: const Color(0xFF00BCD4),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF006994),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );

    // Tema pôr do sol (premium)
    _premiumThemes['sunset'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6B35),
        brightness: Brightness.light,
        primary: const Color(0xFFFF6B35),
        secondary: const Color(0xFFFFB627),
        tertiary: const Color(0xFFFF8F00),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );

    // Tema floresta (premium)
    _premiumThemes['forest'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32),
        brightness: Brightness.light,
        primary: const Color(0xFF2E7D32),
        secondary: const Color(0xFF4CAF50),
        tertiary: const Color(0xFF66BB6A),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );

    // Tema meia-noite (premium - dark)
    _premiumThemes['midnight'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A237E),
        brightness: Brightness.dark,
        primary: const Color(0xFF3949AB),
        secondary: const Color(0xFF5E35B1),
        tertiary: const Color(0xFF7E57C2),
        surface: const Color(0xFF121212),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFF1E1E1E),
      ),
    );

    // Tema rosa (premium)
    _premiumThemes['rose'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE91E63),
        brightness: Brightness.light,
        primary: const Color(0xFFE91E63),
        secondary: const Color(0xFFF06292),
        tertiary: const Color(0xFFF8BBD9),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );

    // Tema ouro (premium)
    _premiumThemes['gold'] = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFD700),
        brightness: Brightness.light,
        primary: const Color(0xFFFFD700),
        secondary: const Color(0xFFFFC107),
        tertiary: const Color(0xFFFF9800),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFFFD700),
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );
  }

  // Tema claro
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _accentColor,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey[800],
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _accentColor, width: 2),
      ),
    ),
  );

  // Tema escuro
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _accentColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: Colors.grey[850],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _accentColor, width: 2),
      ),
    ),
  );

  // Inicializar tema
  Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final colorValue =
          prefs.getInt(_accentColorKey) ??
          Colors.blue.toARGB32(); // Usar azul como padrão
      final premiumTheme = prefs.getString(_premiumThemeKey) ?? 'default';

      _themeMode = ThemeMode.values[themeIndex];
      _accentColor = Color(colorValue);
      _premiumTheme = premiumTheme;
      debugPrint('ThemeService: Tema inicializado com sucesso');
      notifyListeners();
    } catch (e) {
      debugPrint('ThemeService: Erro ao inicializar tema: $e');
      // Usar valores padrão em caso de erro
      _themeMode = ThemeMode.system;
      _accentColor = Colors.blue;
      _premiumTheme = 'default';
      notifyListeners();
    }
  }

  // Alterar modo do tema
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  // Alterar cor de destaque (restrito para usuários premium)
  Future<bool> setAccentColor(Color color, bool isPremium) async {
    // Verificar se o usuário é premium antes de permitir mudança de cor
    if (!isPremium) {
      // Usuário free só pode usar a cor padrão (azul)
      return false;
    }

    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.toARGB32());
    notifyListeners();
    return true;
  }

  // Resetar para cor padrão (para usuários que perderam premium)
  Future<void> resetToDefaultColor() async {
    _accentColor = Colors.blue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, Colors.blue.toARGB32());
    notifyListeners();
  }

  // Definir tema premium
  Future<void> setPremiumTheme(String themeName) async {
    if (!_premiumThemes.containsKey(themeName) &&
        !_customThemes.containsKey(themeName) &&
        themeName != 'default') {
      throw ArgumentError('Tema premium não encontrado: $themeName');
    }

    _premiumTheme = themeName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_premiumThemeKey, themeName);

    notifyListeners();
  }

  // Criar tema personalizado
  Future<void> createCustomTheme({
    required String name,
    required Color primaryColor,
    required Color secondaryColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required Brightness brightness,
    Color? tertiaryColor,
    Color? errorColor,
  }) async {
    final customTheme = CustomThemeData(
      name: name,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: backgroundColor,
      surfaceColor: surfaceColor,
      brightness: brightness,
      tertiaryColor: tertiaryColor,
      errorColor: errorColor,
    );

    _customThemes[name] = customTheme;

    // Salvar no SharedPreferences
    await _saveCustomThemes();

    notifyListeners();
  }

  // Remover tema personalizado
  Future<void> removeCustomTheme(String name) async {
    if (!_customThemes.containsKey(name)) {
      throw ArgumentError('Tema personalizado não encontrado: $name');
    }

    _customThemes.remove(name);

    // Se o tema atual foi removido, voltar para o padrão
    if (_premiumTheme == name) {
      await setPremiumTheme('default');
    }

    await _saveCustomThemes();
    notifyListeners();
  }

  // Salvar temas personalizados
  Future<void> _saveCustomThemes() async {
    // TODO: Implementar serialização de temas personalizados
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_customThemesKey, jsonEncode(_customThemes));
  }

  // Obter tema atual (considerando premium)
  ThemeData get currentTheme {
    if (_premiumTheme != 'default') {
      if (_customThemes.containsKey(_premiumTheme)) {
        return _customThemes[_premiumTheme]!.toThemeData();
      } else if (_premiumThemes.containsKey(_premiumTheme)) {
        return _premiumThemes[_premiumTheme]!;
      }
    }

    // Retornar tema padrão baseado no modo
    return _themeMode == ThemeMode.dark ? darkTheme : lightTheme;
  }

  // Cores pré-definidas para seleção
  List<Color> get predefinedColors => [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
  ];
}
