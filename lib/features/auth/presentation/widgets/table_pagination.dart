import 'package:flutter/material.dart';
import '../theme/publications_styles.dart';

// Paginación reutilizable: botón anterior, números de página y botón siguiente
class TablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        _buildCircleButton(
          child: const Icon(Icons.chevron_left, size: 18),
          enabled: currentPage > 1,
          onTap: onPrevious,
        ),
        for (int page = 1; page <= totalPages; page++)
          _buildCircleButton(
            child: Text('$page'),
            selected: page == currentPage,
            onTap: () => onPageSelected(page),
          ),
        _buildCircleButton(
          child: const Icon(Icons.chevron_right, size: 18),
          enabled: currentPage < totalPages,
          onTap: onNext,
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required Widget child,
    required VoidCallback onTap,
    bool selected = false,
    bool enabled = true,
  }) {
    final Color foreground = selected
        ? Colors.white
        : enabled
            ? PublicationsStyles.subtextColor
            : PublicationsStyles.pageDisabledText;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected
              ? PublicationsStyles.pageActiveBg
              : PublicationsStyles.pageInactiveBg,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: foreground),
            child: DefaultTextStyle(
              style: TextStyle(
                color: foreground,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

