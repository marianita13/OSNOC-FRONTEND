import 'package:flutter/material.dart';
import '../../models/event_log.dart';
import '../controllers/event_logs_controller.dart';
import '../theme/event_logs_styles.dart';
import '../widgets/event_log_card.dart';
import '../widgets/table_pagination.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class EventLogsContentView extends StatefulWidget {
  const EventLogsContentView({super.key});

  @override
  State<EventLogsContentView> createState() => _EventLogsContentViewState();
}

class _EventLogsContentViewState extends State<EventLogsContentView> {
  // Texto de la opción "sin filtro" de los desplegables.
  // Se usa como valor real (String no nulo) para evitar un DropdownButton<String?>.
  static const String _noFilter = '- Seleccione -';

  final EventLogsController _controller = EventLogsController();

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
        final List<EventLog> pagedLogs = _controller.pagedLogs;

        return SingleChildScrollView(
          // En computador centra el contenido con un ancho máximo
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Log eventos', style: EventLogsStyles.sectionTitle),
              const SizedBox(height: 16),

              // Panel de filtros
              _buildFilterPanel(context),
              const SizedBox(height: 16),

              // Selector "Page Size" (mismo patrón que "Mostrar N registros" de Publicaciones)
              Row(
                children: [
                  const Text('Page Size', style: EventLogsStyles.labelText),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: EventLogsStyles.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _controller.pageSize,
                        isDense: true,
                        style: const TextStyle(fontSize: 13, color: EventLogsStyles.titleColor),
                        items: _controller.pageSizeOptions
                            .map((size) => DropdownMenuItem<int>(value: size, child: Text('$size')))
                            .toList(),
                        onChanged: (value) => _controller.updatePageSize(value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Listado del log
              if (pagedLogs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No se encontraron registros',
                      style: EventLogsStyles.recordsInfoText,
                    ),
                  ),
                )
              else
                // En pantallas anchas muestra las tarjetas en 2 o 3 columnas
                ResponsiveGridList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagedLogs.length,
                  itemBuilder: (context, index) {
                    final log = pagedLogs[index];
                    return EventLogCard(log: log);
                  },
                ),
              const SizedBox(height: 8),

              // Información de registros y paginación
              Center(
                child: Text(
                  _controller.recordsInfo,
                  textAlign: TextAlign.center,
                  style: EventLogsStyles.recordsInfoText,
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

  // Panel azul claro con Tabla, Usuario, Rol, Rango de Fechas y botones
  Widget _buildFilterPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventLogsStyles.filterPanelBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Tabla y Usuario
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Tabla:',
                  value: _controller.selectedTable,
                  options: _controller.tableOptions,
                  onChanged: _controller.changeTable,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Usuario:',
                  value: _controller.selectedUser,
                  options: _controller.userOptions,
                  onChanged: _controller.changeUser,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila 2: Rol (ocupa todo el ancho porque los nombres son largos)
          _buildDropdown(
            label: 'Rol:',
            value: _controller.selectedRole,
            options: _controller.roleOptions,
            onChanged: _controller.changeRole,
          ),
          const SizedBox(height: 12),

          // Fila 3: Rango de Fechas (desde / hasta)
          const Text('Rango de Fechas', style: EventLogsStyles.filterLabel),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildDateBox(
                  text: _controller.formatDate(_controller.startDate),
                  enabled: true,
                  onTap: () => _controller.pickStartDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateBox(
                  text: _controller.formatDate(_controller.endDate),
                  enabled: _controller.startDate != null,
                  onTap: () => _controller.pickEndDate(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botones Aplicar / Remover filtros
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _controller.applyFilters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventLogsStyles.applyGrey,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                  ),
                  child: const Text('APLICAR FILTROS', style: EventLogsStyles.actionBtnText),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _controller.removeFilters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EventLogsStyles.removeRed,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                  ),
                  child: const Text('REMOVER FILTROS', style: EventLogsStyles.actionBtnText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Desplegable con "- Seleccione -" como primera opción (= sin filtro).
  // Usa DropdownButton<String> con valores NO nulos, igual que el resto de la app.
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    final List<String> items = <String>[_noFilter, ...options];
    final String current = (value != null && options.contains(value)) ? value : _noFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: EventLogsStyles.filterLabel),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: EventLogsStyles.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: current,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, color: EventLogsStyles.titleColor),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (selected) {
                // "- Seleccione -" equivale a quitar ese filtro
                onChanged(selected == null || selected == _noFilter ? null : selected);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Caja de fecha (dd/mm/aaaa) que abre el calendario
  // (mismo patrón que la fecha de publicación en el detalle de Publicaciones)
  Widget _buildDateBox({
    required String text,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : EventLogsStyles.disabledFieldBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: EventLogsStyles.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 13, color: EventLogsStyles.titleColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 15,
              color: enabled ? EventLogsStyles.titleColor : EventLogsStyles.dataLabelColor,
            ),
          ],
        ),
      ),
    );
  }
}
