import 'package:flutter/material.dart';
import '../../models/station.dart';

class StationDetailController extends ChangeNotifier {
  final Station station;
  final String action; // 'view', 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController nameController;
  late final TextEditingController latController;
  late final TextEditingController lngController;
  late final TextEditingController altController;
  late final TextEditingController techController;

  // Estado del checkbox y validaciones
  bool isActive = true;

  StationDetailController({
    required this.station,
    required this.action,
  }) {
    // Inicializamos los valores usando la estación recibida
    nameController = TextEditingController(text: station.name);
    latController = TextEditingController(text: station.latitude);
    lngController = TextEditingController(text: station.longitude);
    altController = TextEditingController(text: station.altitude.toString());

    // Texto técnico por defecto basado en la estación
    techController = TextEditingController(
      text: station.name.isNotEmpty
          ? 'Estación ${station.name}\nDispositivo especializado para el registro en tiempo real de movimientos fuertes ocasionados por eventos sísmicos.'
          : '',
    );

    isActive = station.isActive;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // Si es 'edit' o 'new', los campos se pueden editar; en 'view' o 'delete' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nueva Estación Sismológica';
    if (isEdit) return 'Estación Sismológica en Edición';
    if (isDelete) return 'Eliminar Estación Sismológica';
    return 'Información Estación Sismológica';
  }

  // Método para cambiar el estado del checkbox
  void toggleActive(bool? value) {
    if (isEnabled && value != null) {
      isActive = value;
      notifyListeners();
    }
  }

  // Acción para guardar los cambios o confirmar eliminación.
  // Devuelve la estación resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      // Confirma la eliminación devolviendo la estación original
      Navigator.pop(context, station);
      return;
    }

    if (isEnabled) {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre es obligatorio')),
        );
        return;
      }

      final updated = Station(
        name: name,
        latitude: latController.text.trim(),
        longitude: lngController.text.trim(),
        altitude: double.tryParse(altController.text.trim()) ?? station.altitude,
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
    latController.dispose();
    lngController.dispose();
    altController.dispose();
    techController.dispose();
    super.dispose();
  }
}