import 'package:flutter/material.dart';
import '../controllers/user_profile_controller.dart';
import '../theme/user_profile_styles.dart';
import '../widgets/user_profile_widgets.dart';
import '../widgets/user_profile_footer.dart';
import '../widgets/responsive.dart';

class UserProfileContentView extends StatefulWidget {
  const UserProfileContentView({super.key});

  @override
  State<UserProfileContentView> createState() => _UserProfileContentViewState();
}

class _UserProfileContentViewState extends State<UserProfileContentView> {
  // Controlador gestionado de forma interna y autónoma
  late final UserProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserProfileController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lee el nombre enviado en los argumentos de la ruta
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
        final profile = _controller.profile;
        final editing = _controller.isEditing;

        return SingleChildScrollView(
          padding: Responsive.pagePadding(context, maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado de Perfil y Foto
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 110,
                          height: 140,
                          decoration: BoxDecoration(
                            color: UserProfileStyles.osnocBlue,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: UserProfileStyles.osnocBlue.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: UserProfileStyles.osnocLightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.fullName,
                      textAlign: TextAlign.center,
                      style: UserProfileStyles.headerNameStyle,
                    ),
                    Text(
                      profile.email,
                      style: UserProfileStyles.headerEmailStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tarjeta 1: Información Personal
              SectionCard(
                title: "Información Personal",
                icon: Icons.person_outline,
                headerColor: UserProfileStyles.osnocBlue,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: editing
                            ? EditableField(label: "Nombres", controller: _controller.firstNameController)
                            : ReadonlyField(label: "Nombres", value: profile.firstName),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: editing
                            ? EditableField(label: "Apellidos", controller: _controller.lastNameController)
                            : ReadonlyField(label: "Apellidos", value: profile.lastName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: editing
                            ? DropdownField(
                                label: "Tipo de documento",
                                value: _controller.documentType,
                                options: _controller.documentTypes,
                                onChanged: _controller.changeDocumentType,
                              )
                            : ReadonlyField(label: "Tipo de documento", value: profile.documentType),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: editing
                            ? EditableField(
                                label: "N° documento",
                                controller: _controller.documentNumberController,
                                keyboardType: TextInputType.number,
                              )
                            : ReadonlyField(label: "N° documento", value: profile.documentNumber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  editing
                      ? EditableField(
                          label: "Email / Correo electrónico",
                          controller: _controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                        )
                      : ReadonlyField(label: "Email / Correo electrónico", value: profile.email),
                  const SizedBox(height: 12),
                  editing
                      ? EditableField(
                          label: "Celular",
                          controller: _controller.phoneController,
                          keyboardType: TextInputType.phone,
                        )
                      : ReadonlyField(label: "Celular", value: profile.phone),
                ],
              ),
              const SizedBox(height: 16),

              // Tarjeta 2: Roles Asignados
              SectionCard(
                title: "Rol(es) Asignados",
                icon: Icons.verified_user_outlined,
                headerColor: UserProfileStyles.osnocBlue,
                children: editing ? _buildRoleSelector() : _buildAssignedRoles(profile.roles),
              ),
              const SizedBox(height: 16),

              // Tarjeta 3: Ubicación
              SectionCard(
                title: "Ubicación",
                icon: Icons.location_on_outlined,
                headerColor: UserProfileStyles.osnocBlue,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final country = editing
                          ? EditableField(label: "País", controller: _controller.countryController)
                          : ReadonlyField(label: "País", value: profile.country);
                      final department = editing
                          ? EditableField(label: "Departamento", controller: _controller.departmentController)
                          : ReadonlyField(label: "Departamento", value: profile.department);
                      final city = editing
                          ? EditableField(label: "Ciudad", controller: _controller.cityController)
                          : ReadonlyField(label: "Ciudad", value: profile.city);

                      // En edición los campos necesitan más ancho, se apilan antes
                      final bool isNarrow = constraints.maxWidth < (editing ? 420 : 340);
                      if (isNarrow) {
                        return Column(
                          children: [
                            country,
                            const SizedBox(height: 8),
                            department,
                            const SizedBox(height: 8),
                            city,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: country),
                          const SizedBox(width: 6),
                          Expanded(flex: 4, child: department),
                          const SizedBox(width: 6),
                          Expanded(flex: 5, child: city),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  editing
                      ? EditableField(label: "Dirección", controller: _controller.addressController)
                      : ReadonlyField(label: "Dirección", value: profile.address),
                ],
              ),
              const SizedBox(height: 16),

              // Tarjeta 4: Estado de la Cuenta
              SectionCard(
                title: "Estado de la cuenta",
                icon: Icons.settings_outlined,
                headerColor: UserProfileStyles.osnocBlue,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Cambiar contraseña",
                        style: TextStyle(fontSize: 13, color: UserProfileStyles.darkText),
                      ),
                      Checkbox(
                        value: false,
                        onChanged: (v) {},
                        activeColor: UserProfileStyles.osnocLightBlue,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Estado del Usuario",
                        style: TextStyle(fontSize: 13, color: UserProfileStyles.darkText),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: UserProfileStyles.osnocBgBlue,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: UserProfileStyles.osnocLightBlue.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 12,
                              color: UserProfileStyles.osnocLightBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              profile.isActive ? "Activo" : "Inactivo",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: UserProfileStyles.osnocBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botones: Editar Perfil  /  Cancelar + Guardar Cambios
              if (!editing)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _controller.startEditing,
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    label: const Text("EDITAR PERFIL", style: UserProfileStyles.editButtonStyle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UserProfileStyles.osnocBlue,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _controller.cancelEditing,
                          icon: const Icon(Icons.close, size: 18, color: UserProfileStyles.mutedText),
                          label: const Text(
                            "CANCELAR",
                            style: TextStyle(
                              color: UserProfileStyles.mutedText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: UserProfileStyles.borderSide),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => _controller.saveProfile(context),
                          icon: const Icon(Icons.save, size: 18, color: Colors.white),
                          label: const Text("GUARDAR", style: UserProfileStyles.editButtonStyle),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UserProfileStyles.brandGreen,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 36),

              // Pie de Página
              const UserProfileFooter(),
            ],
          ),
        );
      },
    );
  }

  // Modo lectura: solo los roles asignados
  List<Widget> _buildAssignedRoles(List<String> roles) {
    if (roles.isEmpty) {
      return const [
        Text(
          "Sin roles asignados",
          style: TextStyle(fontSize: 12, color: UserProfileStyles.mutedText),
        ),
      ];
    }
    return [
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: roles.map((role) => RoleChip(label: role)).toList(),
      ),
    ];
  }

  // Modo edición: todas las opciones, se tocan para marcarlas o desmarcarlas
  List<Widget> _buildRoleSelector() {
    return [
      Text(
        "Toca los roles que tendrá el usuario "
        "(${_controller.selectedRolesCount} de ${_controller.availableRoles.length} seleccionados)",
        style: const TextStyle(fontSize: 11, color: UserProfileStyles.mutedText),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: _controller.availableRoles
            .map((role) => SelectableRoleChip(
                  label: role,
                  selected: _controller.isRoleSelected(role),
                  onTap: () => _controller.toggleRole(role),
                ))
            .toList(),
      ),
    ];
  }
}
