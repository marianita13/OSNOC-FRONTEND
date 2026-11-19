import 'package:flutter/material.dart';
import '../../models/seismic_report.dart';
import '../controllers/seismic_report_detail_controller.dart';
import '../theme/seismic_report_detail_styles.dart';
import '../widgets/responsive.dart';

class SeismicReportDetailPage extends StatefulWidget {
  final SeismicReport report;
  final String action; // 'view', 'edit', 'delete', 'new'

  const SeismicReportDetailPage({
    super.key,
    required this.report,
    required this.action,
  });

  @override
  State<SeismicReportDetailPage> createState() => _SeismicReportDetailPageState();
}

class _SeismicReportDetailPageState extends State<SeismicReportDetailPage> {
  late final SeismicReportDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SeismicReportDetailController(
      report: widget.report,
      action: widget.action,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: SeismicReportDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: SeismicReportDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: SeismicReportDetailStyles.cardBg,
            foregroundColor: SeismicReportDetailStyles.textPrimary,
            elevation: 0.5,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: Responsive.pagePadding(
                context,
                maxWidth: Responsive.formMaxWidth,
                mobile: 20,
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: SeismicReportDetailStyles.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SeismicReportDetailStyles.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila de ID y Descripción (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final idField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('ID'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox('${widget.report.id}'),
                          ],
                        );
                        final descriptionField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Descripción'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _controller.descriptionController,
                              enabled: _controller.isEnabled,
                              hintText: 'Descripción del reporte',
                            ),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 90, child: idField),
                              const SizedBox(width: 12),
                              Expanded(child: descriptionField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idField,
                            const SizedBox(height: 12),
                            descriptionField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Epicentro del sismo
                    _buildLabelWithInfo('Epicentro'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _controller.epicenterController,
                      enabled: _controller.isEnabled,
                      hintText: 'Ej: Los Santos',
                    ),
                    const SizedBox(height: 20),

                    // Tiempo Origen y Fecha Registro (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final originTimeField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Tiempo Origen'),
                            const SizedBox(height: 6),
                            _buildDateField(),
                          ],
                        );
                        final registrationDateField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Fecha Registro'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox(widget.report.formattedRegistrationDate),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: originTimeField),
                              const SizedBox(width: 12),
                              Expanded(child: registrationDateField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            originTimeField,
                            const SizedBox(height: 12),
                            registrationDateField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Checkbox Activo
                    Row(
                      children: [
                        Checkbox(
                          value: _controller.isActive,
                          onChanged: _controller.isEnabled
                              ? (val) => _controller.toggleActive(val)
                              : null,
                        ),
                        const Text(
                          'Activo',
                          style: TextStyle(
                            color: SeismicReportDetailStyles.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline, size: 14, color: SeismicReportDetailStyles.textHint),
                      ],
                    ),

                    // Botón inferior para Crear, Guardar Cambios o Eliminar
                    if (_controller.isEdit || _controller.isDelete || _controller.isNew) ...[
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _controller.submitAction(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.isDelete
                                ? Colors.redAccent
                                : SeismicReportDetailStyles.brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: Text(
                            _controller.submitLabel,
                            style: SeismicReportDetailStyles.buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelWithInfo(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: SeismicReportDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: SeismicReportDetailStyles.textHint),
      ],
    );
  }

  // Campo de solo lectura con el mismo aspecto de un TextField deshabilitado
  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: SeismicReportDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SeismicReportDetailStyles.borderColor),
      ),
      child: Text(value, style: SeismicReportDetailStyles.inputTextStyle),
    );
  }

  // Selector de tiempo de origen (abre calendario y reloj en modo edición)
  Widget _buildDateField() {
    return InkWell(
      onTap: _controller.isEnabled ? () => _controller.pickOriginTime(context) : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _controller.isEnabled ? SeismicReportDetailStyles.cardBg : SeismicReportDetailStyles.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: SeismicReportDetailStyles.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _controller.formattedOriginTime,
                style: SeismicReportDetailStyles.inputTextStyle,
              ),
            ),
            Icon(
              Icons.schedule,
              size: 16,
              color: _controller.isEnabled ? SeismicReportDetailStyles.focusBorder : SeismicReportDetailStyles.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool enabled,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: null,
      style: SeismicReportDetailStyles.inputTextStyle,
      decoration: _inputDecoration(enabled: enabled, hintText: hintText).copyWith(
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
      ),
    );
  }

  InputDecoration _inputDecoration({required bool enabled, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: enabled ? SeismicReportDetailStyles.cardBg : SeismicReportDetailStyles.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SeismicReportDetailStyles.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SeismicReportDetailStyles.borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SeismicReportDetailStyles.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SeismicReportDetailStyles.focusBorder, width: 1.5),
      ),
    );
  }
}
