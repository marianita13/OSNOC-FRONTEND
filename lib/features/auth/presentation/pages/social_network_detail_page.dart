import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/social_network.dart';
import '../controllers/social_network_detail_controller.dart';
import '../theme/social_network_detail_styles.dart';
import '../widgets/social_network_icon.dart';
import '../widgets/responsive.dart';

class SocialNetworkDetailPage extends StatefulWidget {
  final SocialNetwork network;
  final String action; // 'edit', 'delete', 'new'

  const SocialNetworkDetailPage({
    super.key,
    required this.network,
    required this.action,
  });

  @override
  State<SocialNetworkDetailPage> createState() => _SocialNetworkDetailPageState();
}

class _SocialNetworkDetailPageState extends State<SocialNetworkDetailPage> {
  late final SocialNetworkDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SocialNetworkDetailController(
      network: widget.network,
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
          backgroundColor: SocialNetworkDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: SocialNetworkDetailStyles.appBarTitleStyle,
            ),
            backgroundColor: SocialNetworkDetailStyles.cardBg,
            foregroundColor: SocialNetworkDetailStyles.textPrimary,
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
                  color: SocialNetworkDetailStyles.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SocialNetworkDetailStyles.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID y Red Social
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelWithInfo('ID'),
                              const SizedBox(height: 6),
                              _buildReadOnlyBox('${widget.network.id}'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelWithInfo('Red Social'),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: _controller.nameController,
                                enabled: _controller.isEnabled,
                                hintText: 'Ej: Facebook',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Logo (foto subida desde la galería o la cámara)
                    _buildLabelWithInfo('Logo'),
                    const SizedBox(height: 6),
                    _buildLogoSection(context),
                    const SizedBox(height: 20),

                    // Ícono (desplegable con vista previa; se usa si no hay logo)
                    _buildLabelWithInfo('Icono'),
                    const SizedBox(height: 6),
                    _buildIconSelector(),
                    const SizedBox(height: 20),

                    // PostURL
                    _buildLabelWithInfo('PostURL'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _controller.postUrlController,
                      enabled: _controller.isEnabled,
                      hintText: 'https://...',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 20),

                    // Orden
                    _buildLabelWithInfo('Orden'),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 120,
                      child: _buildTextField(
                        controller: _controller.orderController,
                        enabled: _controller.isEnabled,
                        keyboardType: TextInputType.number,
                      ),
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
                            color: SocialNetworkDetailStyles.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline, size: 14, color: SocialNetworkDetailStyles.textHint),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Botón inferior: Crear, Guardar Cambios o Confirmar eliminación
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _controller.submitAction(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _controller.isDelete
                              ? Colors.redAccent
                              : SocialNetworkDetailStyles.brandGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: Text(
                          _controller.submitLabel,
                          style: SocialNetworkDetailStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Vista previa del logo + botones Galería / Cámara / Quitar
  Widget _buildLogoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _controller.isEnabled
            ? SocialNetworkDetailStyles.cardBg
            : SocialNetworkDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SocialNetworkDetailStyles.borderColor),
      ),
      child: Row(
        children: [
          SocialNetworkIcon(
            iconKey: _controller.icon,
            size: 64,
            logo: _controller.logo,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.hasLogo
                      ? 'Logo cargado'
                      : 'Sin logo: se muestra el ícono con iniciales',
                  style: SocialNetworkDetailStyles.inputTextStyle,
                ),
                if (_controller.isEnabled) ...[
                  const SizedBox(height: 8),
                  if (_controller.isPickingLogo)
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
                          color: SocialNetworkDetailStyles.focusBorder,
                          onTap: () => _controller.pickLogo(context, ImageSource.gallery),
                        ),
                        _buildSmallButton(
                          icon: Icons.photo_camera,
                          label: 'CÁMARA',
                          color: SocialNetworkDetailStyles.textSecondary,
                          onTap: () => _controller.pickLogo(context, ImageSource.camera),
                        ),
                        if (_controller.hasLogo)
                          _buildSmallButton(
                            icon: Icons.delete_outline,
                            label: 'QUITAR',
                            color: Colors.redAccent,
                            onTap: _controller.removeLogo,
                          ),
                      ],
                    ),
                ],
              ],
            ),
          ),
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

  // Selector de ícono: en solo lectura muestra el ícono y su nombre
  Widget _buildIconSelector() {
    if (!_controller.isEnabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: SocialNetworkDetailStyles.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: SocialNetworkDetailStyles.borderColor),
        ),
        child: Row(
          children: [
            SocialNetworkIcon(iconKey: _controller.icon, size: 24),
            const SizedBox(width: 10),
            Text(
              SocialNetworkIcon.labelFor(_controller.icon),
              style: SocialNetworkDetailStyles.inputTextStyle,
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SocialNetworkDetailStyles.cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SocialNetworkDetailStyles.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _controller.icon,
          isExpanded: true,
          style: SocialNetworkDetailStyles.inputTextStyle,
          items: _controller.iconKeys
              .map((key) => DropdownMenuItem<String>(
                    value: key,
                    child: Row(
                      children: [
                        SocialNetworkIcon(iconKey: key, size: 24),
                        const SizedBox(width: 10),
                        Text(SocialNetworkIcon.labelFor(key)),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: _controller.changeIcon,
        ),
      ),
    );
  }

  Widget _buildLabelWithInfo(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: SocialNetworkDetailStyles.labelStyle),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: SocialNetworkDetailStyles.textHint),
      ],
    );
  }

  // Campo de solo lectura con el mismo aspecto de un TextField deshabilitado
  Widget _buildReadOnlyBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: SocialNetworkDetailStyles.inputFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SocialNetworkDetailStyles.borderColor),
      ),
      child: Text(value, style: SocialNetworkDetailStyles.inputTextStyle),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool enabled,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: SocialNetworkDetailStyles.inputTextStyle,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: enabled ? SocialNetworkDetailStyles.cardBg : SocialNetworkDetailStyles.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: SocialNetworkDetailStyles.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: SocialNetworkDetailStyles.borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: SocialNetworkDetailStyles.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: SocialNetworkDetailStyles.focusBorder, width: 1.5),
        ),
      ),
    );
  }
}

