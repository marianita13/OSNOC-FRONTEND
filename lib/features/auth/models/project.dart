class Project {
  final int id;
  final String name;
  final String description;
  final String fileName;
  final DateTime registrationDate;
  final bool isActive;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.fileName,
    required this.registrationDate,
    required this.isActive,
  });

  // Fecha con el formato de la tabla: dd/MM/yyyy HH:mm:ss
  String get formattedRegistrationDate {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final date = registrationDate;
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }

  // Texto de la columna "Activo" tal como aparece en la tabla web
  String get activeLabel => isActive ? 'Sí' : 'No';
}
