import 'package:flutter/material.dart';
import '../../models/social_network.dart';
import '../controllers/social_networks_controller.dart';
import '../theme/social_networks_styles.dart';
import '../widgets/social_network_card.dart';
import '../widgets/table_pagination.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class SocialNetworksContentView extends StatefulWidget {
  const SocialNetworksContentView({super.key});

  @override
  State<SocialNetworksContentView> createState() => _SocialNetworksContentViewState();
}

class _SocialNetworksContentViewState extends State<SocialNetworksContentView> {
  final SocialNetworksController _controller = SocialNetworksController();

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
        final List<SocialNetwork> pagedNetworks = _controller.pagedNetworks;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Redes Sociales', style: SocialNetworksStyles.sectionTitle),
              const SizedBox(height: 16),

              // Botón "+ Red social" (esta sección no tiene Exportar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _controller.navigateToNewNetwork(context),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('RED SOCIAL', style: SocialNetworksStyles.actionBtnText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SocialNetworksStyles.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Selector "Mostrar N registros"
              Row(
                children: [
                  const Text('Mostrar', style: SocialNetworksStyles.labelText),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: SocialNetworksStyles.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _controller.pageSize,
                        isDense: true,
                        style: const TextStyle(fontSize: 13, color: SocialNetworksStyles.titleColor),
                        items: _controller.pageSizeOptions
                            .map((size) => DropdownMenuItem<int>(value: size, child: Text('$size')))
                            .toList(),
                        onChanged: (value) => _controller.updatePageSize(value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('registros', style: SocialNetworksStyles.labelText),
                ],
              ),
              const SizedBox(height: 12),

              // Buscador
              TextField(
                onChanged: (value) => _controller.updateSearchQuery(value),
                enableInteractiveSelection: false,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar en la tabla...',
                  hintStyle: const TextStyle(color: SocialNetworksStyles.dataLabelColor, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: SocialNetworksStyles.subtextColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SocialNetworksStyles.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SocialNetworksStyles.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SocialNetworksStyles.primaryBlue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Listado de redes sociales
              if (pagedNetworks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No se encontraron registros',
                      style: SocialNetworksStyles.recordsInfoText,
                    ),
                  ),
                )
              else
                // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagedNetworks.length,
                  itemBuilder: (context, index) {
                    final network = pagedNetworks[index];
                    return SocialNetworkCard(
                      network: network,
                      onEdit: () => _controller.navigateToEditNetwork(context, network),
                      onDelete: () => _controller.navigateToDeleteNetwork(context, network),
                    );
                  },
                ),
              const SizedBox(height: 8),

              // Información de registros y paginación
              Center(
                child: Text(
                  _controller.recordsInfo,
                  textAlign: TextAlign.center,
                  style: SocialNetworksStyles.recordsInfoText,
                ),
              ),
              const SizedBox(height: 10),
              TablePagination(
                currentPage: _controller.currentPage,
                totalPages: _controller.totalPages,
                onPageSelected: _controller.goToPage,
                onPrevious: _controller.previousPage,
                onNext: _controller.nextPage,
              ),
              const SizedBox(height: 24),
              const UserProfileFooter(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
