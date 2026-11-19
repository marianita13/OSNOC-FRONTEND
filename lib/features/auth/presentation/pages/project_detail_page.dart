import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../controllers/project_detail_controller.dart';
import '../theme/project_detail_styles.dart';
import '../widgets/responsive.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;
  final String action; // 'view', 'edit', 'delete', 'new'

  const ProjectDetailPage({
    super.key,
    required this.project,
    required this.action,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late final ProjectDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProjectDetailController(
      project: widget.project,
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
          backgroundColor: ProjectDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: ProjectDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: ProjectDetailStyles.cardBg,
            foregroundColor: ProjectDetailStyles.textPrimary,
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
                  color: ProjectDetailStyles.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ProjectDetailStyles.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila de ID y Nombre (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final idField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('ID'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox('${widget.project.id}'),
                          ],
                        );
                        final nameField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Nombre'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _controller.nameController,
                              enabled: _controller.isEnabled,
                              hintText: 'Nombre del proyecto',
                            ),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 90, child: idField),
                              const SizedBox(width: 12),
                              Expanded(child: nameField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idField,
                            const SizedBox(height: 12),
                            nameField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Descripción del proyecto
                    _buildLabelWithInfo('Descripción'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller.descriptionController,
                      enabled: _controller.isEnabled,
                      minLines: 6,
                      maxLines: null,
                      style: ProjectDetailStyles.inputTextStyle,
                      decoration: _inputDecoration(
                        enabled: _controller.isEnabled,
                        hintText: 'Descripción del proyecto',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nombre Archivo y Fecha Registro (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final fileField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Nombre Archivo'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _controller.fileNameController,
                              enabled: _controller.isEnabled,
                              maxLines: null,
                              style: ProjectDetailStyles.inputTextStyle,
                              decoration: _inputDecoration(
                                enabled: _controller.isEnabled,
                                hintText: 'documento.pdf',
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.picture_as_pdf,
                                  size: 18,
                                  color: ProjectDetailStyles.fileIcon,
                                ),
                              ),
                            ),
                          ],
                        );
                        final dateField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Fecha Registro'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox(widget.project.formattedRegistrationDate),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: fileField),
                              const SizedBox(width: 12),
                              Expanded(child: dateField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fileField,
                            const SizedBox(height: 12),
                            dateField,
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
                            color: ProjectDetailStyles.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline, size: 14, color: ProjectDetailStyles.textHint),
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
                                : ProjectDetailStyles.brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: Text(
                            _controller.submitLabel,
                            style: ProjectDetailStyles.buttonTextStyle,
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
        Text(label, style: ProjectDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: ProjectDetailStyles.textHint),
      ],
    );
  }

  // Campo de solo lectura con el mismo aspecto de un TextField deshabilitado
  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: ProjectDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ProjectDetailStyles.borderColor),
      ),
      child: Text(value, style: ProjectDetailStyles.inputTextStyle),
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
      style: ProjectDetailStyles.inputTextStyle,
      decoration: _inputDecoration(enabled: enabled, hintText: hintText).copyWith(
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
      ),
    );
  }

  InputDecoration _inputDecoration({required bool enabled, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: enabled ? ProjectDetailStyles.cardBg : ProjectDetailStyles.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ProjectDetailStyles.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ProjectDetailStyles.borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ProjectDetailStyles.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ProjectDetailStyles.focusBorder, width: 1.5),
      ),
    );
  }
}
