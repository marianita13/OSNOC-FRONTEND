import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../pages/news_detail_page.dart';

class NewsController extends ChangeNotifier {
  String _searchQuery = '';
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Mostrar N registros"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Lista completa de noticias (mismo orden que la tabla web)
  final List<News> _news = [
    News(
      id: 7,
      title: 'Publican el análisis de los últimos eventos sísmicos registrados en Santander',
      summary: 'Publican el análisis de los últimos eventos sísmicos registrados en Santander',
      publicationDate: DateTime(2020, 8, 7),
      registrationDate: DateTime(2024, 6, 25, 8, 13, 12),
      isActive: true,
    ),
    News(
      id: 4,
      title: 'El Observatorio Sismológico del Nororiente Colombiano, una gran '
          'fortaleza para el departamento de Santander',
      summary: 'El Observatorio Sismológico del Nororiente Colombiano, una gran '
          'fortaleza para el departamento de Santander',
      publicationDate: DateTime(2021, 5, 24),
      registrationDate: DateTime(2024, 6, 25, 7, 41, 36),
      isActive: true,
    ),
    News(
      id: 5,
      title: 'Así funciona una estación del Observatorio Sismológico del '
          'Nororiente Colombiano',
      summary: 'Así funciona una estación del Observatorio Sismológico del '
          'Nororiente Colombiano',
      publicationDate: DateTime(2021, 6, 28),
      registrationDate: DateTime(2024, 6, 25, 7, 45, 53),
      isActive: true,
    ),
    News(
      id: 6,
      title: 'Observatorio Sismológico del Nororiente tendrá nuevas estaciones de monitoreo',
      summary: 'Observatorio Sismológico del Nororiente tendrá nuevas estaciones de monitoreo',
      publicationDate: DateTime(2021, 12, 16),
      registrationDate: DateTime(2024, 6, 25, 7, 53, 44),
      isActive: true,
    ),
    News(
      id: 3,
      title: 'Estudiantes de Geología UDES visitaron estaciones del Observatorio '
          'Sismológico del Nororiente Colombiano',
      summary: 'Estudiantes de Geología UDES visitaron estaciones del Observatorio '
          'Sismológico del Nororiente Colombiano',
      publicationDate: DateTime(2023, 11, 8),
      registrationDate: DateTime(2024, 6, 25, 7, 30, 9),
      isActive: true,
    ),
    News(
      id: 2,
      title: 'Todo lo que debes saber de un sismo": UDES participó el Encuentro '
          'de Divulgación de las Geociencias',
      summary: 'Todo lo que debes saber de un sismo": UDES participó el Encuentro '
          'de Divulgación de las Geociencias',
      publicationDate: DateTime(2023, 11, 29),
      registrationDate: DateTime(2024, 6, 25, 6, 18, 57),
      isActive: true,
    ),
    News(
      id: 1,
      title: 'De los 4.865 sismos reportados en Santander en el primer trimestre '
          'del año, solo uno superó una magnitud de 5.0: OSNOC',
      summary: 'De los 4.865 sismos reportados en Santander en el primer trimestre '
          'del año, solo uno superó una magnitud de 5.0: OSNOC',
      publicationDate: DateTime(2024, 4, 17),
      registrationDate: DateTime(2024, 6, 25, 5, 41, 2),
      isActive: true,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<News> get allNews => _news;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<News> get filteredNews {
    if (_searchQuery.isEmpty) {
      return _news;
    }
    final query = _searchQuery.toLowerCase();
    return _news.where((item) {
      return item.id.toString().contains(query) ||
          item.title.toLowerCase().contains(query) ||
          item.summary.toLowerCase().contains(query) ||
          item.formattedPublicationDate.contains(query) ||
          item.formattedRegistrationDate.contains(query) ||
          item.activeLabel.toLowerCase().contains(query);
    }).toList();
  }

  int get totalPages {
    final total = filteredNews.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  // Noticias visibles en la página actual
  List<News> get pagedNews {
    final filtered = filteredNews;
    if (filtered.isEmpty) return [];
    final start = (_currentPage - 1) * _pageSize;
    final end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final total = filteredNews.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final start = (_currentPage - 1) * _pageSize + 1;
    final end = min(_currentPage * _pageSize, total);
    final base = 'Mostrando $start a $end de $total registros';
    if (_searchQuery.isNotEmpty) {
      return '$base (filtrado de ${_news.length} registros)';
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
    if (_news.isEmpty) return 1;
    return _news.map((n) => n.id).reduce(max) + 1;
  }

  // Lógica para exportar registros a Excel
  void exportNews() {
    // Implementación futura de exportación
  }

  // Abre la pantalla de detalle y devuelve la noticia resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<News?> _openDetail(
    BuildContext context,
    News news,
    String action,
  ) {
    return Navigator.push<News>(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailPage(news: news, action: action),
      ),
    );
  }

  // Métodos de navegación (Nueva, Editar, Ver, Eliminar)
  Future<void> navigateToNewNews(BuildContext context) async {
    final now = DateTime.now();
    final created = await _openDetail(
      context,
      News(
        id: _nextId,
        title: '',
        summary: '',
        publicationDate: DateTime(now.year, now.month, now.day),
        registrationDate: now,
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      // Las más recientes se muestran primero
      _news.insert(0, created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditNews(BuildContext context, News news) async {
    final updated = await _openDetail(context, news, 'edit');
    if (updated != null) {
      final index = _news.indexOf(news);
      if (index != -1) {
        _news[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToViewNews(BuildContext context, News news) async {
    await _openDetail(context, news, 'view');
  }

  Future<void> navigateToDeleteNews(BuildContext context, News news) async {
    final confirmed = await _openDetail(context, news, 'delete');
    if (confirmed != null) {
      _news.remove(news);
      _clampCurrentPage();
      notifyListeners();
    }
  }
}
