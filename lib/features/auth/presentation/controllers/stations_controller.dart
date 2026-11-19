import 'package:flutter/material.dart';
import '../../models/station.dart';
import '../pages/station_detail_page.dart';

class StationsController extends ChangeNotifier {
  String _searchQuery = '';

  // Lista completa de estaciones sismológicas
  final List<Station> _stations = [
    Station(
      name: 'Estación Campo Hermoso CHER',
      latitude: '7° 6\' 3.6"',
      longitude: '73° 8\'26.472"',
      altitude: 902.6,
      isActive: true,
    ),
    Station(
      name: 'Estación Carrizal',
      latitude: '7° 8\'3.59"',
      longitude: '73° 9\'36.68"',
      altitude: 707.0,
      isActive: true,
    ),
    Station(
      name: 'Estación CAV Floridablanca',
      latitude: '7° 4\'16.5"',
      longitude: '73° 4\'24.588"',
      altitude: 1144.3,
      isActive: true,
    ),
    Station(
      name: 'Estación Corporación CDMB',
      latitude: '7° 7\'7.97"',
      longitude: '73° 7\'9.29"',
      altitude: 973.0,
      isActive: true,
    ),
    Station(
      name: 'Estación Girón-Acapulco',
      latitude: '7° 3\'55.34"',
      longitude: '73° 7\'40.76"',
      altitude: 757.0,
      isActive: false,
    ),
    Station(
      name: 'Estación Mesa de Los Santos',
      latitude: '6° 53\'50.71"',
      longitude: '73° 2\'9.64"',
      altitude: 1687.0,
      isActive: true,
    ),
    Station(
      name: 'Estación Parque Morrorico MORR',
      latitude: '7° 7\'58.728"',
      longitude: '73° 6\'24.642"',
      altitude: 1177.0,
      isActive: true,
    ),
    Station(
      name: 'Estación UIS',
      latitude: '7° 8\'25.57"',
      longitude: '73° 7\'8.43"',
      altitude: 998.0,
      isActive: true,
    ),
    Station(
      name: 'Estación Villa Helena VHEL',
      latitude: '7° 9\'16.458"',
      longitude: '73° 7\'36.546"',
      altitude: 665.3,
      isActive: true,
    ),
    Station(
      name: 'Estación Vivero la Rosita LROS',
      latitude: '7° 6\'40.824"',
      longitude: '73° 7\'29.55"',
      altitude: 899.5,
      isActive: true,
    ),
    Station(
      name: 'Estación Vivero Nazareth VNAZ',
      latitude: '7° 8\'5.376"',
      longitude: '73° 7\'56.88"',
      altitude: 945.0,
      isActive: true,
    ),
    Station(
      name: 'Estación Vivero Provenza',
      latitude: '7° 4\'56.06"',
      longitude: '73° 6\'45.61"',
      altitude: 900.0,
      isActive: false,
    ),
  ];

  // Getters para exponer los datos a la vista
  List<Station> get allStations => _stations;

  List<Station> get filteredStations {
    if (_searchQuery.isEmpty) {
      return _stations;
    }
    final query = _searchQuery.toLowerCase();
    return _stations.where((station) {
      return station.name.toLowerCase().contains(query) ||
          station.latitude.toLowerCase().contains(query) ||
          station.longitude.toLowerCase().contains(query);
    }).toList();
  }

  // Actualizar consulta de búsqueda y notificar cambios
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Lógica para exportar registros
  void exportStations() {
    // Implementación futura de exportación
  }

  // Abre la pantalla de detalle y devuelve la estación resultante
  // (null si el usuario volvió atrás sin confirmar).
  Future<Station?> _openDetail(
    BuildContext context,
    Station station,
    String action,
  ) {
    return Navigator.push<Station>(
      context,
      MaterialPageRoute(
        builder: (_) => StationDetailPage(station: station, action: action),
      ),
    );
  }

  // Métodos de navegación limpios y centralizados
  Future<void> navigateToNewStation(BuildContext context) async {
    final created = await _openDetail(
      context,
      Station(
        name: '',
        latitude: '',
        longitude: '',
        altitude: 0.0,
        isActive: true,
      ),
      'new',
    );
    if (created != null) {
      _stations.add(created);
      notifyListeners();
    }
  }

  Future<void> navigateToEditStation(
    BuildContext context,
    Station station,
  ) async {
    final updated = await _openDetail(context, station, 'edit');
    if (updated != null) {
      final index = _stations.indexOf(station);
      if (index != -1) {
        _stations[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> navigateToViewStation(
    BuildContext context,
    Station station,
  ) async {
    await _openDetail(context, station, 'view');
  }

  Future<void> navigateToDeleteStation(
    BuildContext context,
    Station station,
  ) async {
    final confirmed = await _openDetail(context, station, 'delete');
    if (confirmed != null) {
      _stations.remove(station);
      notifyListeners();
    }
  }
}