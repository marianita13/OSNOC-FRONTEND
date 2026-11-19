import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/event_log.dart';

class EventLogsController extends ChangeNotifier {
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Page Size"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Roles del usuario que aparecen en el log
  static const List<String> _userRoles = <String>[
    'Geo-divulgador',
    'Gestor de contenido sitio',
    'Gestor de estaciones sísmicas',
    'Gestor de redes sociales',
    'Log de eventos',
    'Publicador de noticias',
    'Publicador de proyectos',
    'Publicador reportes sísmicos',
  ];

  // Registros del log (mismo orden que la tabla web: más recientes primero)
  final List<EventLog> _logs = <EventLog>[
    EventLog(
      number: 1,
      table: 'Log de eventos',
      details: 'Consultar log de eventos',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 11, 53, 48),
    ),
    EventLog(
      number: 2,
      table: 'Sesion',
      details: 'Inicio de sesión: Mariana Acero Velasquez',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 11, 53, 45),
    ),
    EventLog(
      number: 3,
      table: 'Sesion',
      details: 'Inicio de sesión: Mariana Acero Velasquez',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 10, 35, 32),
    ),
    EventLog(
      number: 4,
      table: 'Log de eventos',
      details: 'Consultar log de eventos',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 10, 35, 19),
    ),
    EventLog(
      number: 5,
      table: 'Sesion',
      details: 'Inicio de sesión: Mariana Acero Velasquez',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 9, 39, 44),
    ),
    EventLog(
      number: 6,
      table: 'Sesion',
      details: 'Inicio de sesión: Mariana Acero Velasquez',
      user: 'Mariana Acero Velasquez',
      roles: _userRoles,
      registrationDate: DateTime(2026, 11, 3, 8, 49, 1),
    ),
  ];

  // Lista segura: descarta cualquier elemento nulo antes de leer sus campos.
  // Así nunca aparece el error "can't be unconditionally accessed because
  // the receiver can be 'null'".
  List<EventLog> get _items => _logs.whereType<EventLog>().toList();

  // ---------- Filtros ----------
  // Valores elegidos en el panel (todavía sin aplicar)
  String? selectedTable;
  String? selectedUser;
  String? selectedRole;
  DateTime? startDate;
  DateTime? endDate;

  // Filtros que realmente se aplican a la lista (al tocar "Aplicar filtros")
  String? _appliedTable;
  String? _appliedUser;
  String? _appliedRole;
  DateTime? _appliedStart;
  DateTime? _appliedEnd;

  // Opciones de los desplegables, tomadas de los propios registros
  List<String> get tableOptions {
    final List<String> values = <String>[];
    for (final EventLog item in _items) {
      values.add(item.table);
    }
    return _unique(values);
  }

  List<String> get userOptions {
    final List<String> values = <String>[];
    for (final EventLog item in _items) {
      values.add(item.user);
    }
    return _unique(values);
  }

  List<String> get roleOptions {
    final List<String> values = <String>[];
    for (final EventLog item in _items) {
      values.addAll(item.roles);
    }
    return _unique(values);
  }

  static List<String> _unique(List<String> values) {
    final List<String> list = values.toSet().toList();
    list.sort();
    return list;
  }

  bool get hasActiveFilters =>
      _appliedTable != null ||
      _appliedUser != null ||
      _appliedRole != null ||
      _appliedStart != null ||
      _appliedEnd != null;

  void changeTable(String? value) {
    selectedTable = value;
    notifyListeners();
  }

  void changeUser(String? value) {
    selectedUser = value;
    notifyListeners();
  }

  void changeRole(String? value) {
    selectedRole = value;
    notifyListeners();
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'dd/mm/aaaa';
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Fecha inicial del rango
  Future<void> pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate = picked;
      // Si la fecha final quedó antes que la inicial, se limpia
      final DateTime? currentEnd = endDate;
      if (currentEnd != null && currentEnd.isBefore(picked)) {
        endDate = null;
      }
      notifyListeners();
    }
  }

  // Fecha final del rango (solo se habilita después de elegir la inicial)
  Future<void> pickEndDate(BuildContext context) async {
    final DateTime? start = startDate;
    if (start == null) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? start,
      firstDate: start,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate = picked;
      notifyListeners();
    }
  }

  void applyFilters() {
    _appliedTable = selectedTable;
    _appliedUser = selectedUser;
    _appliedRole = selectedRole;
    _appliedStart = startDate;
    _appliedEnd = endDate;
    _currentPage = 1;
    notifyListeners();
  }

  void removeFilters() {
    selectedTable = null;
    selectedUser = null;
    selectedRole = null;
    startDate = null;
    endDate = null;
    applyFilters();
  }

  // ---------- Lista y paginación ----------
  List<EventLog> get allLogs => _items;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<EventLog> get filteredLogs {
    final String? table = _appliedTable;
    final String? user = _appliedUser;
    final String? role = _appliedRole;
    final DateTime? start = _appliedStart;
    final DateTime? end = _appliedEnd;

    final List<EventLog> result = <EventLog>[];
    for (final EventLog item in _items) {
      if (table != null && item.table != table) continue;
      if (user != null && item.user != user) continue;
      if (role != null && !item.roles.contains(role)) continue;

      final DateTime day = DateTime(
        item.registrationDate.year,
        item.registrationDate.month,
        item.registrationDate.day,
      );
      if (start != null && day.isBefore(start)) continue;
      if (end != null && day.isAfter(end)) continue;

      result.add(item);
    }
    return result;
  }

  int get totalPages {
    final int total = filteredLogs.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  List<EventLog> get pagedLogs {
    final List<EventLog> filtered = filteredLogs;
    if (filtered.isEmpty) return <EventLog>[];
    final int start = (_currentPage - 1) * _pageSize;
    final int end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final int total = filteredLogs.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final int start = (_currentPage - 1) * _pageSize + 1;
    final int end = min(_currentPage * _pageSize, total);
    final String base = 'Mostrando $start a $end de $total registros';
    if (hasActiveFilters) {
      return '$base (filtrado de ${_items.length} registros)';
    }
    return base;
  }

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
}
