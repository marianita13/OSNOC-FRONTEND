import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../theme/home_styles.dart';
import '../user_profile_store.dart';
import 'responsive.dart';

/// Menú lateral ÚNICO para tablet y computador (en el celular no se usa).
/// Tiene todas las páginas con el mismo estilo: Inicio, Estaciones,
/// Proyectos, Publicaciones, Perfil, Contenidos sitio, Log eventos,
/// Noticias, Redes Sociales, Reportes Sísmicos y Cerrar sesión.
///
/// Se muestra en el Inicio, en el Perfil y también dentro de las páginas
/// de administración (Contenidos, Log, Noticias, Redes, Reportes).
/// El botón ☰ del AppBar lo despliega / pliega ([AppSideMenu.toggle]).
class AppSideMenu extends StatelessWidget {
  /// Estado desplegado / plegado, compartido entre pantallas.
  static final ValueNotifier<bool> expanded = ValueNotifier<bool>(true);

  /// Despliega o pliega el menú
  static void toggle() => expanded.value = !expanded.value;

  /// Pestaña pedida desde una página de administración: el HomePage la
  /// escucha, vuelve a primer plano y abre esa pestaña.
  static final ValueNotifier<int?> pendingTab = ValueNotifier<int?>(null);

  /// Pestaña marcada (0 Inicio … 4 Perfil). null = ninguna.
  final int? selectedIndex;

  /// Página de administración marcada (ej. AppRoutes.news). null = ninguna.
  final String? currentRoute;

  /// Qué hacer al tocar una pestaña. Si es null (páginas de administración),
  /// se vuelve al Inicio y se abre esa pestaña.
  final ValueChanged<int>? onTabSelected;

  /// Qué hacer al cerrar sesión. Si es null, limpia la sesión y va al login.
  final VoidCallback? onLogout;

  const AppSideMenu({
    super.key,
    this.selectedIndex,
    this.currentRoute,
    this.onTabSelected,
    this.onLogout,
  });

  static const double expandedWidth = 240;
  static const double collapsedWidth = 72;

  /// Envuelve el contenido de una página de administración:
  /// en tablet / computador le pone el menú a la izquierda; en el celular
  /// devuelve el contenido tal cual.
  static Widget wrapPage(
    BuildContext context, {
    required String currentRoute,
    required Widget child,
  }) {
    if (!Responsive.isWide(context)) return child;
    return Row(
      children: [
        AppSideMenu(currentRoute: currentRoute),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: child),
      ],
    );
  }

  // ---------- Navegación ----------

  void _selectTab(BuildContext context, int index) {
    final ValueChanged<int>? handler = onTabSelected;
    if (handler != null) {
      handler(index);
      return;
    }
    // Desde una página de administración: volver al Inicio y abrir la pestaña
    pendingTab.value = index;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _openPage(BuildContext context, String route) {
    if (route == currentRoute) return; // ya estás en esa página
    if (currentRoute != null) {
      // De una página de administración a otra: se reemplaza (no se apilan)
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  void _logout(BuildContext context) {
    final VoidCallback? handler = onLogout;
    if (handler != null) {
      handler();
      return;
    }
    UserProfileStore.instance.reset();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expanded,
      builder: (context, isExpanded, _) {
        return Container(
          width: isExpanded ? expandedWidth : collapsedWidth,
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _item(context, isExpanded,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Inicio',
                  selected: selectedIndex == 0,
                  onTap: () => _selectTab(context, 0)),
              _item(context, isExpanded,
                  icon: Icons.cell_tower_outlined,
                  selectedIcon: Icons.cell_tower,
                  label: 'Estaciones',
                  selected: selectedIndex == 1,
                  onTap: () => _selectTab(context, 1)),
              _item(context, isExpanded,
                  icon: Icons.folder_open_outlined,
                  selectedIcon: Icons.folder_open,
                  label: 'Proyectos',
                  selected: selectedIndex == 2,
                  onTap: () => _selectTab(context, 2)),
              _item(context, isExpanded,
                  icon: Icons.article_outlined,
                  selectedIcon: Icons.article,
                  label: 'Publicaciones',
                  selected: selectedIndex == 3,
                  onTap: () => _selectTab(context, 3)),
              _item(context, isExpanded,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Perfil',
                  selected: selectedIndex == 4,
                  onTap: () => _selectTab(context, 4)),
              _item(context, isExpanded,
                  icon: Icons.web_outlined,
                  selectedIcon: Icons.web,
                  label: 'Contenidos sitio',
                  selected: currentRoute == AppRoutes.siteContents,
                  onTap: () => _openPage(context, AppRoutes.siteContents)),
              _item(context, isExpanded,
                  icon: Icons.manage_search,
                  label: 'Log eventos',
                  selected: currentRoute == AppRoutes.eventLogs,
                  onTap: () => _openPage(context, AppRoutes.eventLogs)),
              _item(context, isExpanded,
                  icon: Icons.newspaper_outlined,
                  selectedIcon: Icons.newspaper,
                  label: 'Noticias',
                  selected: currentRoute == AppRoutes.news,
                  onTap: () => _openPage(context, AppRoutes.news)),
              _item(context, isExpanded,
                  icon: Icons.share_outlined,
                  selectedIcon: Icons.share,
                  label: 'Redes Sociales',
                  selected: currentRoute == AppRoutes.socialNetworks,
                  onTap: () => _openPage(context, AppRoutes.socialNetworks)),
              _item(context, isExpanded,
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart,
                  label: 'Reportes Sísmicos',
                  selected: currentRoute == AppRoutes.seismicReports,
                  onTap: () => _openPage(context, AppRoutes.seismicReports)),
              _item(context, isExpanded,
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  onTap: () => _logout(context)),
            ],
          ),
        );
      },
    );
  }

  // Opción del menú, todas con el mismo estilo:
  // - seleccionada: ícono dentro del óvalo verde y nombre en verde
  // - sin seleccionar: ícono oscuro y nombre en gris
  Widget _item(
    BuildContext context,
    bool isExpanded, {
    required IconData icon,
    IconData? selectedIcon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    final Color iconColor = selected ? HomeStyles.osnocGreen : Colors.black87;
    final Color labelColor = selected ? HomeStyles.osnocGreen : Colors.black54;

    final Widget pill = Container(
      width: 56,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? HomeStyles.osnocGreen.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        selected && selectedIcon != null ? selectedIcon : icon,
        color: iconColor,
        size: 24,
      ),
    );

    final Widget content = isExpanded
        ? Row(
            children: [
              pill,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: labelColor,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          )
        : Center(child: pill);

    final Widget tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        padding: EdgeInsets.only(left: isExpanded ? 8 : 0),
        child: content,
      ),
    );

    // Plegado: el nombre aparece al pasar el mouse por encima
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: isExpanded ? tile : Tooltip(message: label, child: tile),
    );
  }
}
