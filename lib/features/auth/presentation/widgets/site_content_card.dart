import 'package:flutter/material.dart';
import '../../models/site_content.dart';
import '../controllers/site_contents_controller.dart';
import '../theme/site_contents_styles.dart';

class SiteContentCard extends StatelessWidget {
  final SiteContent content;
  final VoidCallback onEdit;
  final VoidCallback onView;

  const SiteContentCard({
    super.key,
    required this.content,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isMainPage = content.destination == SiteContentsController.mainPage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SiteContentsStyles.borderColor),
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
            // ID y Sección
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: SiteContentsStyles.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${content.id}', style: SiteContentsStyles.idBadgeText),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    content.section,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: SiteContentsStyles.titleColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: SiteContentsStyles.borderColor),

            // Imagen del contenido (si tiene)
            if (content.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  content.image!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Texto del contenido (resumido)
            _buildTitle('TEXTO'),
            const SizedBox(height: 2),
            Text(
              content.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: SiteContentsStyles.bodyTextColor,
              ),
            ),
            const SizedBox(height: 12),

            // Destino y botones de acción (Editar, Ver)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('DESTINO'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isMainPage
                              ? SiteContentsStyles.mainPageBg
                              : SiteContentsStyles.secondaryPageBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          content.destination,
                          style: TextStyle(
                            color: isMainPage
                                ? SiteContentsStyles.mainPageText
                                : SiteContentsStyles.secondaryPageText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  color: SiteContentsStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: SiteContentsStyles.viewCyan,
                  onTap: onView,
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
        color: Color(0xFF94A3B8),
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
