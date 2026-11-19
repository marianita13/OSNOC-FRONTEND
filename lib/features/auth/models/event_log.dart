class EventLog {
  final int number;
  final String table;
  final String details;
  final String user;
  final List<String> roles;
  final DateTime registrationDate;

  EventLog({
    required this.number,
    required this.table,
    required this.details,
    required this.user,
    required this.roles,
    required this.registrationDate,
  });

  // Roles separados por coma, como en la tabla web
  String get rolesLabel => roles.join(', ');

  // Fecha con el formato de la tabla web: yyyy-MM-dd HH:mm:ss
  String get formattedRegistrationDate {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final d = registrationDate;
    return '${d.year}-${twoDigits(d.month)}-${twoDigits(d.day)} '
        '${twoDigits(d.hour)}:${twoDigits(d.minute)}:${twoDigits(d.second)}';
  }
}
