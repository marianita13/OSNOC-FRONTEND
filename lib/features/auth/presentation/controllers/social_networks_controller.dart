import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/social_network.dart';
import '../pages/social_network_detail_page.dart';

class SocialNetworksController extends ChangeNotifier {
  String _searchQuery = '';
  int _pageSize = 10;
  int _currentPage = 1;

  // Opciones del selector "Mostrar N registros"
  final List<int> pageSizeOptions = const [10, 25, 50, 100];

  // Lista completa de redes sociales (mismo orden que la tabla web)
  final List<SocialNetwork> _networks = <SocialNetwork>[
    SocialNetwork(id: 1, name: 'Facebook', icon: 'facebook', postUrl: 'https:/osnoc.com/', order: 1, isActive: true),
    SocialNetwork(id: 2, name: 'Google+', icon: 'google', postUrl: '#', order: 2, isActive: false),
    SocialNetwork(id: 3, name: 'Instagram', icon: 'instagram', postUrl: '#', order: 3, isActive: false),
    SocialNetwork(id: 4, name: 'LinkedIn', icon: 'linkedin', postUrl: '#', order: 4, isActive: false),
    SocialNetwork(id: 8, name: 'Skype', icon: 'skype', postUrl: '', order: 8, isActive: true),
    SocialNetwork(
      id: 5,
      name: 'Twitter',
      icon: 'twitter',
      postUrl: 'https://twitter.com/intent/tweet?url=osnoc',
      order: 5,
      isActive: true,
    ),
    SocialNetwork(
      id: 6,
      name: 'WhatsApp',
      icon: 'whatsapp',
      postUrl: 'https://api.whatsapp.com/send?phone=57XXXXXXXXXX',
      order: 6,
      isActive: true,
    ),
    SocialNetwork(id: 7, name: 'WordPress', icon: 'wordpress', postUrl: '#', order: 7, isActive: false),
    SocialNetwork(
      id: 9,
      name: 'Yiutube',
      icon: 'youtube',
      postUrl: 'https://twitter.com/intent/tweet?url=osnoc',
      order: 15,
      isActive: false,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<SocialNetwork> get allNetworks => _networks;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;

  List<SocialNetwork> get filteredNetworks {
    if (_searchQuery.isEmpty) {
      return _networks;
    }
    final String query = _searchQuery.toLowerCase();
    final List<SocialNetwork> result = <SocialNetwork>[];
    for (final SocialNetwork network in _networks) {
      if (network.id.toString().contains(query) ||
          network.name.toLowerCase().contains(query) ||
          network.postUrl.toLowerCase().contains(query) ||
          network.order.toString().contains(query) ||
          network.activeLabel.toLowerCase().contains(query)) {
        result.add(network);
      }
    }
    return result;
  }

  int get totalPages {
    final int total = filteredNetworks.length;
    return total == 0 ? 1 : (total / _pageSize).ceil();
  }

  // Redes visibles en la página actual
  List<SocialNetwork> get pagedNetworks {
    final List<SocialNetwork> filtered = filteredNetworks;
    if (filtered.isEmpty) return <SocialNetwork>[];
    final int start = (_currentPage - 1) * _pageSize;
    final int end = min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  // Texto "Mostrando X a Y de Z registros"
  String get recordsInfo {
    final int total = filteredNetworks.length;
    if (total == 0) return 'Mostrando 0 a 0 de 0 registros';
    final int start = (_currentPage - 1) * _pageSize + 1;
    final int end = min(_currentPage * _pageSize, total);
    final String base = 'Mostrando $start a $end de $total registros';
    if (_searchQuery.isNotEmpty) {
      return '$base (filtrado de ${_networks.length} registros)';
    }
    return base;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
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

  // Evita quedar en una página vacía después de eliminar registros
  void _clampCurrentPage() {
    if (_currentPage > totalPages) {
      _currentPage = totalPages;
    }
  }

  int get _nextId {
    int maxId = 0;
    for (final SocialNetwork network in _networks) {
      if (network.id > maxId) maxId = network.id;
    }
    return maxId + 1;
  }

  // Abre la pantalla de detalle y devuelve la red resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<SocialNetwork?> _openDetail(
    BuildContext context,
    SocialNetwork network,
    String action,
  ) {
    return Navigator.push<SocialNetwork>(
      context,
      MaterialPageRoute(
        builder: (_) => SocialNetworkDetailPage(network: network, action: action),
      ),
    );
  }

  // Métodos de navegación (Nueva, Editar, Eliminar)
  Future<void> navigateToNewNetwork(BuildContext context) async {
    final int id = _nextId;
    final SocialNetwork? created = await _openDetail(
      context,
      SocialNetwork(
        id: id,
        name: '',
        icon: 'facebook',
        postUrl: '',
        order: id,
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      _networks.add(created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditNetwork(BuildContext context, SocialNetwork network) async {
    final SocialNetwork? updated = await _openDetail(context, network, 'edit');
    if (updated != null) {
      final int index = _networks.indexOf(network);
      if (index != -1) {
        _networks[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToDeleteNetwork(BuildContext context, SocialNetwork network) async {
    final SocialNetwork? confirmed = await _openDetail(context, network, 'delete');
    if (confirmed != null) {
      _networks.remove(network);
      _clampCurrentPage();
      notifyListeners();
    }
  }
}
