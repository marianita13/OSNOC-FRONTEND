import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../controllers/news_detail_controller.dart';
import '../theme/news_detail_styles.dart';
import '../widgets/responsive.dart';

class NewsDetailPage extends StatefulWidget {
  final News news;
  final String action; // 'view', 'edit', 'delete', 'new'

  const NewsDetailPage({
    super.key,
    required this.news,
    required this.action,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late final NewsDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NewsDetailController(
      news: widget.news,
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
          backgroundColor: NewsDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: NewsDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: NewsDetailStyles.cardBg,
            foregroundColor: NewsDetailStyles.textPrimary,
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
                  color: NewsDetailStyles.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NewsDetailStyles.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila de ID y Título (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final idField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('ID'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox('${widget.news.id}'),
                          ],
                        );
                        final titleField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Título'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _controller.titleController,
                              enabled: _controller.isEnabled,
                              hintText: 'Título de la noticia',
                            ),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 90, child: idField),
                              const SizedBox(width: 12),
                              Expanded(child: titleField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idField,
                            const SizedBox(height: 12),
                            titleField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Resumen de la noticia
                    _buildLabelWithInfo('Resumen'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller.summaryController,
                      enabled: _controller.isEnabled,
                      minLines: 5,
                      maxLines: null,
                      style: NewsDetailStyles.inputTextStyle,
                      decoration: _inputDecoration(
                        enabled: _controller.isEnabled,
                        hintText: 'Resumen de la noticia',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fecha Publicación y Fecha Registro (Diseño responsivo)
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
                            _buildReadOnlyBox(widget.news.formattedRegistrationDate),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 12),
                            registrationDateField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Checkbox Activa
                    Row(
                      children: [
                        Checkbox(
                          value: _controller.isActive,
                          onChanged: _controller.isEnabled
                              ? (val) => _controller.toggleActive(val)
                              : null,
                        ),
                        const Text(
                          'Activa',
                          style: TextStyle(
                            color: NewsDetailStyles.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline, size: 14, color: NewsDetailStyles.textHint),
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
                                : NewsDetailStyles.brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: Text(
                            _controller.submitLabel,
                            style: NewsDetailStyles.buttonTextStyle,
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
        Text(label, style: NewsDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: NewsDetailStyles.textHint),
      ],
    );
  }

  // Campo de solo lectura con el mismo aspecto de un TextField deshabilitado
  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: NewsDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: NewsDetailStyles.borderColor),
      ),
      child: Text(value, style: NewsDetailStyles.inputTextStyle),
    );
  }

  // Selector de fecha de publicación (abre el calendario en modo edición)
  Widget _buildDateField() {
    return InkWell(
      onTap: _controller.isEnabled ? () => _controller.pickPublicationDate(context) : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _controller.isEnabled ? NewsDetailStyles.cardBg : NewsDetailStyles.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: NewsDetailStyles.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _controller.formattedPublicationDate,
                style: NewsDetailStyles.inputTextStyle,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: _controller.isEnabled ? NewsDetailStyles.focusBorder : NewsDetailStyles.textHint,
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
      style: NewsDetailStyles.inputTextStyle,
      decoration: _inputDecoration(enabled: enabled, hintText: hintText).copyWith(
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
      ),
    );
  }

  InputDecoration _inputDecoration({required bool enabled, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: enabled ? NewsDetailStyles.cardBg : NewsDetailStyles.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: NewsDetailStyles.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: NewsDetailStyles.borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: NewsDetailStyles.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: NewsDetailStyles.focusBorder, width: 1.5),
      ),
    );
  }
}
