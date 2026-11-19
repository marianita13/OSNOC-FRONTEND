import 'dart:typed_data';

class SocialNetwork {
  final int id;
  final String name;
  final String icon; // clave del ícono: 'facebook', 'instagram', 'whatsapp', ...
  final String postUrl;
  final int order;
  final bool isActive;
  final Uint8List? logo; // foto del logo elegida desde la galería (opcional)

  SocialNetwork({
    required this.id,
    required this.name,
    required this.icon,
    required this.postUrl,
    required this.order,
    required this.isActive,
    this.logo,
  });

  // Texto de la columna "Activa" tal como aparece en la tabla web
  String get activeLabel => isActive ? 'Sí' : 'No';
}
