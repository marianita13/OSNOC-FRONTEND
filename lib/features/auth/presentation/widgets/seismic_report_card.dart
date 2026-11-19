import 'package:flutter/material.dart';
import '../../models/seismic_report.dart';
import '../theme/seismic_reports_styles.dart';

class SeismicReportCard extends StatelessWidget {
  final SeismicReport report;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const SeismicReportCard({
    super.key,
    required this.report,
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
        border: Border.all(color: SeismicReportsStyles.borderColor),
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
            // Descripción y Badge Activo / Inactivo
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bar_chart, size: 18, color: SeismicReportsStyles.primaryBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: SeismicReportsStyles.titleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: report.isActive
                        ? SeismicReportsStyles.activeBg
                        : SeismicReportsStyles.inactiveBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: report.isActive
                          ? SeismicReportsStyles.activeText
                          : SeismicReportsStyles.inactiveText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: SeismicReportsStyles.borderColor),

            // Tiempo de origen y Epicentro
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDataColumn('TIEMPO ORIGEN', report.formattedOriginTime),
                ),
                Expanded(
                  child: _buildDataColumn('EPICENTRO', report.epicenter),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Fecha de registro y botones de acción (Editar, Ver, Eliminar)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildDataColumn('FECHA REGISTRO', report.formattedRegistrationDate),
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  color: SeismicReportsStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.visibility,
                  color: SeismicReportsStyles.viewCyan,
                  onTap: onView,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.delete,
                  color: SeismicReportsStyles.deleteRed,
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
            color: SeismicReportsStyles.dataLabelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: SeismicReportsStyles.bodyTextColor),
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
