import 'package:flutter/material.dart';

class EventLogsStyles {
  // Colores primarios y de la AppBar (mismos que las demás secciones)
  static const Color primaryBlue = Color(0xFF0056B3);
  static const Color appBarBg = Color(0xFF0D47A1);
  static const Color titleColor = Color(0xFF0F172A);
  static const Color subtextColor = Color(0xFF64748B);
  static const Color bodyTextColor = Color(0xFF334155);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dataLabelColor = Color(0xFF94A3B8);

  // Panel de filtros (fondo azul claro como en la web)
  static const Color filterPanelBg = Color(0xFFE3ECF8);
  static const Color disabledFieldBg = Color(0xFFE9ECEF);

  // Botones de filtros
  static const Color applyGrey = Color(0xFF6C757D);
  static const Color removeRed = Color(0xFFE4606D);

  // Etiqueta de la tabla afectada
  static const Color tableTagBg = Color(0xFFDBEAFE);
  static const Color tableTagText = Color(0xFF1D4ED8);

  // Estilos de texto
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle filterLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle fieldText = TextStyle(
    fontSize: 13,
    color: titleColor,
  );

  static const TextStyle actionBtnText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: titleColor,
  );

  static const TextStyle recordsInfoText = TextStyle(
    fontSize: 12,
    color: subtextColor,
    fontWeight: FontWeight.w500,
  );
}
