import 'package:flutter/material.dart';

class ProjectsStyles {
  // Colores primarios y de la AppBar (mismos que Contenidos Sitio y Publicaciones)
  static const Color primaryBlue = Color(0xFF0056B3);
  static const Color appBarBg = Color(0xFF0D47A1);
  static const Color exportGreen = Color(0xFF1E7E34);
  static const Color titleColor = Color(0xFF0F172A);
  static const Color subtextColor = Color(0xFF64748B);
  static const Color bodyTextColor = Color(0xFF334155);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dataLabelColor = Color(0xFF94A3B8);

  // Colores de los botones de acción
  static const Color editBlue = Color(0xFF007BFF);
  static const Color viewCyan = Color(0xFF17A2B8);
  static const Color deleteRed = Color(0xFFDC3545);

  // Colores de estado (columna "Activo")
  static const Color activeBg = Color(0xFFDCFCE7);
  static const Color activeText = Color(0xFF15803D);
  static const Color inactiveBg = Color(0xFFFEE2E2);
  static const Color inactiveText = Color(0xFFB91C1C);

  // Colores de la etiqueta del archivo adjunto
  static const Color fileBg = Color(0xFFF1F5F9);
  static const Color fileIcon = Color(0xFFDC2626);

  // Estilos de texto
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle idBadgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
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
