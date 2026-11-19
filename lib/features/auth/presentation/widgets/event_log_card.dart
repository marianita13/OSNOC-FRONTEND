import 'package:flutter/material.dart';
import '../../models/event_log.dart';
import '../theme/event_logs_styles.dart';

class EventLogCard extends StatelessWidget {
  final EventLog log;

  const EventLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventLogsStyles.borderColor),
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
            // N°, Tabla y Fecha-Registro
            Row(
              children: [
                Text(
                  '#${log.number}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: EventLogsStyles.primaryBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: EventLogsStyles.tableTagBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        log.table,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: EventLogsStyles.tableTagText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.schedule, size: 13, color: EventLogsStyles.dataLabelColor),
                const SizedBox(width: 4),
                Text(
                  log.formattedRegistrationDate,
                  style: const TextStyle(fontSize: 11, color: EventLogsStyles.subtextColor),
                ),
              ],
            ),
            const Divider(height: 16, color: EventLogsStyles.borderColor),

            // Detalles
            _buildDataColumn('DETALLES', log.details),
            const SizedBox(height: 10),

            // Usuario
            _buildDataColumn('USUARIO', log.user),
            const SizedBox(height: 10),

            // Rol(es)
            _buildDataColumn('ROL', log.rolesLabel),
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
            color: EventLogsStyles.dataLabelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: EventLogsStyles.bodyTextColor,
          ),
        ),
      ],
    );
  }
}
