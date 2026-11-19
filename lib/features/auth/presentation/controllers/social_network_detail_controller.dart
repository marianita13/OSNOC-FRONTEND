import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/social_network.dart';
import '../widgets/social_network_icon.dart';

class SocialNetworkDetailController extends ChangeNotifier {
  final SocialNetwork network;
  final String action; // 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController nameController;
  late final TextEditingController postUrlController;
  late final TextEditingController orderController;

  // Ícono elegido, foto del logo y estado del checkbox "Activa"
  late String icon;
  Uint8List? logo;
  bool isActive = true;
  bool isPickingLogo = false;

  final ImagePicker _picker = ImagePicker();

  SocialNetworkDetailController({
    required this.network,
    required this.action,
  }) {
    // Inicializamos los valores usando la red recibida
    nameController = TextEditingController(text: network.name);
    postUrlController = TextEditingController(text: network.postUrl);
    orderController = TextEditingController(text: network.order.toString());
    icon = SocialNetworkIcon.iconKeys.contains(network.icon)
        ? network.icon
        : SocialNetworkIcon.iconKeys.first;
    isActive = network.isActive;
    logo = network.logo;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // En 'edit' o 'new' se puede editar; en 'delete' todo es de solo lectura
  bool get isEnabled => isEdit || isNew;

  List<String> get iconKeys => SocialNetworkIcon.iconKeys;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nueva Red Social';
    if (isDelete) return 'Eliminar Red Social';
    return 'Red Social en Edición';
  }

  String get submitLabel {
    if (isDelete) return 'CONFIRMAR ELIMINACIÓN';
    if (isNew) return 'CREAR RED SOCIAL';
    return 'GUARDAR CAMBIOS';
  }

  void changeIcon(String? value) {
    if (isEnabled && value != null) {
      icon = value;
      notifyListeners();
    }
  }

  bool get hasLogo => logo != null;

  // Abre la galería (o la cámara) para elegir la foto del logo
  Future<void> pickLogo(BuildContext context, ImageSource source) async {
    if (!isEnabled || isPickingLogo) return;
    isPickingLogo = true;
    notifyListeners();
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file != null) {
        logo = await file.readAsBytes();
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cargar la imagen')),
        );
      }
    } finally {
      isPickingLogo = false;
      notifyListeners();
    }
  }

  // Quita la foto y vuelve al ícono con iniciales
  void removeLogo() {
    if (!isEnabled) return;
    logo = null;
    notifyListeners();
  }

  void toggleActive(bool? value) {
    if (isEnabled && value != null) {
      isActive = value;
      notifyListeners();
    }
  }

  // Acción para guardar los cambios o confirmar eliminación.
  // Devuelve la red resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      Navigator.pop(context, network);
      return;
    }

    final String name = nameController.text.trim();
    final int? order = int.tryParse(orderController.text.trim());
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre de la red social es obligatorio')),
      );
      return;
    }
    if (order == null || order < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El orden debe ser un número entero')),
      );
      return;
    }

    final SocialNetwork updated = SocialNetwork(
      id: network.id,
      name: name,
      icon: icon,
      postUrl: postUrlController.text.trim(),
      order: order,
      isActive: isActive,
      logo: logo,
    );
    Navigator.pop(context, updated);
  }

  @override
  void dispose() {
    nameController.dispose();
    postUrlController.dispose();
    orderController.dispose();
    super.dispose();
  }
}
