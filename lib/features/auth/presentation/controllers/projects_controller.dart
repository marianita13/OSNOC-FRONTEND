import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../pages/project_detail_page.dart';

class ProjectsController extends ChangeNotifier {
  String _searchQuery = '';
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Mostrar N registros"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Lista completa de proyectos (mismo orden que la tabla web)
  final List<Project> _projects = [
    Project(
      id: 2,
      name: 'Caracterizacion geotecnica de los suelos (estaciones vivero '
          'Nazareth Campo hermoso',
      description: 'A continuación, se les presento el informe final denominado '
          '“CARACTERIZACIÓN GEOTÉCNICA DE LOS SUELOS EN DONDE SE ENCUENTRAN '
          'UBICADAS LAS ESTACIONES SISMOLÓGICAS VIVERO NAZARET Y CAMPO HERMOSO '
          'DEL OBSERVATORIO SISMOLÓGICO DEL ORIENTE COLOMBIANO”. El cual se '
          'deriva de las sendas visitas de campo y de toma de muestras de '
          'suelos mediante apiques en el sitio en donde se construyeron dos '
          '(02) estaciones sismológicas (Estación. 1: Estación Vivero Nazareth '
          'y Estación. 2: Estación Campo Hermoso) del Observatorio Sismológico '
          'del Oriente Colombiano.Las muestras de suelos sustraídas de los '
          'apliques mencionados fueron caracterizadas geotécnicamente en el '
          'laboratorio de suelos y pavimentos de la Universidad De Santander '
          '(UDES). De tal manera que se determinó su distribución '
          'granulométrica y estados de consistencia (límites de ATTERBERG), '
          'con el fin de clasificar los suelos estudiamos mediante el Sistema '
          'Unificado De Clasificación De Suelos (SUCS) y mediante la '
          'metodología de la American Association of State Highway and '
          'Transportation Officials (AASHTO).',
      fileName: 'CARACTERIZACION GEOTECNICA DE LOS SUELOS (ESTACIONES VIVERO '
          'NAZARETH_CAMPO HERMOSO)_Ronald Ramirez_ing civil_2023.pdf',
      registrationDate: DateTime(2024, 5, 18, 11, 31, 7),
      isActive: true,
    ),
    Project(
      id: 4,
      name: 'DETERMINACIÓN DE LOS PERIODOS FUNDAMENTALES DEL SUELO EN '
          'ESTACIONES DE LA RED DE ACELERÓGRAFOS QUE C',
      description: 'DETERMINACIÓN DE LOS PERIODOS FUNDAMENTALES DEL SUELO EN '
          'ESTACIONES DE LA RED DE ACELERÓGRAFOS QUE C',
      fileName: 'Garcia-Barreto, 2019_Determinación de los periodos '
          'fundamentales del suelos en estaciones OSNOC.pdf',
      registrationDate: DateTime(2024, 5, 19, 20, 12, 18),
      isActive: true,
    ),
    Project(
      id: 1,
      name: 'ESTUDIO DE SUELOS PRELIMINAR DE LA ESTACIÓN VIVERO LA ROSITA CDMB',
      description: 'La zona estudiada se encuentra localizada en Bucaramanga, '
          'Santander, en la estación la rosita CDMB con coordenadas '
          '7° 6′ 42.09° N -73°7′27.87° W.',
      fileName: 'Baez-Mariño, 2023_ Estudio de suelos preliminar de la '
          'estación Vivero La Rosita CDMB.pdf',
      registrationDate: DateTime(2024, 3, 29, 10, 56, 3),
      isActive: true,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<Project> get allProjects => _projects;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<Project> get filteredProjects {
    if (_searchQuery.isEmpty) {
      return _projects;
    }
    final query = _searchQuery.toLowerCase();
    return _projects.where((project) {
      return project.id.toString().contains(query) ||
          project.name.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.fileName.toLowerCase().contains(query) ||
          project.formattedRegistrationDate.contains(query) ||
          project.activeLabel.toLowerCase().contains(query);
    }).toList();
  }

  int get totalPages {
    final total = filteredProjects.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  // Proyectos visibles en la página actual
  List<Project> get pagedProjects {
    final filtered = filteredProjects;
    if (filtered.isEmpty) return [];
    final start = (_currentPage - 1) * _pageSize;
    final end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final total = filteredProjects.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final start = (_currentPage - 1) * _pageSize + 1;
    final end = min(_currentPage * _pageSize, total);
    final base = 'Mostrando $start a $end de $total registros';
    if (_searchQuery.isNotEmpty) {
      return '$base (filtrado de ${_projects.length} registros)';
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
    if (_projects.isEmpty) return 1;
    return _projects.map((p) => p.id).reduce(max) + 1;
  }

  // Lógica para exportar registros a Excel
  void exportProjects() {
    // Implementación futura de exportación
  }

  // Abre la pantalla de detalle y devuelve el proyecto resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<Project?> _openDetail(
    BuildContext context,
    Project project,
    String action,
  ) {
    return Navigator.push<Project>(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailPage(project: project, action: action),
      ),
    );
  }

  // Métodos de navegación (Nuevo, Editar, Ver, Eliminar)
  Future<void> navigateToNewProject(BuildContext context) async {
    final created = await _openDetail(
      context,
      Project(
        id: _nextId,
        name: '',
        description: '',
        fileName: '',
        registrationDate: DateTime.now(),
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      // Los más recientes se muestran primero
      _projects.insert(0, created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditProject(
    BuildContext context,
    Project project,
  ) async {
    final updated = await _openDetail(context, project, 'edit');
    if (updated != null) {
      final index = _projects.indexOf(project);
      if (index != -1) {
        _projects[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToViewProject(
    BuildContext context,
    Project project,
  ) async {
    await _openDetail(context, project, 'view');
  }

  Future<void> navigateToDeleteProject(
    BuildContext context,
    Project project,
  ) async {
    final confirmed = await _openDetail(context, project, 'delete');
    if (confirmed != null) {
      _projects.remove(project);
      _clampCurrentPage();
      notifyListeners();
    }
  }
}
