import 'package:flutter/material.dart';

// Constantes de colores y estilos para la aplicación
class Estilos {
  // Colores principales según las reglas de diseño
  static const Color verdePrincipal = Color(0xFF4CAF50);
  static const Color verdeOscuro = Color(0xFF388E3C);
  static const Color verdeClaro = Color(0xFFC8E6C9);
  static const Color grisClaro = Color(0xFFF5F5F5);
  static const Color grisMedio = Color(0xFF9E9E9E);
  static const Color blanco = Colors.white;
  static const Color negro = Colors.black87;
  
  // Tamaños y espaciados
  static const double paddingPequeno = 8.0;
  static const double paddingMedio = 16.0;
  static const double paddingGrande = 24.0;
  static const double paddingMuyGrande = 32.0;
  
  static const double margenPequeno = 8.0;
  static const double margenMedio = 16.0;
  static const double margenGrande = 24.0;
  
  static const double radioBorde = 8.0;
  static const double radioBordeGrande = 16.0;
  
  // Tamaños de texto
  static const double textoPequeno = 12.0;
  static const double textoMedio = 14.0;
  static const double textoGrande = 16.0;
  static const double textoMuyGrande = 24.0;
  
  // Tema de la aplicación
  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: verdePrincipal,
        primary: verdePrincipal,
        secondary: verdeOscuro,
        surface: blanco,
        background: grisClaro,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: verdePrincipal,
        foregroundColor: blanco,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verdePrincipal,
          foregroundColor: blanco,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioBorde),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: blanco,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: grisMedio),
        labelStyle: TextStyle(color: verdeOscuro),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioBorde),
          borderSide: const BorderSide(color: grisMedio),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioBorde),
          borderSide: const BorderSide(color: verdePrincipal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioBorde),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radioBorde),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioBordeGrande),
        ),
        margin: const EdgeInsets.all(margenMedio),
      ),
    );
  }
  
  // Decoración de cajas
  static BoxDecoration get decoracionCaja {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [blanco, grisClaro],
      ),
      borderRadius: BorderRadius.circular(radioBordeGrande),
    );
  }
  
  // Animaciones
  static const Duration animacionRapida = Duration(milliseconds: 200);
  static const Duration animacionMedia = Duration(milliseconds: 300);
  static const Duration animacionLenta = Duration(milliseconds: 500);
  
  // Sombras
  static List<BoxShadow> get sombraSuave {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }
  
  static List<BoxShadow> get sombraMedia {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }
}