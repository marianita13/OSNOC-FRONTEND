import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/publication.dart';
import '../pages/publication_detail_page.dart';

class PublicationsController extends ChangeNotifier {
  String _searchQuery = '';
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Mostrar N registros"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Lista completa de publicaciones
  final List<Publication> _publications = [
    Publication(
      id: 7,
      title: 'Sismos - Lo que debes saber',
      publicationDate: DateTime(2024, 6, 13),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2024, 6, 13, 21, 57, 34),
      isActive: true,
    ),
    Publication(
      id: 6,
      title: 'Hipocentro Vs Hepicentro',
      publicationDate: DateTime(2024, 6, 13),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2024, 6, 13, 21, 30, 52),
      isActive: true,
    ),
    Publication(
      id: 5,
      title: 'Como se mide un Sismo',
      publicationDate: DateTime(2024, 6, 13),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2024, 6, 13, 21, 0, 30),
      isActive: true,
    ),
    Publication(
      id: 3,
      title: 'Poster Material Pedagogico',
      publicationDate: DateTime(2024, 5, 18),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2024, 5, 18, 21, 54, 2),
      isActive: true,
    ),
    Publication(
      id: 2,
      title: 'Infografia Adultos OSNOC',
      publicationDate: DateTime(2024, 3, 26),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2023, 9, 22, 15, 24, 38),
      isActive: true,
    ),
    Publication(
      id: 1,
      title: 'Infografia Jovenes OSNOC',
      publicationDate: DateTime(2023, 9, 21),
      user: 'Super Administrador',
      roles: 'Administrador',
      registrationDate: DateTime(2023, 9, 21, 14, 6, 18),
      isActive: true,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<Publication> get allPublications => _publications;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<Publication> get filteredPublications {
    if (_searchQuery.isEmpty) {
      return _publications;
    }
    final query = _searchQuery.toLowerCase();
    return _publications.where((publication) {
      return publication.id.toString().contains(query) ||
          publication.title.toLowerCase().contains(query) ||
          publication.user.toLowerCase().contains(query) ||
          publication.roles.toLowerCase().contains(query) ||
          publication.formattedPublicationDate.contains(query) ||
          publication.formattedRegistrationDate.contains(query);
    }).toList();
  }

  int get totalPages {
    final total = filteredPublications.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  // Publicaciones visibles en la página actual
  List<Publication> get pagedPublications {
    final filtered = filteredPublications;
    if (filtered.isEmpty) return [];
    final start = (_currentPage - 1) * _pageSize;
    final end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final total = filteredPublications.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final start = (_currentPage - 1) * _pageSize + 1;
    final end = min(_currentPage * _pageSize, total);
    final base = 'Mostrando $start a $end de $total registros';
    if (_searchQuery.isNotEmpty) {
      return '$base (filtrado de ${_publications.length} registros)';
    }
    return base;
  }

  bool get canGoPrevious => _currentPage > 1;
  bool get canGoNext => _currentPage < totalPages;

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
    if (_publications.isEmpty) return 1;
    return _publications.map((p) => p.id).reduce(max) + 1;
  }

  // Lógica para exportar registros
  void exportPublications() {
    // Implementación futura de exportación
  }

  // Abre la pantalla de detalle y devuelve la publicación resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<Publication?> _openDetail(
    BuildContext context,
    Publication publication,
    String action,
  ) {
    return Navigator.push<Publication>(
      context,
      MaterialPageRoute(
        builder: (_) => PublicationDetailPage(
          publication: publication,
          action: action,
        ),
      ),
    );
  }

  // Métodos de navegación limpios y centralizados
  Future<void> navigateToNewPublication(BuildContext context) async {
    final now = DateTime.now();
    final created = await _openDetail(
      context,
      Publication(
        id: _nextId,
        title: '',
        publicationDate: DateTime(now.year, now.month, now.day),
        user: 'Super Administrador',
        roles: 'Administrador',
        registrationDate: now,
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      // Las más recientes se muestran primero, como en la tabla web
      _publications.insert(0, created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditPublication(
    BuildContext context,
    Publication publication,
  ) async {
    final updated = await _openDetail(context, publication, 'edit');
    if (updated != null) {
      final index = _publications.indexOf(publication);
      if (index != -1) {
        _publications[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToViewPublication(
    BuildContext context,
    Publication publication,
  ) async {
    await _openDetail(context, publication, 'view');
  }

  Future<void> navigateToDeletePublication(
    BuildContext context,
    Publication publication,
  ) async {
    final confirmed = await _openDetail(context, publication, 'delete');
    if (confirmed != null) {
      _publications.remove(publication);
      _clampCurrentPage();
      notifyListeners();
    }
  }
}

