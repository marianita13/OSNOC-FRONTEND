import 'package:flutter/material.dart';
import '../controllers/user_profile_controller.dart';
import '../theme/home_styles.dart';
import '../views/user_profile_content_view.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/responsive.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final UserProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserProfileController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.initUserFromArgs(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black87),
            // Celular: abre el menú ☰ · Computador: despliega / pliega el menú lateral
            leading: Responsive.isWide(context)
                ? const IconButton(
                    icon: Icon(Icons.menu, color: Colors.black87),
                    tooltip: 'Mostrar / ocultar menú',
                    onPressed: AppSideMenu.toggle,
                  )
                : Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black87),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_osnoc.png',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.hub_outlined, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  "OSNOC",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _controller.fullName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Drawer Lateral sin estilos centralizados
          // El menú ☰ deslizable solo existe en el celular
          drawer: Responsive.isWide(context)
              ? null
              : Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF2D3748)),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF2D3748)),
                  ),
                  accountName: Text(
                    _controller.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  accountEmail: const Text('Observatorio Sismológico'),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.view_quilt_outlined, color: Color(0xFF475569)),
                        title: const Text('Contenidos sitio'),
                        onTap: () => _controller.navigateToSiteContents(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.search, color: Color(0xFF475569)),
                        title: const Text('Log eventos'),
                        onTap: () => _controller.navigateToEventLogs(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.newspaper_outlined, color: Color(0xFF475569)),
                        title: const Text('Noticias'),
                        onTap: () => _controller.navigateToNews(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.share_outlined, color: Color(0xFF475569)),
                        title: const Text('Redes Sociales'),
                        onTap: () => _controller.navigateToSocialNetworks(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.bar_chart_outlined, color: Color(0xFF475569)),
                        title: const Text('Reportes Sísmicos'),
                        onTap: () => _controller.navigateToSeismicReports(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _controller.logout(context),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Cuerpo con Contenido de Perfil
          // En tablet / computador va con el menú lateral a la izquierda
          body: Responsive.isWide(context)
              ? Row(
                  children: [
                    AppSideMenu(
                      selectedIndex: _controller.currentIndex,
                      onTabSelected: (index) =>
                          _controller.onDestinationSelected(context, index),
                      onLogout: () => _controller.logout(context),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    const Expanded(child: UserProfileContentView()),
                  ],
                )
              : const SafeArea(
                  child: UserProfileContentView(),
                ),

          // Bottom Navigation Bar (mismo estilo que el del HomePage)
          bottomNavigationBar: Responsive.isWide(context)
              ? null
              : NavigationBar(
            selectedIndex: _controller.currentIndex,
            onDestinationSelected: (index) =>
                _controller.onDestinationSelected(context, index),
            indicatorColor: HomeStyles.osnocGreen.withValues(alpha: 0.2),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: HomeStyles.osnocGreen),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.cell_tower_outlined),
                selectedIcon: Icon(Icons.cell_tower, color: HomeStyles.osnocGreen),
                label: 'Estaciones',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder_open_outlined),
                selectedIcon: Icon(Icons.folder_open, color: HomeStyles.osnocGreen),
                label: 'Proyectos',
              ),
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article, color: HomeStyles.osnocGreen),
                label: 'Publicaciones',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: HomeStyles.osnocGreen),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}