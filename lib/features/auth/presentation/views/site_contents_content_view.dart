import 'package:flutter/material.dart';
import '../../models/site_content.dart';
import '../controllers/site_contents_controller.dart';
import '../theme/site_contents_styles.dart';
import '../widgets/site_content_card.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class SiteContentsContentView extends StatefulWidget {
  const SiteContentsContentView({super.key});

  @override
  State<SiteContentsContentView> createState() => _SiteContentsContentViewState();
}

class _SiteContentsContentViewState extends State<SiteContentsContentView> {
  final SiteContentsController _controller = SiteContentsController();

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
        final List<SiteContent> allContents = _controller.allContents;
        final List<SiteContent> filteredContents = _controller.filteredContents;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Contenidos Sitio', style: SiteContentsStyles.sectionTitle),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.exportContents(),
                      icon: const Icon(Icons.file_download, size: 16, color: Colors.white),
                      label: const Text('EXPORTAR', style: SiteContentsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SiteContentsStyles.exportGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.navigateToNewContent(context),
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('NUEVO CONTENIDO', style: SiteContentsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SiteContentsStyles.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => _controller.updateSearchQuery(value),
                enableInteractiveSelection: false,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar contenido...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SiteContentsStyles.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SiteContentsStyles.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SiteContentsStyles.primaryBlue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mostrando ${filteredContents.length} de ${allContents.length} registros',
                style: const TextStyle(
                  fontSize: 12,
                  color: SiteContentsStyles.subtextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredContents.length,
                itemBuilder: (context, index) {
                  final content = filteredContents[index];
                  return SiteContentCard(
                    content: content,
                    onEdit: () => _controller.navigateToEditContent(context, content),
                    onView: () => _controller.navigateToViewContent(context, content),
                  );
                },
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
