import 'package:flutter/material.dart';
import '../theme/social_networks_styles.dart';
import '../views/social_networks_content_view.dart';
import '../../../../config/routes.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/responsive.dart';

class SocialNetworksPage extends StatelessWidget {
  const SocialNetworksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // En computador no hay barra azul: el menú lateral ya permite moverse.
      // En el celular se mantiene porque tiene la flecha para volver.
      appBar: Responsive.isWide(context)
          ? null
          : AppBar(
        title: const Text('Redes Sociales'),
        backgroundColor: SocialNetworksStyles.appBarBg,
        foregroundColor: Colors.white,
      ),
      // Igual que Contenidos Sitio: el footer lo pinta la vista al final de la lista.
      // En computador lleva el menú lateral a la izquierda (en el celular, igual que antes)
      body: AppSideMenu.wrapPage(
        context,
        currentRoute: AppRoutes.socialNetworks,
        child: const SafeArea(
          child: SocialNetworksContentView(),
        ),
      ),
    );
  }
}
