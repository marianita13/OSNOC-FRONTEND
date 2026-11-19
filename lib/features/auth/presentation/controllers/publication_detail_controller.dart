import 'package:flutter/material.dart';
import '../../models/publication.dart';

class PublicationDetailController extends ChangeNotifier {
  final Publication publication;
  final String action; // 'view', 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController titleController;
  late final TextEditingController userController;
  late final TextEditingController rolesController;

  // Estado de la fecha de publicación y del checkbox
  late DateTime publicationDate;
  bool isActive = true;

  PublicationDetailController({
    required this.publication,
    required this.action,
  }) {
    // Inicializamos los valores usando la publicación recibida
    titleController = TextEditingController(text: publication.title);
    userController = TextEditingController(text: publication.user);
    rolesController = TextEditingController(text: publication.roles);
    publicationDate = publication.publicationDate;
    isActive = publication.isActive;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // Si es 'edit' o 'new', los campos se pueden editar; en 'view' o 'delete' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nueva Publicación';
    if (isEdit) return 'Publicación en Edición';
    if (isDelete) return 'Eliminar Publicación';
    return 'Información Publicación';
  }

  String get formattedPublicationDate {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(publicationDate.day)}/${twoDigits(publicationDate.month)}/${publicationDate.year}';
  }

  // Abre el selector de fecha para la fecha de publicación
  Future<void> pickPublicationDate(BuildContext context) async {
    if (!isEnabled) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: publicationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      publicationDate = picked;
      notifyListeners();
    }
  }

  // Método para cambiar el estado del checkbox
  void toggleActive(bool? value) {
    if (isEnabled && value != null) {
      isActive = value;
      notifyListeners();
    }
  }

  // Acción para guardar los cambios o confirmar eliminación.
  // Devuelve la publicación resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      // Confirma la eliminación devolviendo la publicación original
      Navigator.pop(context, publication);
      return;
    }

    if (isEnabled) {
      final title = titleController.text.trim();
      if (title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El titular es obligatorio')),
        );
        return;
      }

      final updated = Publication(
        id: publication.id,
        title: title,
        publicationDate: publicationDate,
        user: userController.text.trim(),
        roles: rolesController.text.trim(),
        registrationDate: publication.registrationDate,
        isActive: isActive,
      );
      Navigator.pop(context, updated);
      return;
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Liberamos memoria de todos los controladores de texto
    titleController.dispose();
    userController.dispose();
    rolesController.dispose();
    super.dispose();
  }
}

