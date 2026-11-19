import 'package:flutter/material.dart';

class PublicationDetailStyles {
  // Colores principales de la temática (mismos que el detalle de Estaciones)
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color borderColor = Color(0xFFE2E8F0);

  // Colores de texto
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);

  // Colores de marca y estados
  static const Color brandBlue = Color(0xFF0F2C59);
  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color focusBorder = Color(0xFF2563EB);
  static const Color brandGreen = Color(0xFF84CC16);

  // Estilos de texto
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: textSecondary,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 13,
    color: textSecondary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  // Decoraciones comunes
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderColor),
  );
}

