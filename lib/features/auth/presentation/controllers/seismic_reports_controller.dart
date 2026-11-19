import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/seismic_report.dart';
import '../pages/seismic_report_detail_page.dart';

class SeismicReportsController extends ChangeNotifier {
  String _searchQuery = '';
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Mostrar N registros"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Lista completa de reportes sísmicos (mismo orden que la tabla web)
  final List<SeismicReport> _reports = [
    SeismicReport(
      id: 1,
      description: 'Reporte 1',
      originTime: DateTime(2024, 1, 21, 17, 19, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 1, 19, 5, 12),
      isActive: true,
    ),
    SeismicReport(
      id: 2,
      description: 'Reporte 2',
      originTime: DateTime(2024, 1, 22, 14, 5, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 1, 20, 2, 24),
      isActive: true,
    ),
    SeismicReport(
      id: 3,
      description: 'Reporte 3',
      originTime: DateTime(2024, 2, 4, 3, 53, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 15, 43, 30),
      isActive: true,
    ),
    SeismicReport(
      id: 4,
      description: 'Reporte 4',
      originTime: DateTime(2024, 2, 19, 20, 38, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 16, 12, 42),
      isActive: true,
    ),
    SeismicReport(
      id: 5,
      description: 'Reporte 5',
      originTime: DateTime(2024, 2, 20, 18, 23, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 16, 31, 54),
      isActive: true,
    ),
    SeismicReport(
      id: 6,
      description: 'Reporte 6',
      originTime: DateTime(2024, 2, 21, 23, 5, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 16, 39, 33),
      isActive: true,
    ),
    SeismicReport(
      id: 7,
      description: 'Reporte 7',
      originTime: DateTime(2024, 2, 24, 18, 49, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 16, 44, 51),
      isActive: true,
    ),
    SeismicReport(
      id: 8,
      description: 'Reporte 8',
      originTime: DateTime(2024, 2, 24, 18, 49, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 2, 16, 48, 45),
      isActive: false,
    ),
    SeismicReport(
      id: 9,
      description: 'Reporte 9',
      originTime: DateTime(2024, 3, 6, 16, 12, 0),
      epicenter: 'Los Santos',
      registrationDate: DateTime(2024, 4, 5, 14, 4, 11),
      isActive: true,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<SeismicReport> get allReports => _reports;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<SeismicReport> get filteredReports {
    if (_searchQuery.isEmpty) {
      return _reports;
    }
    final query = _searchQuery.toLowerCase();
    return _reports.where((report) {
      return report.description.toLowerCase().contains(query) ||
          report.epicenter.toLowerCase().contains(query) ||
          report.formattedOriginTime.contains(query) ||
          report.formattedRegistrationDate.contains(query) ||
          report.isActive.toString().contains(query);
    }).toList();
  }

  int get totalPages {
    final total = filteredReports.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  // Reportes visibles en la página actual
  List<SeismicReport> get pagedReports {
    final filtered = filteredReports;
    if (filtered.isEmpty) return [];
    final start = (_currentPage - 1) * _pageSize;
    final end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final total = filteredReports.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final start = (_currentPage - 1) * _pageSize + 1;
    final end = min(_currentPage * _pageSize, total);
    final base = 'Mostrando $start a $end de $total registros';
    if (_searchQuery.isNotEmpty) {
      return '$base (filtrado de ${_reports.length} registros)';
    }
    return base;
  }

  // Actualizar consulta de búsqueda y notificar cambios
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  // Cambiar la cantidad de registros por página
  void updatePageSize(int? size) {
    if (size == null || size == _pageSize) return;
    _pageSize = size;
    _currentPage = 1;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    _currentPage = page;
    notifyListeners();
  }

  void previousPage() => goToPage(_currentPage - 1);
  void nextPage() => goToPage(_currentPage + 1);

  // Evita quedar en una página vacía después de eliminar registros
  void _clampCurrentPage() {
    if (_currentPage > totalPages) {
      _currentPage = totalPages;
    }
  }

  int get _nextId {
    if (_reports.isEmpty) return 1;
    return _reports.map((r) => r.id).reduce(max) + 1;
  }

  // Lógica para exportar registros a Excel
  void exportReports() {
    // Implementación futura de exportación
  }

  // Abre la pantalla de detalle y devuelve el reporte resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<SeismicReport?> _openDetail(
    BuildContext context,
    SeismicReport report,
    String action,
  ) {
    return Navigator.push<SeismicReport>(
      context,
      MaterialPageRoute(
        builder: (_) => SeismicReportDetailPage(report: report, action: action),
      ),
    );
  }

  // Métodos de navegación (Nuevo, Editar, Ver, Eliminar)
  Future<void> navigateToNewReport(BuildContext context) async {
    final now = DateTime.now();
    final created = await _openDetail(
      context,
      SeismicReport(
        id: _nextId,
        description: '',
        originTime: DateTime(now.year, now.month, now.day, now.hour, now.minute),
        epicenter: '',
        registrationDate: now,
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      // Los nuevos se agregan al final, como en la tabla web
      _reports.add(created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditReport(BuildContext context, SeismicReport report) async {
    final updated = await _openDetail(context, report, 'edit');
    if (updated != null) {
      final index = _reports.indexOf(report);
      if (index != -1) {
        _reports[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToViewReport(BuildContext context, SeismicReport report) async {
    await _openDetail(context, report, 'view');
  }

  Future<void> navigateToDeleteReport(BuildContext context, SeismicReport report) async {
    final confirmed = await _openDetail(context, report, 'delete');
    if (confirmed != null) {
      _reports.remove(report);
      _clampCurrentPage();
      notifyListeners();
    }
  }
}
