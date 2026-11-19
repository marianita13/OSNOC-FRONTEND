class News {
  final int id;
  final String title;
  final String summary;
  final DateTime publicationDate;
  final DateTime registrationDate;
  final bool isActive;

  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.publicationDate,
    required this.registrationDate,
    required this.isActive,
  });

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

  // Fechas con el formato de la tabla web: yyyy-MM-dd  /  yyyy-MM-dd HH:mm:ss
  String get formattedPublicationDate =>
      '${publicationDate.year}-${_twoDigits(publicationDate.month)}-${_twoDigits(publicationDate.day)}';

  String get formattedRegistrationDate {
    final d = registrationDate;
    return '${d.year}-${_twoDigits(d.month)}-${_twoDigits(d.day)} '
        '${_twoDigits(d.hour)}:${_twoDigits(d.minute)}:${_twoDigits(d.second)}';
  }

  // Texto de la columna "Activa" tal como aparece en la tabla web
  String get activeLabel => isActive ? 'Sí' : 'No';
}
