import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../controllers/news_controller.dart';
import '../theme/news_styles.dart';
import '../widgets/news_card.dart';
import '../widgets/table_pagination.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class NewsContentView extends StatefulWidget {
  const NewsContentView({super.key});

  @override
  State<NewsContentView> createState() => _NewsContentViewState();
}

class _NewsContentViewState extends State<NewsContentView> {
  final NewsController _controller = NewsController();

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
        final List<News> pagedNews = _controller.pagedNews;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Noticias', style: NewsStyles.sectionTitle),
              const SizedBox(height: 16),

              // Botones "Exportar a Excel" y "Nueva noticia"
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.exportNews(),
                      icon: const Icon(Icons.file_download, size: 16, color: Colors.white),
                      label: const Text('EXPORTAR A EXCEL', style: NewsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NewsStyles.exportGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.navigateToNewNews(context),
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('NUEVA NOTICIA', style: NewsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NewsStyles.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector "Mostrar N registros"
              Row(
                children: [
                  const Text('Mostrar', style: NewsStyles.labelText),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NewsStyles.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _controller.pageSize,
                        isDense: true,
                        style: const TextStyle(fontSize: 13, color: NewsStyles.titleColor),
                        items: _controller.pageSizeOptions
                            .map((size) => DropdownMenuItem<int>(value: size, child: Text('$size')))
                            .toList(),
                        onChanged: (value) => _controller.updatePageSize(value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('registros', style: NewsStyles.labelText),
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
                  hintStyle: const TextStyle(color: NewsStyles.dataLabelColor, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: NewsStyles.subtextColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: NewsStyles.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: NewsStyles.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: NewsStyles.primaryBlue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Listado de noticias
              if (pagedNews.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No se encontraron registros',
                      style: NewsStyles.recordsInfoText,
                    ),
                  ),
                )
              else
                // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagedNews.length,
                  itemBuilder: (context, index) {
                    final news = pagedNews[index];
                    return NewsCard(
                      news: news,
                      onEdit: () => _controller.navigateToEditNews(context, news),
                      onView: () => _controller.navigateToViewNews(context, news),
                      onDelete: () => _controller.navigateToDeleteNews(context, news),
                    );
                  },
                ),
              const SizedBox(height: 8),

              // Información de registros y paginación
              Center(
                child: Text(
                  _controller.recordsInfo,
                  textAlign: TextAlign.center,
                  style: NewsStyles.recordsInfoText,
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
