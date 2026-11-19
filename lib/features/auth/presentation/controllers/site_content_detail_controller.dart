import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/site_content.dart';
import 'site_contents_controller.dart';

class SiteContentDetailController extends ChangeNotifier {
  final SiteContent content;
  final String action; // 'view', 'edit', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController sectionController;
  late final TextEditingController textController;

  // Destino seleccionado en el desplegable
  late String destination;

  // Imagen del contenido (opcional)
  Uint8List? image;
  bool isPickingImage = false;
  final ImagePicker _picker = ImagePicker();

  SiteContentDetailController({
    required this.content,
    required this.action,
  }) {
    // Inicializamos los valores usando el contenido recibido
    sectionController = TextEditingController(text: content.section);
    textController = TextEditingController(text: content.text);
    destination = SiteContentsController.destinations.contains(content.destination)
        ? content.destination
        : SiteContentsController.mainPage;
    image = content.image;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isNew => action == 'new';

  // En 'edit' y 'new' los campos se pueden editar; en 'view' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  List<String> get destinations => SiteContentsController.destinations;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nuevo Contenido del Sitio';
    if (isEdit) return 'Contenido del Sitio en Edición';
    return 'Información Contenido del Sitio';
  }

  String get submitLabel => isNew ? 'CREAR CONTENIDO' : 'GUARDAR CAMBIOS';

  // Método para cambiar el destino
  void changeDestination(String? value) {
    if (isEnabled && value != null) {
      destination = value;
      notifyListeners();
    }
  }

  bool get hasImage => image != null;

  // Abre la galería o la cámara para elegir la imagen del contenido
  Future<void> pickImage(BuildContext context, ImageSource source) async {
    if (!isEnabled || isPickingImage) return;
    isPickingImage = true;
    notifyListeners();
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (file != null) {
        image = await file.readAsBytes();
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cargar la imagen')),
        );
      }
    } finally {
      isPickingImage = false;
      notifyListeners();
    }
  }

  // Quita la imagen del contenido
  void removeImage() {
    if (!isEnabled) return;
    image = null;
    notifyListeners();
  }

  // Acción para guardar los cambios.
  // Devuelve el contenido resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isEnabled) {
      final section = sectionController.text.trim();
      final text = textController.text.trim();
      if (section.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La sección es obligatoria')),
        );
        return;
      }
      // Debe tener texto, imagen o ambos
      if (text.isEmpty && image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agrega un texto o una imagen')),
        );
        return;
      }

      final updated = SiteContent(
        id: content.id,
        section: section,
        text: text,
        destination: destination,
        image: image,
      );
      Navigator.pop(context, updated);
      return;
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Liberamos memoria de todos los controladores de texto
    sectionController.dispose();
    textController.dispose();
    super.dispose();
  }
}
