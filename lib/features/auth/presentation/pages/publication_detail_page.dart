import 'package:flutter/material.dart';
import '../../models/publication.dart';
import '../controllers/publication_detail_controller.dart';
import '../theme/publication_detail_styles.dart';
import '../widgets/responsive.dart';

class PublicationDetailPage extends StatefulWidget {
  final Publication publication;
  final String action; // 'view', 'edit', 'delete', 'new'

  const PublicationDetailPage({
    super.key,
    required this.publication,
    required this.action,
  });

  @override
  State<PublicationDetailPage> createState() => _PublicationDetailPageState();
}

class _PublicationDetailPageState extends State<PublicationDetailPage> {
  late final PublicationDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PublicationDetailController(
      publication: widget.publication,
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
          backgroundColor: PublicationDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: PublicationDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: PublicationDetailStyles.cardBg,
            foregroundColor: PublicationDetailStyles.textPrimary,
            elevation: 0.5,
          ),
          body: SingleChildScrollView(
            padding: Responsive.pagePadding(
                context,
                maxWidth: Responsive.formMaxWidth,
                mobile: 20,
              ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: PublicationDetailStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID (solo lectura)
                  _buildLabelWithInfo('ID'),
                  const SizedBox(height: 6),
                  _buildReadOnlyBox('${widget.publication.id}'),
                  const SizedBox(height: 16),

                  // Titular
                  _buildLabelWithInfo('Titular'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _controller.titleController,
                    enabled: _controller.isEnabled,
                    hintText: 'Titular de la publicación',
                  ),
                  const SizedBox(height: 16),

                  // Fecha de publicación y Fecha de registro (Diseño responsivo)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final publicationDateField = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithInfo('Fecha Publicación'),
                          const SizedBox(height: 6),
                          _buildDateField(),
                        ],
                      );
                      final registrationDateField = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithInfo('Fecha Registro'),
                          const SizedBox(height: 6),
                          _buildReadOnlyBox(widget.publication.formattedRegistrationDate),
                        ],
                      );

                      if (constraints.maxWidth > 700) {
                        return Row(
                          children: [
                            Expanded(child: publicationDateField),
                            const SizedBox(width: 12),
                            Expanded(child: registrationDateField),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          publicationDateField,
                          const SizedBox(height: 16),
                          registrationDateField,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Usuario y Rol(es) (Diseño responsivo)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final userField = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithInfo('Usuario'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _controller.userController,
                            enabled: _controller.isEnabled,
                          ),
                        ],
                      );
                      final rolesField = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithInfo('Rol(es)'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _controller.rolesController,
                            enabled: _controller.isEnabled,
                          ),
                        ],
                      );

                      if (constraints.maxWidth > 700) {
                        return Row(
                          children: [
                            Expanded(child: userField),
                            const SizedBox(width: 12),
                            Expanded(child: rolesField),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userField,
                          const SizedBox(height: 16),
                          rolesField,
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
                        onChanged: _controller.isEnabled ? (val) => _controller.toggleActive(val) : null,
                      ),
                      const Text(
                        'Activo',
                        style: TextStyle(
                          color: PublicationDetailStyles.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline, size: 14, color: PublicationDetailStyles.textHint),
                    ],
                  ),

                  // Botón inferior para Guardar Cambios o Eliminar
                  if (_controller.isEdit || _controller.isDelete || _controller.isNew) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _controller.submitAction(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _controller.isDelete
                              ? Colors.redAccent
                              : PublicationDetailStyles.brandGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: Text(
                          _controller.isDelete
                              ? 'CONFIRMAR ELIMINACIÓN'
                              : _controller.isNew
                                  ? 'CREAR PUBLICACIÓN'
                                  : 'GUARDAR CAMBIOS',
                          style: PublicationDetailStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ],
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
        Text(label, style: PublicationDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: PublicationDetailStyles.textHint),
      ],
    );
  }

  // Campo de solo lectura con el mismo aspecto de un TextField deshabilitado
  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: PublicationDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: PublicationDetailStyles.borderColor),
      ),
      child: Text(value, style: PublicationDetailStyles.inputTextStyle),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _controller.isEnabled ? () => _controller.pickPublicationDate(context) : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _controller.isEnabled
              ? PublicationDetailStyles.cardBg
              : PublicationDetailStyles.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: PublicationDetailStyles.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _controller.formattedPublicationDate,
                style: PublicationDetailStyles.inputTextStyle,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: _controller.isEnabled
                  ? PublicationDetailStyles.focusBorder
                  : PublicationDetailStyles.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required bool enabled, String? hintText}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: PublicationDetailStyles.inputTextStyle,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: enabled ? PublicationDetailStyles.cardBg : PublicationDetailStyles.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: PublicationDetailStyles.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: PublicationDetailStyles.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: PublicationDetailStyles.focusBorder, width: 1.5),
        ),
      ),
    );
  }
}

