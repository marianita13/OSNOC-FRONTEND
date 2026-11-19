import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../models/user_profile.dart';
import 'package:flutter_sismo/features/auth/presentation/user_profile_store.dart';

class UserProfileController extends ChangeNotifier {
  // Índice de la pestaña "Perfil" en el NavigationBar
  static const int profileTabIndex = 4;

  final UserProfileStore _store = UserProfileStore.instance;
  final int _currentIndex = profileTabIndex;

  // Estado del modo edición
  bool _isEditing = false;
  String _documentType = UserProfileStore.documentTypes.first;
  final Set<String> _selectedRoles = {};

  // Controladores de texto para los campos del formulario
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  UserProfileController() {
    // Si otra pantalla guarda cambios en el perfil, esta se actualiza
    _store.addListener(notifyListeners);
  }

  // Getters para exponer los datos a la vista
  UserProfile get profile => _store.profile;
  String get fullName => profile.fullName;
  String get firstName => profile.firstName;
  String get lastName => profile.lastName;
  int get currentIndex => _currentIndex;
  bool get isEditing => _isEditing;

  List<String> get availableRoles => UserProfileStore.availableRoles;
  List<String> get documentTypes => UserProfileStore.documentTypes;
  String get documentType => _documentType;
  int get selectedRolesCount => _selectedRoles.length;
  bool isRoleSelected(String role) => _selectedRoles.contains(role);

  void initUserFromArgs(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _store.initFromLoginName(args);
    } else if (args is Map && args['name'] is String) {
      _store.initFromLoginName(args['name'] as String);
    }
  }

  // ---------- Edición del perfil ----------

  // Carga los datos actuales en el formulario y activa el modo edición
  void startEditing() {
    final p = profile;
    firstNameController.text = p.firstName;
    lastNameController.text = p.lastName;
    documentNumberController.text = p.documentNumber;
    emailController.text = p.email;
    phoneController.text = p.phone;
    countryController.text = p.country;
    departmentController.text = p.department;
    cityController.text = p.city;
    addressController.text = p.address;
    _documentType = documentTypes.contains(p.documentType)
        ? p.documentType
        : documentTypes.first;
    _selectedRoles
      ..clear()
      ..addAll(p.roles);
    _isEditing = true;
    notifyListeners();
  }

  // Descarta los cambios y vuelve al modo lectura
  void cancelEditing() {
    _isEditing = false;
    notifyListeners();
  }

  void changeDocumentType(String? value) {
    if (_isEditing && value != null) {
      _documentType = value;
      notifyListeners();
    }
  }

  // Marca o desmarca un rol
  void toggleRole(String role) {
    if (!_isEditing) return;
    if (!_selectedRoles.remove(role)) {
      _selectedRoles.add(role);
    }
    notifyListeners();
  }

  // Valida y guarda los cambios en el store compartido
  void saveProfile(BuildContext context) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final documentNumber = documentNumberController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    String? error;
    if (firstName.isEmpty || lastName.isEmpty) {
      error = 'Los nombres y apellidos son obligatorios';
    } else if (!RegExp(r'^\d{5,15}$').hasMatch(documentNumber)) {
      error = 'El N° de documento debe tener solo números (5 a 15 dígitos)';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      error = 'Ingresa un correo electrónico válido';
    } else if (phone.isEmpty) {
      error = 'El celular es obligatorio';
    } else if (_selectedRoles.isEmpty) {
      error = 'Selecciona al menos un rol';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    _isEditing = false;
    _store.update(
      profile.copyWith(
        firstName: firstName,
        lastName: lastName,
        documentType: _documentType,
        documentNumber: documentNumber,
        email: email,
        phone: phone,
        country: countryController.text.trim(),
        department: departmentController.text.trim(),
        city: cityController.text.trim(),
        address: addressController.text.trim(),
        // Se guardan en el mismo orden en que aparecen las opciones
        roles: availableRoles.where(_selectedRoles.contains).toList(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado correctamente')),
    );
  }

  // ---------- Navegación ----------

  // Vuelve al Home en la pestaña elegida
  void onDestinationSelected(BuildContext context, int index) {
    if (index == _currentIndex) return;
    goToHomeTab(context, index);
  }

  // - Si el perfil se abrió desde el Home (caso normal), hace pop devolviendo
  //   el índice y el HomeController cambia de pestaña.
  // - Si no hay a dónde volver, reemplaza la pila con un Home nuevo.
  void goToHomeTab(BuildContext context, int index) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(index);
    } else {
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
        arguments: {'name': fullName, 'tab': index},
      );
    }
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
    _store.reset();
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  void dispose() {
    _store.removeListener(notifyListeners);
    firstNameController.dispose();
    lastNameController.dispose();
    documentNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    departmentController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
