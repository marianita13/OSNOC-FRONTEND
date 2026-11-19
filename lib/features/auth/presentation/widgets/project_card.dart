import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../theme/projects_styles.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProjectsStyles.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID y Nombre
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ProjectsStyles.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${project.id}', style: ProjectsStyles.idBadgeText),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ProjectsStyles.titleColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: ProjectsStyles.borderColor),

            // Descripción (resumida)
            _buildTitle('DESCRIPCIÓN'),
            const SizedBox(height: 2),
            Text(
              project.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: ProjectsStyles.bodyTextColor,
              ),
            ),
            const SizedBox(height: 10),

            // Nombre del archivo adjunto
            _buildTitle('NOMBRE ARCHIVO'),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: ProjectsStyles.fileBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.picture_as_pdf, size: 16, color: ProjectsStyles.fileIcon),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      project.fileName.isEmpty ? 'Sin archivo' : project.fileName,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: ProjectsStyles.bodyTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Fecha de registro, Activo y botones de acción (Editar, Ver, Eliminar)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('FECHA REGISTRO'),
                      const SizedBox(height: 2),
                      Text(
                        project.formattedRegistrationDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ProjectsStyles.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle('ACTIVO'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: project.isActive
                            ? ProjectsStyles.activeBg
                            : ProjectsStyles.inactiveBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        project.activeLabel,
                        style: TextStyle(
                          color: project.isActive
                              ? ProjectsStyles.activeText
                              : ProjectsStyles.inactiveText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.edit,
                  color: ProjectsStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: ProjectsStyles.viewCyan,
                  onTap: onView,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.delete,
                  color: ProjectsStyles.deleteRed,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        color: ProjectsStyles.dataLabelColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}
