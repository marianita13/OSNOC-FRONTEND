import 'package:flutter/material.dart';
import '../views/stations_content_view.dart';
import '../widgets/home_footer.dart';
// Importa tu archivo de estilos centralizado, por ejemplo:
// import '../theme/station_detail_styles.dart'; 

class StationsPage extends StatelessWidget {
  const StationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estaciones Sismológicas'),
        // Usamos una constante de estilo en lugar de un color hardcodeado
        backgroundColor: const Color(0xFF0D47A1), // Reemplazar por StationDetailStyles.brandBlue o similar
      ),
      body: const StationsContentView(),
      bottomNavigationBar: const HomeFooter(),
    );
  }
}