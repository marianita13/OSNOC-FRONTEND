import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/site_content.dart';
import '../controllers/site_content_detail_controller.dart';
import '../theme/site_content_detail_styles.dart';
import '../widgets/responsive.dart';

class SiteContentDetailPage extends StatefulWidget {
  final SiteContent content;
  final String action; // 'view', 'edit', 'new'

  const SiteContentDetailPage({
    super.key,
    required this.content,
    required this.action,
  });

  @override
  State<SiteContentDetailPage> createState() => _SiteContentDetailPageState();
}

class _SiteContentDetailPageState extends State<SiteContentDetailPage> {
  late final SiteContentDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SiteContentDetailController(
      content: widget.content,
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
          backgroundColor: SiteContentDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: SiteContentDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: SiteContentDetailStyles.cardBg,
            foregroundColor: SiteContentDetailStyles.textPrimary,
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
                  color: SiteContentDetailStyles.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SiteContentDetailStyles.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila de ID, Sección y Destino (Diseño responsivo)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final idField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('ID'),
                            const SizedBox(height: 6),
                            _buildReadOnlyBox('${widget.content.id}'),
                          ],
                        );
                        final sectionField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Sección'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _controller.sectionController,
                              enabled: _controller.isEnabled,
                              hintText: 'Nombre de la sección',
                            ),
                          ],
                        );
                        final destinationField = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelWithInfo('Destino'),
                            const SizedBox(height: 6),
                            _buildDestinationDropdown(),
                          ],
                        );

                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 90, child: idField),
                              const SizedBox(width: 12),
                              Expanded(child: sectionField),
                              const SizedBox(width: 12),
                              Expanded(child: destinationField),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            idField,
                            const SizedBox(height: 12),
                            sectionField,
                            const SizedBox(height: 12),
                            destinationField,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Texto del contenido
                    _buildLabelWithInfo('Texto'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller.textController,
                      enabled: _controller.isEnabled,
                      minLines: 6,
                      maxLines: null,
                      style: SiteContentDetailStyles.inputTextStyle,
                      decoration: _inputDecoration(enabled: _controller.isEnabled),
                    ),
                    const SizedBox(height: 20),

                    // Imagen del contenido (opcional)
                    _buildLabelWithInfo('Imagen'),
                    const SizedBox(height: 6),
                    _buildImageSection(context),

                    // Botón inferior para Crear o Guardar Cambios (modo nuevo / edición)
                    if (_controller.isEdit || _controller.isNew) ...[
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _controller.submitAction(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SiteContentDetailStyles.brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: Text(
                            _controller.submitLabel,
                            style: SiteContentDetailStyles.buttonTextStyle,
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

  // Vista previa de la imagen + botones Galería / Cámara / Quitar
  Widget _buildImageSection(BuildContext context) {
    final image = _controller.image;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _controller.isEnabled
            ? SiteContentDetailStyles.cardBg
            : SiteContentDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SiteContentDetailStyles.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: SiteContentDetailStyles.inputFill,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, size: 32, color: SiteContentDetailStyles.textHint),
                  SizedBox(height: 4),
                  Text(
                    'Sin imagen',
                    style: TextStyle(fontSize: 12, color: SiteContentDetailStyles.textHint),
                  ),
                ],
              ),
            ),
          if (_controller.isEnabled) ...[
            const SizedBox(height: 10),
            if (_controller.isPickingImage)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSmallButton(
                    icon: Icons.photo_library,
                    label: 'GALERÍA',
                    color: SiteContentDetailStyles.focusBorder,
                    onTap: () => _controller.pickImage(context, ImageSource.gallery),
                  ),
                  _buildSmallButton(
                    icon: Icons.photo_camera,
                    label: 'CÁMARA',
                    color: SiteContentDetailStyles.textSecondary,
                    onTap: () => _controller.pickImage(context, ImageSource.camera),
                  ),
                  if (_controller.hasImage)
                    _buildSmallButton(
                      icon: Icons.delete_outline,
                      label: 'QUITAR',
                      color: Colors.redAccent,
                      onTap: _controller.removeImage,
                    ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
    );
  }

  Widget _buildLabelWithInfo(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: SiteContentDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: SiteContentDetailStyles.textHint),
      ],
    );
  }

  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: SiteContentDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SiteContentDetailStyles.borderColor),
      ),
      child: Text(value, style: SiteContentDetailStyles.inputTextStyle),
    );
  }

  // Selector de destino.
  // - Modo 'view': caja de solo lectura.
  // - Modo 'edit': DropdownButton con `value` ligado al controlador, en lugar de
  //   DropdownButtonFormField(initialValue: ...), que solo existe desde Flutter 3.35
  //   y no se refresca cuando el controlador cambia el destino.
  Widget _buildDestinationDropdown() {
    final destinations = _controller.destinations;
    final current = destinations.contains(_controller.destination)
        ? _controller.destination
        : (destinations.isNotEmpty ? destinations.first : null);

    if (!_controller.isEnabled || current == null) {
      return _buildReadOnlyBox(current ?? '-');
    }

    return InputDecorator(
      decoration: _inputDecoration(enabled: true).copyWith(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          style: SiteContentDetailStyles.inputTextStyle,
          items: destinations
              .map((d) => DropdownMenuItem<String>(
                    value: d,
                    child: Text(d, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: _controller.changeDestination,
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
      style: SiteContentDetailStyles.inputTextStyle,
      decoration: _inputDecoration(enabled: enabled, hintText: hintText).copyWith(
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
      ),
    );
  }

  InputDecoration _inputDecoration({required bool enabled, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: enabled ? SiteContentDetailStyles.cardBg : SiteContentDetailStyles.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SiteContentDetailStyles.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SiteContentDetailStyles.borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SiteContentDetailStyles.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SiteContentDetailStyles.focusBorder, width: 1.5),
      ),
    );
  }
}