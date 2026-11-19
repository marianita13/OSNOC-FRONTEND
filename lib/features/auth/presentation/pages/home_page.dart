import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../theme/home_styles.dart';
import '../views/home_content_view.dart';
import '../views/stations_content_view.dart';
import '../views/projects_content_view.dart'; // Importación de la vista de Proyectos
import '../views/publications_content_view.dart';
import '../views/user_profile_content_view.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    // Pestaña pedida desde el menú lateral de una página de administración
    AppSideMenu.pendingTab.addListener(_onPendingTab);
  }

  void _onPendingTab() {
    final int? tab = AppSideMenu.pendingTab.value;
    if (tab == null) return;
    AppSideMenu.pendingTab.value = null;
    // Se espera a que termine de cerrarse la página de administración
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.changeTab(tab, context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _controller.initArguments(args);
  }

  @override
  void dispose() {
    AppSideMenu.pendingTab.removeListener(_onPendingTab);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final List<Widget> pages = [
          const HomeContentView(),        // 0: Inicio
          const StationsContentView(),    // 1: Estaciones
          const ProjectsContentView(),    // 2: Proyectos (Agregado para alinear los 5 tabs)
          const PublicationsContentView(),// 3: Publicaciones
          const UserProfileContentView(), // 4: Perfil
        ];

        // Tablet / computador: un solo menú lateral con todas las páginas
        // (sin barra inferior ni menú ☰ aparte)
        final bool wide = Responsive.isWide(context);

        return Scaffold(
          backgroundColor: HomeStyles.scaffoldBg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black87),
            // En computador el botón ☰ despliega / pliega el menú lateral
            leading: wide
                ? const IconButton(
                    icon: Icon(Icons.menu),
                    tooltip: 'Mostrar / ocultar menú',
                    onPressed: AppSideMenu.toggle,
                  )
                : null,
            title: const Row(
              children: [
                Icon(Icons.hub_outlined, color: HomeStyles.osnocGreen),
                SizedBox(width: 8),
                Text(
                  "OSNOC",
                  style: TextStyle(
                    color: HomeStyles.osnocGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => _controller.navigateToProfile(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _controller.userName,
                          style: HomeStyles.headerUserStyle, // Usando la constante centralizada
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // El menú ☰ deslizable solo existe en el celular
          drawer: wide
              ? null
              : Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: HomeStyles.osnocHeaderBg,
                  ),
                  accountName: Text(
                    _controller.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  accountEmail: const Text("Observatorio Sismológico"),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: HomeStyles.osnocHeaderBg,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.web_outlined),
                  title: const Text('Contenidos sitio'),
                  onTap: () => _controller.navigateToSiteContents(context),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Log eventos'),
                  onTap: () => _controller.navigateToEventLogs(context),
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text('Noticias'),
                  onTap: () => _controller.navigateToNews(context),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Redes Sociales'),
                  onTap: () => _controller.navigateToSocialNetworks(context),
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Reportes Sísmicos'),
                  onTap: () => _controller.navigateToSeismicReports(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () => _controller.logout(context),
                ),
              ],
            ),
          ),

          body: wide
              ? Row(
                  children: [
                    AppSideMenu(
                      selectedIndex: _controller.currentIndex,
                      onTabSelected: (index) =>
                          _controller.changeTab(index, context),
                      onLogout: () => _controller.logout(context),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: pages[_controller.currentIndex]),
                  ],
                )
              : pages[_controller.currentIndex],

          bottomNavigationBar: wide
              ? null
              : NavigationBar(
            selectedIndex: _controller.currentIndex,
            onDestinationSelected: (index) =>
                _controller.changeTab(index, context),
            indicatorColor: HomeStyles.osnocGreen.withValues(alpha: 0.2),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: HomeStyles.osnocGreen),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.cell_tower_outlined),
                selectedIcon: Icon(
                  Icons.cell_tower,
                  color: HomeStyles.osnocGreen,
                ),
                label: 'Estaciones',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder_open_outlined),
                selectedIcon: Icon(
                  Icons.folder_open,
                  color: HomeStyles.osnocGreen,
                ),
                label: 'Proyectos',
              ),
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(
                  Icons.article,
                  color: HomeStyles.osnocGreen,
                ),
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
