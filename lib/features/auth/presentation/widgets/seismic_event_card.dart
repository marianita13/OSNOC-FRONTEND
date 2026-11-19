import 'package:flutter/material.dart';
// Importa tu archivo de estilos centralizado, por ejemplo:
// import '../theme/home_styles.dart';

class SeismicEventCard extends StatelessWidget {
  const SeismicEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REPORTE DE EVENTO SÍSMICO',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 12),
          _buildBulletItem('Magnitud: 4.1'),
          _buildBulletItem('Profundidad: 141 km'),
          _buildBulletItem('Tiempo de origen: 2024-03-06'),
          _buildBulletItem('Hora Local: 04:12 pm'),
          _buildBulletItem('Localización: 6.77°, -73.20°'),
          const SizedBox(height: 8),
          const Text(
            'Municipios Cercanos:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          _buildSubBulletItem('Los Santos (Santander) a 6 km'),
          _buildSubBulletItem('Jordán (Santander) a 8 km'),
          _buildSubBulletItem('Zapatoca (Santander) a 15 km'),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('o ', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}