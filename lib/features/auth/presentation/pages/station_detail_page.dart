import 'package:flutter/material.dart';
import '../../models/station.dart';
import '../controllers/station_detail_controller.dart';
import '../theme/station_detail_styles.dart'; // Importación de los estilos centralizados
import '../widgets/responsive.dart';

class StationDetailPage extends StatefulWidget {
  final Station station;
  final String action; // 'view', 'edit', 'delete'

  const StationDetailPage({
    super.key,
    required this.station,
    required this.action,
  });

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  late final StationDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StationDetailController(
      station: widget.station,
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
          backgroundColor: StationDetailStyles.scaffoldBg,
          appBar: AppBar(
            title: Text(
              _controller.actionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: StationDetailStyles.textPrimary,
              ),
            ),
            backgroundColor: StationDetailStyles.cardBg,
            foregroundColor: StationDetailStyles.textPrimary,
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
              decoration: BoxDecoration(
                color: StationDetailStyles.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: StationDetailStyles.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila superior: Imagen y Nombre (Diseño responsivo)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 700;

                      // Contenedor de la Imagen
                      final imageBox = Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: isDesktop ? 240 : double.infinity,
                              height: 180,
                              color: StationDetailStyles.borderColor,
                              child: Image.asset(
                                'assets/images/estacion_campo_hermoso.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 14, color: Colors.white),
                                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      );

                      // Campos a la derecha (o debajo) de la imagen
                      final fields = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithInfo('Nombre'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _controller.nameController,
                            enabled: _controller.isEnabled,
                            hintText: 'Nombre de la estación',
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.location_on, size: 16, color: Colors.white),
                            label: const Text('VER UBICACIÓN', style: TextStyle(color: Colors.white, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: StationDetailStyles.brandBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      );

                      // CORRECCIÓN: Expanded solo es válido dentro de un Row (ancho acotado).
                      // En vertical, el alto es ilimitado dentro del scroll y Expanded lanzaba excepción.
                      if (isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageBox,
                            const SizedBox(width: 20),
                            Expanded(child: fields),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageBox,
                          const SizedBox(height: 16),
                          fields,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Fila de Latitud, Longitud y Altura
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabelWithInfo('Latitud (grados, minutos, segundos)'),
                                  const SizedBox(height: 6),
                                  _buildTextField(controller: _controller.latController, enabled: _controller.isEnabled),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabelWithInfo('Longitud (grados, minutos, segundos)'),
                                  const SizedBox(height: 6),
                                  _buildTextField(controller: _controller.lngController, enabled: _controller.isEnabled),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabelWithInfo('Altura (msnm)'),
                                  const SizedBox(height: 6),
                                  _buildTextField(controller: _controller.altController, enabled: _controller.isEnabled),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildLabelWithInfo('Latitud (grados, minutos, segundos)'),
                            const SizedBox(height: 6),
                            _buildTextField(controller: _controller.latController, enabled: _controller.isEnabled),
                            const SizedBox(height: 12),
                            _buildLabelWithInfo('Longitud (grados, minutos, segundos)'),
                            const SizedBox(height: 6),
                            _buildTextField(controller: _controller.lngController, enabled: _controller.isEnabled),
                            const SizedBox(height: 12),
                            _buildLabelWithInfo('Altura (msnm)'),
                            const SizedBox(height: 6),
                            _buildTextField(controller: _controller.altController, enabled: _controller.isEnabled),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Características Técnicas
                  _buildLabelWithInfo('Características Técnicas'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _controller.techController,
                    enabled: _controller.isEnabled,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13, color: StationDetailStyles.textSecondary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _controller.isEnabled ? StationDetailStyles.cardBg : const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: StationDetailStyles.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: StationDetailStyles.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: StationDetailStyles.focusBorder, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Checkbox Activa
                  Row(
                    children: [
                      Checkbox(
                        value: _controller.isActive,
                        onChanged: _controller.isEnabled ? (val) => _controller.toggleActive(val) : null,
                      ),
                      const Text(
                        'Activa',
                        style: TextStyle(color: StationDetailStyles.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline, size: 14, color: StationDetailStyles.textHint),
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
                          backgroundColor: _controller.isDelete ? Colors.redAccent : StationDetailStyles.brandGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: Text(
                          _controller.isDelete
                              ? 'CONFIRMAR ELIMINACIÓN'
                              : _controller.isNew
                                  ? 'CREAR ESTACIÓN'
                                  : 'GUARDAR CAMBIOS',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: StationDetailStyles.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.info_outline, size: 14, color: StationDetailStyles.textHint),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required bool enabled, String? hintText}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(fontSize: 13, color: StationDetailStyles.textSecondary),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: enabled ? StationDetailStyles.cardBg : const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        suffixIcon: enabled ? const Icon(Icons.check, size: 16, color: Colors.green) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: StationDetailStyles.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: StationDetailStyles.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: StationDetailStyles.focusBorder, width: 1.5),
        ),
      ),
    );
  }
}