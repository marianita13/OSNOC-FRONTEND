import 'package:flutter/material.dart';

class SiteContentsStyles {
  // Colores primarios y de la AppBar (mismos que Estaciones)
  static const Color primaryBlue = Color(0xFF0056B3);
  static const Color appBarBg = Color(0xFF0D47A1);
  static const Color exportGreen = Color(0xFF1E7E34);
  static const Color titleColor = Color(0xFF0F172A);
  static const Color subtextColor = Color(0xFF64748B);
  static const Color bodyTextColor = Color(0xFF334155);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Colores de los botones de acción
  static const Color editBlue = Color(0xFF007BFF);
  static const Color viewCyan = Color(0xFF17A2B8);

  // Colores de la etiqueta de destino
  static const Color mainPageBg = Color(0xFFDBEAFE);
  static const Color mainPageText = Color(0xFF1D4ED8);
  static const Color secondaryPageBg = Color(0xFFF1F5F9);
  static const Color secondaryPageText = Color(0xFF475569);

  // Estilos de texto
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle actionBtnText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle idBadgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
