class Publication {
  final int id;
  final String title;
  final DateTime publicationDate;
  final String user;
  final String roles;
  final DateTime registrationDate;
  final bool isActive;

  Publication({
    required this.id,
    required this.title,
    required this.publicationDate,
    required this.user,
    required this.roles,
    required this.registrationDate,
    required this.isActive,
  });

  // Fechas con el formato de la tabla: dd/MM/yyyy H:mm:ss
  String get formattedPublicationDate => _formatDate(publicationDate);
  String get formattedRegistrationDate => _formatDate(registrationDate);

  static String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${date.hour}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }
}
