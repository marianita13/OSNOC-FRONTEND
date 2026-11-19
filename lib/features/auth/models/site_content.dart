import 'dart:typed_data';

class SiteContent {
  final int id;
  final String section;
  final String text;
  final String destination;
  final Uint8List? image; // imagen opcional elegida desde la galería o la cámara

  SiteContent({
    required this.id,
    required this.section,
    required this.text,
    required this.destination,
    this.image,
  });
}
