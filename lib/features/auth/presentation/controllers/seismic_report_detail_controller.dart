import 'package:flutter/material.dart';
import '../../models/seismic_report.dart';

class SeismicReportDetailController extends ChangeNotifier {
  final SeismicReport report;
  final String action; // 'view', 'edit', 'delete', 'new'

  // Controladores de texto para los campos del formulario
  late final TextEditingController descriptionController;
  late final TextEditingController epicenterController;

  // Estado del tiempo de origen y del checkbox "Activo"
  late DateTime originTime;
  bool isActive = true;

  SeismicReportDetailController({
    required this.report,
    required this.action,
  }) {
    // Inicializamos los valores usando el reporte recibido
    descriptionController = TextEditingController(text: report.description);
    epicenterController = TextEditingController(text: report.epicenter);
    originTime = report.originTime;
    isActive = report.isActive;
  }

  // Getters auxiliares para evaluar el modo de la pantalla
  bool get isEdit => action == 'edit';
  bool get isDelete => action == 'delete';
  bool get isNew => action == 'new';

  // Si es 'edit' o 'new', los campos se pueden editar; en 'view' o 'delete' son de solo lectura
  bool get isEnabled => isEdit || isNew;

  // Título dinámico para la barra superior
  String get actionTitle {
    if (isNew) return 'Nuevo Reporte Sísmico';
    if (isEdit) return 'Reporte Sísmico en Edición';
    if (isDelete) return 'Eliminar Reporte Sísmico';
    return 'Información Reporte Sísmico';
  }

  String get submitLabel {
    if (isDelete) return 'CONFIRMAR ELIMINACIÓN';
    if (isNew) return 'CREAR REPORTE';
    return 'GUARDAR CAMBIOS';
  }

  String get formattedOriginTime => SeismicReport.formatDateTime(originTime);

  // Abre el calendario y luego el reloj para elegir el tiempo de origen
  Future<void> pickOriginTime(BuildContext context) async {
    if (!isEnabled) return;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: originTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(originTime),
    );
    if (pickedTime == null) return;

    originTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    notifyListeners();
  }

  // Método para cambiar el estado del checkbox
  void toggleActive(bool? value) {
    if (isEnabled && value != null) {
      isActive = value;
      notifyListeners();
    }
  }

  // Acción para guardar los cambios o confirmar eliminación.
  // Devuelve el reporte resultante a la pantalla anterior mediante Navigator.pop.
  void submitAction(BuildContext context) {
    if (isDelete) {
      // Confirma la eliminación devolviendo el reporte original
      Navigator.pop(context, report);
      return;
    }

    if (isEnabled) {
      final description = descriptionController.text.trim();
      final epicenter = epicenterController.text.trim();
      if (description.isEmpty || epicenter.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La descripción y el epicentro son obligatorios')),
        );
        return;
      }

      final updated = SeismicReport(
        id: report.id,
        description: description,
        originTime: originTime,
        epicenter: epicenter,
        registrationDate: report.registrationDate,
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
    descriptionController.dispose();
    epicenterController.dispose();
    super.dispose();
  }
}
