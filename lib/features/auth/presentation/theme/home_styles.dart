import 'package:flutter/material.dart';

class HomeStyles {
  // Colores principales
  static const Color osnocGreen = Color(0xFF1E824C);
  static const Color osnocHeaderBg = Color(0xFF2C3E50);
  static const Color cardHeaderBlue = Color(0xFF1E3A8A);
  static const Color scaffoldBg = Color(0xFFF4F6F7);

  // Colores adicionales (Agregados para SeismicEventCard)
  static const Color osnocBlue = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1E293B);
  static const Color borderSide = Color(0xFFE2E8F0);

  // Tipografías
  static const TextStyle mainTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: cardHeaderBlue,
  );

  static const TextStyle bulletText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle subheadingText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.black87,
  );

  // Estilos específicos para la tarjeta de evento sísmico
  static const TextStyle seismicTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: osnocBlue,
    letterSpacing: 0.3,
  );

  static const TextStyle seismicItemStyle = TextStyle(
    fontSize: 13,
    color: darkText,
    height: 1.3,
  );

  static const TextStyle seismicSubheadingStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: darkText,
  );

  // Estilo para el nombre de usuario en el AppBar
  static const TextStyle headerUserStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  // ---------- Estilos de las secciones del inicio ----------
  static const Color mutedText = Color(0xFF64748B);
  static const Color infoIconBg = Color(0xFFF1F3F5);

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: cardHeaderBlue,
  );

  static const TextStyle infoTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle infoText = TextStyle(
    fontSize: 12.5,
    height: 1.45,
    color: Color(0xFF334155),
  );

  static const TextStyle itemTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: darkText,
  );

  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    color: mutedText,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 11,
    fontStyle: FontStyle.italic,
    color: mutedText,
  );

  // Bloque blanco con borde para cada sección
  static BoxDecoration sectionDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: borderSide),
  );

  // Decoración de tarjeta de logo UDES
  static BoxDecoration udesBannerDecoration = BoxDecoration(
    color: cardHeaderBlue,
    borderRadius: BorderRadius.circular(8),
  );
}