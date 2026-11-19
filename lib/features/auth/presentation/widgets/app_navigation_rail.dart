import 'package:flutter/material.dart';
import '../theme/home_styles.dart';
import 'responsive.dart';

/// Menú de navegación lateral para pantallas anchas (tablet y computador).
/// Reemplaza a la barra inferior (NavigationBar) del celular, con las
/// mismas 5 opciones: Inicio, Estaciones, Proyectos, Publicaciones y Perfil.
/// En computador se muestra extendido (ícono + texto al lado).
class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool extended = Responsive.isDesktop(context);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      minExtendedWidth: 210,
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      backgroundColor: Colors.white,
      indicatorColor: HomeStyles.osnocGreen.withValues(alpha: 0.2),
      selectedIconTheme: const IconThemeData(color: HomeStyles.osnocGreen),
      selectedLabelTextStyle: const TextStyle(
        color: HomeStyles.osnocGreen,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 13,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Inicio'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.cell_tower_outlined),
          selectedIcon: Icon(Icons.cell_tower),
          label: Text('Estaciones'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder_open_outlined),
          selectedIcon: Icon(Icons.folder_open),
          label: Text('Proyectos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.article_outlined),
          selectedIcon: Icon(Icons.article),
          label: Text('Publicaciones'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Perfil'),
        ),
      ],
    );
  }
}
