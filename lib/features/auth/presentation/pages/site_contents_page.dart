import 'package:flutter/material.dart';
import '../theme/site_contents_styles.dart';
import '../views/site_contents_content_view.dart';
import '../../../../config/routes.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/responsive.dart';

class SiteContentsPage extends StatelessWidget {
  const SiteContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // En computador no hay barra azul: el menú lateral ya permite moverse.
      // En el celular se mantiene porque tiene la flecha para volver.
      appBar: Responsive.isWide(context)
          ? null
          : AppBar(
        title: const Text('Contenidos Sitio'),
        backgroundColor: SiteContentsStyles.appBarBg,
        foregroundColor: Colors.white,
      ),
      // Sin bottomNavigationBar: HomeFooter() se estiraba a toda la pantalla
      // y dejaba el body en 0 px. El footer ya lo pinta la vista al final de la lista.
      // En computador lleva el menú lateral a la izquierda (en el celular, igual que antes)
      body: AppSideMenu.wrapPage(
        context,
        currentRoute: AppRoutes.siteContents,
        child: const SafeArea(
          child: SiteContentsContentView(),
        ),
      ),
    );
  }
}
