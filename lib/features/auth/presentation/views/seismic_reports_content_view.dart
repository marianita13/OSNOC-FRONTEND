import 'package:flutter/material.dart';
import '../../models/seismic_report.dart';
import '../controllers/seismic_reports_controller.dart';
import '../theme/seismic_reports_styles.dart';
import '../widgets/seismic_report_card.dart';
import '../widgets/table_pagination.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class SeismicReportsContentView extends StatefulWidget {
  const SeismicReportsContentView({super.key});

  @override
  State<SeismicReportsContentView> createState() => _SeismicReportsContentViewState();
}

class _SeismicReportsContentViewState extends State<SeismicReportsContentView> {
  final SeismicReportsController _controller = SeismicReportsController();

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
        final List<SeismicReport> pagedReports = _controller.pagedReports;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reportes Sísmicos', style: SeismicReportsStyles.sectionTitle),
              const SizedBox(height: 16),

              // Botones "Exportar a Excel" y "Nuevo reporte"
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.exportReports(),
                      icon: const Icon(Icons.file_download, size: 16, color: Colors.white),
                      label: const Text('EXPORTAR A EXCEL', style: SeismicReportsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SeismicReportsStyles.exportGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.navigateToNewReport(context),
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('NUEVO REPORTE', style: SeismicReportsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SeismicReportsStyles.primaryBlue,
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
                  const Text('Mostrar', style: SeismicReportsStyles.labelText),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: SeismicReportsStyles.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _controller.pageSize,
                        isDense: true,
                        style: const TextStyle(fontSize: 13, color: SeismicReportsStyles.titleColor),
                        items: _controller.pageSizeOptions
                            .map((size) => DropdownMenuItem<int>(value: size, child: Text('$size')))
                            .toList(),
                        onChanged: (value) => _controller.updatePageSize(value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('registros', style: SeismicReportsStyles.labelText),
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
                  hintStyle: const TextStyle(color: SeismicReportsStyles.dataLabelColor, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: SeismicReportsStyles.subtextColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SeismicReportsStyles.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SeismicReportsStyles.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: SeismicReportsStyles.primaryBlue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Listado de reportes sísmicos
              if (pagedReports.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No se encontraron registros',
                      style: SeismicReportsStyles.recordsInfoText,
                    ),
                  ),
                )
              else
                // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagedReports.length,
                  itemBuilder: (context, index) {
                    final report = pagedReports[index];
                    return SeismicReportCard(
                      report: report,
                      onEdit: () => _controller.navigateToEditReport(context, report),
                      onView: () => _controller.navigateToViewReport(context, report),
                      onDelete: () => _controller.navigateToDeleteReport(context, report),
                    );
                  },
                ),
              const SizedBox(height: 8),

              // Información de registros y paginación
              Center(
                child: Text(
                  _controller.recordsInfo,
                  textAlign: TextAlign.center,
                  style: SeismicReportsStyles.recordsInfoText,
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
