class SeismicReport {
  final int id;
  final String description;
  final DateTime originTime;
  final String epicenter;
  final DateTime registrationDate;
  final bool isActive;

  SeismicReport({
    required this.id,
    required this.description,
    required this.originTime,
    required this.epicenter,
    required this.registrationDate,
    required this.isActive,
  });

  // Fechas con el formato de la tabla web: dd/MM/yyyy H:mm:ss
  String get formattedOriginTime => formatDateTime(originTime);
  String get formattedRegistrationDate => formatDateTime(registrationDate);

  static String formatDateTime(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${date.hour}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }
}
