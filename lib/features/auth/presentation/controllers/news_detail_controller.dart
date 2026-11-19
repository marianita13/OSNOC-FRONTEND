import 'package:flutter/material.dart';
import '../../models/news.dart';

class NewsDetailController extends ChangeNotifier {
  final News news;
  final String action; // 'view', 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController titleController;
  late final TextEditingController summaryController;

  // Estado de la fecha de publicación y del checkbox "Activa"
  late DateTime publicationDate;
  bool isActive = true;

  NewsDetailController({
    required this.news,
    required this.action,
  }) {
    // Inicializamos los valores usando la noticia recibida
    titleController = TextEditingController(text: news.title);
    summaryController = TextEditingController(text: news.summary);
    publicationDate = news.publicationDate;
    isActive = news.isActive;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // Si es 'edit' o 'new', los campos se pueden editar; en 'view' o 'delete' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nueva Noticia';
    if (isEdit) return 'Noticia en Edición';
    if (isDelete) return 'Eliminar Noticia';
    return 'Información Noticia';
  }

  String get submitLabel {
    if (isDelete) return 'CONFIRMAR ELIMINACIÓN';
    if (isNew) return 'CREAR NOTICIA';
    return 'GUARDAR CAMBIOS';
  }

  String get formattedPublicationDate {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${publicationDate.year}-${twoDigits(publicationDate.month)}-${twoDigits(publicationDate.day)}';
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
  // Devuelve la noticia resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      // Confirma la eliminación devolviendo la noticia original
      Navigator.pop(context, news);
      return;
    }

    if (isEnabled) {
      final title = titleController.text.trim();
      final summary = summaryController.text.trim();
      if (title.isEmpty || summary.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El título y el resumen son obligatorios')),
        );
        return;
      }

      final updated = News(
        id: news.id,
        title: title,
        summary: summary,
        publicationDate: publicationDate,
        registrationDate: news.registrationDate,
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
    summaryController.dispose();
    super.dispose();
  }
}
