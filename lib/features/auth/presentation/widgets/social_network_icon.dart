import 'dart:typed_data';

import 'package:flutter/material.dart';

// Ícono de cada red social.
// - Si la red tiene logo (foto subida), muestra la foto en un círculo.
// - Si no, muestra un círculo con el color de la marca y sus iniciales.
class SocialNetworkIcon extends StatelessWidget {
  final String iconKey;
  final double size;
  final Uint8List? logo;

  const SocialNetworkIcon({
    super.key,
    required this.iconKey,
    this.size = 32,
    this.logo,
  });

  // Claves disponibles para elegir en el formulario
  static const List<String> iconKeys = <String>[
    'facebook',
    'google',
    'instagram',
    'linkedin',
    'skype',
    'twitter',
    'whatsapp',
    'wordpress',
    'youtube',
  ];

  // Nombre legible de cada clave (para el desplegable)
  static String labelFor(String key) {
    switch (key) {
      case 'facebook':
        return 'Facebook';
      case 'google':
        return 'Google';
      case 'instagram':
        return 'Instagram';
      case 'linkedin':
        return 'LinkedIn';
      case 'skype':
        return 'Skype';
      case 'twitter':
        return 'Twitter';
      case 'whatsapp':
        return 'WhatsApp';
      case 'wordpress':
        return 'WordPress';
      case 'youtube':
        return 'YouTube';
      default:
        return 'Otra';
    }
  }

  static String _initials(String key) {
    switch (key) {
      case 'facebook':
        return 'f';
      case 'google':
        return 'G';
      case 'instagram':
        return 'IG';
      case 'linkedin':
        return 'in';
      case 'skype':
        return 'S';
      case 'twitter':
        return 'X';
      case 'whatsapp':
        return 'W';
      case 'wordpress':
        return 'W';
      case 'youtube':
        return '▶';
      default:
        return '?';
    }
  }

  static Color _color(String key) {
    switch (key) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'google':
        return const Color(0xFFDB4437);
      case 'instagram':
        return const Color(0xFFC13584);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'skype':
        return const Color(0xFF00AFF0);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'wordpress':
        return const Color(0xFF21759B);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? image = logo;
    if (image != null) {
      return ClipOval(
        child: Container(
          width: size,
          height: size,
          color: Colors.white,
          child: Image.memory(image, fit: BoxFit.cover, width: size, height: size),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color(iconKey),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(iconKey),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.42,
          height: 1,
        ),
      ),
    );
  }
}
