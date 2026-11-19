import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../models/station.dart';
import '../theme/home_styles.dart';

// Mapa de OpenStreetMap con las estaciones sísmicas marcadas.
// No usa paquetes externos: arma el mapa con mosaicos (tiles) de 256 px
// descargados con Image.network y ubica cada estación con la proyección
// Web Mercator (la misma de Google Maps / OpenStreetMap).
// Verde = estación activa, gris = inactiva. Toca un marcador para ver su nombre.
class HomeStationsMap extends StatelessWidget {
  final List<Station> stations;
  final double height;

  const HomeStationsMap({
    super.key,
    required this.stations,
    this.height = 300,
  });

  static const double _tileSize = 256;

  // Convierte una coordenada en grados/minutos/segundos (ej: 7° 6' 3.6")
  // a grados decimales. Las longitudes de Colombia son Oeste, por eso van negativas.
  static double? parseDms(String value, {bool negative = false}) {
    final List<double> parts = RegExp(r'\d+(?:\.\d+)?')
        .allMatches(value)
        .map((m) => double.parse(m.group(0)!))
        .toList();
    if (parts.isEmpty) return null;
    final double degrees = parts[0];
    final double minutes = parts.length > 1 ? parts[1] : 0;
    final double seconds = parts.length > 2 ? parts[2] : 0;
    final double decimal = degrees + minutes / 60 + seconds / 3600;
    return negative ? -decimal : decimal;
  }

  // Longitud -> coordenada X en píxeles del mapa mundial al zoom dado
  static double _lngToX(double lng, int zoom) {
    return (lng + 180) / 360 * _tileSize * math.pow(2, zoom);
  }

  // Latitud -> coordenada Y en píxeles del mapa mundial al zoom dado
  static double _latToY(double lat, int zoom) {
    final double rad = lat * math.pi / 180;
    final double merc = math.log(math.tan(rad) + 1 / math.cos(rad));
    return (1 - merc / math.pi) / 2 * _tileSize * math.pow(2, zoom);
  }

  @override
  Widget build(BuildContext context) {
    // Coordenadas decimales de cada estación
    final List<_MapPoint> points = <_MapPoint>[];
    for (final Station station in stations) {
      final double? lat = parseDms(station.latitude);
      final double? lng = parseDms(station.longitude, negative: true);
      if (lat == null || lng == null) continue;
      points.add(_MapPoint(station: station, lat: lat, lng: lng));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            if (points.isEmpty || width <= 0) {
              return Container(color: HomeStyles.infoIconBg);
            }

            // Rectángulo que contiene todas las estaciones
            double minLat = points.first.lat, maxLat = points.first.lat;
            double minLng = points.first.lng, maxLng = points.first.lng;
            for (final _MapPoint p in points) {
              minLat = math.min(minLat, p.lat);
              maxLat = math.max(maxLat, p.lat);
              minLng = math.min(minLng, p.lng);
              maxLng = math.max(maxLng, p.lng);
            }

            // Zoom más grande en el que todas las estaciones entran en el recuadro
            int zoom = 9;
            for (int z = 15; z >= 9; z--) {
              final double spanX = _lngToX(maxLng, z) - _lngToX(minLng, z);
              final double spanY = _latToY(minLat, z) - _latToY(maxLat, z);
              if (spanX <= width * 0.8 && spanY <= height * 0.75) {
                zoom = z;
                break;
              }
            }

            // Esquina superior izquierda de la vista, centrada en las estaciones
            final double centerX = (_lngToX(minLng, zoom) + _lngToX(maxLng, zoom)) / 2;
            final double centerY = (_latToY(maxLat, zoom) + _latToY(minLat, zoom)) / 2;
            final double left = centerX - width / 2;
            final double top = centerY - height / 2;

            // Mosaicos necesarios para cubrir la vista
            final int firstTileX = (left / _tileSize).floor();
            final int lastTileX = ((left + width) / _tileSize).floor();
            final int firstTileY = (top / _tileSize).floor();
            final int lastTileY = ((top + height) / _tileSize).floor();

            final List<Widget> layers = <Widget>[];
            for (int tx = firstTileX; tx <= lastTileX; tx++) {
              for (int ty = firstTileY; ty <= lastTileY; ty++) {
                layers.add(
                  Positioned(
                    left: tx * _tileSize - left,
                    top: ty * _tileSize - top,
                    width: _tileSize,
                    height: _tileSize,
                    child: Image.network(
                      'https://tile.openstreetmap.org/$zoom/$tx/$ty.png',
                      // OpenStreetMap pide identificar la aplicación
                      headers: const {'User-Agent': 'flutter_sismo/1.0 (OSNOC UDES)'},
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: HomeStyles.infoIconBg),
                    ),
                  ),
                );
              }
            }

            // Marcadores de las estaciones (la punta del pin señala la ubicación)
            const double pinSize = 32;
            for (final _MapPoint p in points) {
              final double x = _lngToX(p.lng, zoom) - left;
              final double y = _latToY(p.lat, zoom) - top;
              layers.add(
                Positioned(
                  left: x - pinSize / 2,
                  top: y - pinSize,
                  width: pinSize,
                  height: pinSize,
                  child: Tooltip(
                    message: p.station.name,
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.location_on,
                      size: pinSize,
                      color: p.station.isActive ? HomeStyles.osnocGreen : Colors.grey,
                    ),
                  ),
                ),
              );
            }

            // Atribución obligatoria de OpenStreetMap
            layers.add(
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.white.withValues(alpha: 0.8),
                  child: const Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
              ),
            );

            return Container(
              color: HomeStyles.infoIconBg,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: layers,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Estación con sus coordenadas ya convertidas a decimales
class _MapPoint {
  final Station station;
  final double lat;
  final double lng;

  const _MapPoint({
    required this.station,
    required this.lat,
    required this.lng,
  });
}
