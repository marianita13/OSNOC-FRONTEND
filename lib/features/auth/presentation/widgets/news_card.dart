import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../theme/news_styles.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const NewsCard({
    super.key,
    required this.news,
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
        border: Border.all(color: NewsStyles.borderColor),
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
            // ID, Título y Badge Activa
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: NewsStyles.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${news.id}', style: NewsStyles.idBadgeText),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: NewsStyles.titleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: news.isActive ? NewsStyles.activeBg : NewsStyles.inactiveBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    news.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      color: news.isActive ? NewsStyles.activeText : NewsStyles.inactiveText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: NewsStyles.borderColor),

            // Resumen
            _buildTitle('RESUMEN'),
            const SizedBox(height: 2),
            Text(
              news.summary,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: NewsStyles.bodyTextColor,
              ),
            ),
            const SizedBox(height: 10),

            // Fecha de publicación y Fecha de registro
            Row(
              children: [
                Expanded(
                  child: _buildDataColumn('FECHA PUBLICACIÓN', news.formattedPublicationDate),
                ),
                Expanded(
                  child: _buildDataColumn('FECHA REGISTRO', news.formattedRegistrationDate),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Botones de acción (Editar, Ver, Eliminar)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  color: NewsStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: NewsStyles.viewCyan,
                  onTap: onView,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.delete,
                  color: NewsStyles.deleteRed,
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
        color: NewsStyles.dataLabelColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDataColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: NewsStyles.bodyTextColor),
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
