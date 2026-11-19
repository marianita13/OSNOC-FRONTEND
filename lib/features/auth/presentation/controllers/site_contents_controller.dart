import 'package:flutter/material.dart';
import '../../models/site_content.dart';
import '../pages/site_content_detail_page.dart';
import 'site_contents_store.dart';

class SiteContentsController extends ChangeNotifier {
  // Destinos posibles de un contenido dentro del sitio
  static const String mainPage = 'Sección Página Principal';
  static const String secondaryPage = 'Página Secundaria';
  static const List<String> destinations = [mainPage, secondaryPage];

  String _searchQuery = '';

  // Los datos viven en el almacén compartido (también los lee el Inicio)
  final SiteContentsStore _store = SiteContentsStore.instance;

  SiteContentsController() {
    _store.addListener(notifyListeners);
  }

  List<SiteContent> get _contents => _store.contents;

  // Getters para exponer los datos a la vista
  List<SiteContent> get allContents => _contents;

  List<SiteContent> get filteredContents {
    if (_searchQuery.isEmpty) {
      return _contents;
    }
    final query = _searchQuery.toLowerCase();
    return _contents.where((content) {
      return content.id.toString().contains(query) ||
          content.section.toLowerCase().contains(query) ||
          content.text.toLowerCase().contains(query) ||
          content.destination.toLowerCase().contains(query);
    }).toList();
  }

  // Actualizar consulta de búsqueda y notificar cambios
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Abre la pantalla de detalle y devuelve el contenido resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<SiteContent?> _openDetail(
    BuildContext context,
    SiteContent content,
    String action,
  ) {
    return Navigator.push<SiteContent>(
      context,
      MaterialPageRoute(
        builder: (_) => SiteContentDetailPage(content: content, action: action),
      ),
    );
  }

  int get _nextId => _store.nextId;

  // Lógica para exportar registros
  void exportContents() {
    // Implementación futura de exportación
  }

  // Métodos de navegación (Nuevo, Editar y Ver)
  Future<void> navigateToNewContent(BuildContext context) async {
    final created = await _openDetail(
      context,
      SiteContent(
        id: _nextId,
        section: '',
        text: '',
        destination: mainPage,
      ),
      'new',
    );
    if (created != null) {
      // Se agrega al final, siguiendo el orden por ID
      _store.add(created);
    }
  }

  Future<void> navigateToEditContent(
    BuildContext context,
    SiteContent content,
  ) async {
    final updated = await _openDetail(context, content, 'edit');
    if (updated != null) {
      _store.update(updated);
    }
  }

  Future<void> navigateToViewContent(
    BuildContext context,
    SiteContent content,
  ) async {
    await _openDetail(context, content, 'view');
  }

  @override
  void dispose() {
    _store.removeListener(notifyListeners);
    super.dispose();
  }
}
