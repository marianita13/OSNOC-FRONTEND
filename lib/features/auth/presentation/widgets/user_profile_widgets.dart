import 'package:flutter/material.dart';
import '../theme/user_profile_styles.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color headerColor;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.headerColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: UserProfileStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: headerColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: headerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class ReadonlyField extends StatelessWidget {
  final String label;
  final String value;

  const ReadonlyField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserProfileStyles.labelStyle),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: UserProfileStyles.scaffoldBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: UserProfileStyles.borderSide),
          ),
          child: Text(
            value,
            style: UserProfileStyles.valueStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class RoleChip extends StatelessWidget {
  final String label;

  const RoleChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: UserProfileStyles.osnocBgBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UserProfileStyles.chipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 12, color: UserProfileStyles.osnocLightBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: UserProfileStyles.roleChipTextStyle,
          ),
        ],
      ),
    );
  }
}

// Decoración común de los campos editables del perfil
InputDecoration _profileInputDecoration() {
  OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    border: border(UserProfileStyles.borderSide),
    enabledBorder: border(UserProfileStyles.borderSide),
    focusedBorder: border(UserProfileStyles.osnocLightBlue, 1.5),
  );
}

// Versión editable de ReadonlyField (misma etiqueta y tamaños)
class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserProfileStyles.labelStyle),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: UserProfileStyles.valueStyle,
          decoration: _profileInputDecoration(),
        ),
      ],
    );
  }
}

// Selector desplegable con el mismo aspecto de EditableField
class DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserProfileStyles.labelStyle),
        const SizedBox(height: 4),
        InputDecorator(
          decoration: _profileInputDecoration().copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: UserProfileStyles.valueStyle,
              items: options
                  .map((o) => DropdownMenuItem<String>(
                        value: o,
                        child: Text(o, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// Chip de rol que se puede marcar / desmarcar (modo edición)
class SelectableRoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableRoleChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? UserProfileStyles.osnocBgBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? UserProfileStyles.osnocLightBlue : UserProfileStyles.borderSide,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 14,
              color: selected ? UserProfileStyles.osnocLightBlue : UserProfileStyles.mutedText,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: UserProfileStyles.roleChipTextStyle.copyWith(
                color: selected ? UserProfileStyles.chipText : UserProfileStyles.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
