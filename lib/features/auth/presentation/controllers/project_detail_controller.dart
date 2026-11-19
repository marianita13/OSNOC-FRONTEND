import 'package:flutter/material.dart';
import '../../models/project.dart';

class ProjectDetailController extends ChangeNotifier {
  final Project project;
  final String action; // 'view', 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController fileNameController;

  // Estado del checkbox "Activo"
  bool isActive = true;

  ProjectDetailController({
    required this.project,
    required this.action,
  }) {
    // Inicializamos los valores usando el proyecto recibido
    nameController = TextEditingController(text: project.name);
    descriptionController = TextEditingController(text: project.description);
    fileNameController = TextEditingController(text: project.fileName);
    isActive = project.isActive;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // Si es 'edit' o 'new', los campos se pueden editar; en 'view' o 'delete' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nuevo Proyecto';
    if (isEdit) return 'Proyecto en Edición';
    if (isDelete) return 'Eliminar Proyecto';
    return 'Información Proyecto';
  }

  String get submitLabel {
    if (isDelete) return 'CONFIRMAR ELIMINACIÓN';
    if (isNew) return 'CREAR PROYECTO';
    return 'GUARDAR CAMBIOS';
  }

  // Método para cambiar el estado del checkbox
  void toggleActive(bool? value) {
    if (isEnabled && value != null) {
      isActive = value;
      notifyListeners();
    }
  }

  // Acción para guardar los cambios o confirmar eliminación.
  // Devuelve el proyecto resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      // Confirma la eliminación devolviendo el proyecto original
      Navigator.pop(context, project);
      return;
    }

    if (isEnabled) {
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      if (name.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre y la descripción son obligatorios')),
        );
        return;
      }

      final updated = Project(
        id: project.id,
        name: name,
        description: description,
        fileName: fileNameController.text.trim(),
        registrationDate: project.registrationDate,
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
    nameController.dispose();
    descriptionController.dispose();
    fileNameController.dispose();
    super.dispose();
  }
}
