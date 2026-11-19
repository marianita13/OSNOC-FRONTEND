import 'package:flutter/foundation.dart';
import 'models/user_profile.dart';

/// Almacén en memoria del perfil del usuario en sesión.
/// Es compartido por todas las pantallas, así los cambios guardados en el
/// Perfil se mantienen al navegar y se ven en el AppBar / Drawer del Home.
class UserProfileStore extends ChangeNotifier {
  UserProfileStore._();
  static final UserProfileStore instance = UserProfileStore._();

  // Roles que se pueden asignar al usuario
  static const List<String> availableRoles = [
    'Geo-divulgador',
    'Gestor de contenido sitio',
    'Gestor de estaciones sísmicas',
    'Gestor de redes sociales',
    'Log de eventos',
    'Publicador de noticias',
    'Publicador de proyectos',
    'Publicador reportes sísmicos',
  ];

  // Tipos de documento disponibles
  static const List<String> documentTypes = [
    'Cédula de Ciudadanía',
    'Cédula de Extranjería',
    'Tarjeta de Identidad',
    'Pasaporte',
  ];

  static const UserProfile _defaultProfile = UserProfile(
    firstName: '111',
    lastName: '',
    documentType: 'Cédula de Ciudadanía',
    documentNumber: '1098071703',
    email: 'marianitacero.1913@gmail.com',
    phone: '315-6757083',
    country: 'COLOMBIA',
    department: 'Santander',
    city: 'BUCARAMANGA',
    address: 'Direccion XYZ',
    roles: availableRoles,
    isActive: true,
  );

  UserProfile _profile = _defaultProfile;
  bool _initialized = false;

  UserProfile get profile => _profile;

  /// Toma el nombre que llega desde el Login la primera vez.
  /// No notifica: se llama desde didChangeDependencies y las vistas
  /// leen el valor en su siguiente build.
  void initFromLoginName(String name) {
    if (_initialized || name.trim().isEmpty) return;
    _initialized = true;
    final parts = name.trim().split(RegExp(r'\s+'));
    _profile = _profile.copyWith(
      firstName: parts.first,
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
  }

  /// Guarda los cambios hechos en el Perfil
  void update(UserProfile profile) {
    _profile = profile;
    _initialized = true;
    notifyListeners();
  }

  /// Limpia la sesión al cerrar sesión
  void reset() {
    _profile = _defaultProfile;
    _initialized = false;
    notifyListeners();
  }
}
