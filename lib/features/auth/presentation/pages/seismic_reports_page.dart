import 'package:flutter/material.dart';
import '../theme/seismic_reports_styles.dart';
import '../views/seismic_reports_content_view.dart';
import '../../../../config/routes.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/responsive.dart';

class SeismicReportsPage extends StatelessWidget {
  const SeismicReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // En computador no hay barra azul: el menú lateral ya permite moverse.
      // En el celular se mantiene porque tiene la flecha para volver.
      appBar: Responsive.isWide(context)
          ? null
          : AppBar(
        title: const Text('Reportes Sísmicos'),
        backgroundColor: SeismicReportsStyles.appBarBg,
        foregroundColor: Colors.white,
      ),
      // Igual que Contenidos Sitio: el footer lo pinta la vista al final de la lista.
      // En computador lleva el menú lateral a la izquierda (en el celular, igual que antes)
      body: AppSideMenu.wrapPage(
        context,
        currentRoute: AppRoutes.seismicReports,
        child: const SafeArea(
          child: SeismicReportsContentView(),
        ),
      ),
    );
  }
}
