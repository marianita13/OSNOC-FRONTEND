import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import 'package:flutter_sismo/features/auth/presentation/user_profile_store.dart';

class HomeController extends ChangeNotifier {
  // Índice de la pestaña "Perfil" en el NavigationBar
  static const int profileTabIndex = 4;

  int currentIndex = 0;
  bool _argsApplied = false;
  bool _disposed = false;

  // El nombre sale del perfil compartido, así se actualiza al editarlo
  String get userName => UserProfileStore.instance.profile.fullName;

  void initArguments(Object? args) {
    // didChangeDependencies se llama varias veces (al apilar/volver rutas);
    // los argumentos solo se aplican la primera vez para no pisar la pestaña actual.
    if (_argsApplied) return;
    _argsApplied = true;
    if (args is String && args.trim().isNotEmpty) {
      UserProfileStore.instance.initFromLoginName(args);
    } else if (args is Map) {
      // Argumentos enviados desde el Perfil: {'name': ..., 'tab': ...}
      final name = args['name'];
      final tab = args['tab'];
      if (name is String) UserProfileStore.instance.initFromLoginName(name);
      if (tab is int && tab >= 0 && tab < profileTabIndex) currentIndex = tab;
    }
  }

  void changeTab(int index, BuildContext context) {
    if (index == profileTabIndex) {
      // Si presiona Perfil en el BottomBar, abre la pantalla de perfil
      navigateToProfile(context);
    } else {
      currentIndex = index;
      notifyListeners();
    }
  }

  // Abre el perfil y, al volver, cambia a la pestaña que el usuario
  // eligió en el NavigationBar del perfil.
  Future<void> navigateToProfile(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.profile,
      arguments: userName,
    );
    // Si se cerró sesión desde el perfil, este controller ya fue liberado
    if (_disposed) return;
    if (result is int && result >= 0 && result < profileTabIndex) {
      currentIndex = result;
    }
    // Refresca siempre: el nombre pudo cambiar en el perfil
    notifyListeners();
  }

  void navigateToSiteContents(BuildContext context) {
    Navigator.pop(context); // Cierra el menú lateral
    Navigator.pushNamed(context, AppRoutes.siteContents);
  }

  void navigateToNews(BuildContext context) {
    Navigator.pop(context); // Cierra el menú lateral
    Navigator.pushNamed(context, AppRoutes.news);
  }

  void navigateToSeismicReports(BuildContext context) {
    Navigator.pop(context); // Cierra el menú lateral
    Navigator.pushNamed(context, AppRoutes.seismicReports);
  }

  void navigateToEventLogs(BuildContext context) {
    Navigator.pop(context); // Cierra el menú lateral
    Navigator.pushNamed(context, AppRoutes.eventLogs);
  }

  void navigateToSocialNetworks(BuildContext context) {
    Navigator.pop(context); // Cierra el menú lateral
    Navigator.pushNamed(context, AppRoutes.socialNetworks);
  }

  void logout(BuildContext context) {
    UserProfileStore.instance.reset();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
