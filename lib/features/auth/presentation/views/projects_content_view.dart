import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../controllers/projects_controller.dart';
import '../theme/projects_styles.dart';
import '../widgets/project_card.dart';
import '../widgets/table_pagination.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class ProjectsContentView extends StatefulWidget {
  const ProjectsContentView({super.key});

  @override
  State<ProjectsContentView> createState() => _ProjectsContentViewState();
}

class _ProjectsContentViewState extends State<ProjectsContentView> {
  final ProjectsController _controller = ProjectsController();

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
        final List<Project> pagedProjects = _controller.pagedProjects;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Proyectos', style: ProjectsStyles.sectionTitle),
              const SizedBox(height: 16),

              // Botones "Exportar a Excel" y "Nuevo proyecto"
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.exportProjects(),
                      icon: const Icon(Icons.file_download, size: 16, color: Colors.white),
                      label: const Text('EXPORTAR A EXCEL', style: ProjectsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProjectsStyles.exportGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.navigateToNewProject(context),
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('NUEVO PROYECTO', style: ProjectsStyles.actionBtnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProjectsStyles.primaryBlue,
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
                  const Text('Mostrar', style: ProjectsStyles.labelText),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ProjectsStyles.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _controller.pageSize,
                        isDense: true,
                        style: const TextStyle(fontSize: 13, color: ProjectsStyles.titleColor),
                        items: _controller.pageSizeOptions
                            .map((size) => DropdownMenuItem<int>(value: size, child: Text('$size')))
                            .toList(),
                        onChanged: (value) => _controller.updatePageSize(value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('registros', style: ProjectsStyles.labelText),
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
                  hintStyle: const TextStyle(color: ProjectsStyles.dataLabelColor, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: ProjectsStyles.subtextColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: ProjectsStyles.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: ProjectsStyles.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: ProjectsStyles.primaryBlue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Listado de proyectos
              if (pagedProjects.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No se encontraron registros',
                      style: ProjectsStyles.recordsInfoText,
                    ),
                  ),
                )
              else
                // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagedProjects.length,
                  itemBuilder: (context, index) {
                    final project = pagedProjects[index];
                    return ProjectCard(
                      project: project,
                      onEdit: () => _controller.navigateToEditProject(context, project),
                      onView: () => _controller.navigateToViewProject(context, project),
                      onDelete: () => _controller.navigateToDeleteProject(context, project),
                    );
                  },
                ),
              const SizedBox(height: 8),

              // Información de registros y paginación
              Center(
                child: Text(
                  _controller.recordsInfo,
                  textAlign: TextAlign.center,
                  style: ProjectsStyles.recordsInfoText,
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
