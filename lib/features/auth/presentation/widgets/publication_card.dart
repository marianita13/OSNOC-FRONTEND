import 'package:flutter/material.dart';
import '../../models/publication.dart';
import '../theme/publications_styles.dart';

class PublicationCard extends StatelessWidget {
  final Publication publication;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const PublicationCard({
    super.key,
    required this.publication,
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
        border: Border.all(color: PublicationsStyles.borderColor),
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
            // ID, Titular y Badge Activo / Inactivo
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${publication.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: PublicationsStyles.primaryBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    publication.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: PublicationsStyles.titleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: publication.isActive
                        ? PublicationsStyles.activeBg
                        : PublicationsStyles.inactiveBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    publication.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: publication.isActive
                          ? PublicationsStyles.activeText
                          : PublicationsStyles.inactiveText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: PublicationsStyles.borderColor),

            // Usuario y Rol(es)
            Row(
              children: [
                Expanded(
                  child: _buildDataColumn('USUARIO', publication.user),
                ),
                Expanded(
                  child: _buildDataColumn('ROL(ES)', publication.roles),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Fecha de publicación y Fecha de registro
            Row(
              children: [
                Expanded(
                  child: _buildDataColumn(
                    'FECHA PUBLICACIÓN',
                    publication.formattedPublicationDate,
                  ),
                ),
                Expanded(
                  child: _buildDataColumn(
                    'FECHA REGISTRO',
                    publication.formattedRegistrationDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Botones de acción directos (Editar, Ver, Eliminar)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  color: PublicationsStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: PublicationsStyles.viewCyan,
                  onTap: onView,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.delete,
                  color: PublicationsStyles.deleteRed,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: PublicationsStyles.dataLabelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: PublicationsStyles.dataValueColor),
        ),
      ],
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

