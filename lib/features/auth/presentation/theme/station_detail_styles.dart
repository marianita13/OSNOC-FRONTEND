import 'package:flutter/material.dart';

class StationDetailStyles {
  // Colores principales de la temática
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color borderColor = Color(0xFFE2E8F0);
  
  // Colores de texto y sus alias para compatibilidad
  static const Color darkText = Color(0xFF1E293B);
  static const Color textPrimary = darkText;

  static const Color mutedText = Color(0xFF475569);
  static const Color textSecondary = mutedText;

  static const Color lightMutedText = Color(0xFF94A3B8);
  static const Color textHint = lightMutedText;

  // Colores de marca y estados
  static const Color primaryBlue = Color(0xFF0F2C59);
  static const Color brandBlue = primaryBlue;

  static const Color inputFill = Color(0xFFF1F5F9);

  static const Color focusBlue = Color(0xFF2563EB);
  static const Color focusBorder = focusBlue;

  static const Color successGreen = Color(0xFF84CC16);
  static const Color brandGreen = successGreen;

  // Estilos de texto
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkText,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: mutedText,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 13,
    color: Color(0xFF334155),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
    color: Colors.white,
  );

  // Decoraciones comunes
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderColor),
  );

  static BoxDecoration imageContainerDecoration = BoxDecoration(
    color: inputFill,
    borderRadius: BorderRadius.circular(8),
  );
}