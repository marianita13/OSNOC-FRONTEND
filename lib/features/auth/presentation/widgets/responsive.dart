import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Utilidades para que la app se vea bien en celular, tablet y computador.
///
/// - Celular  (< 700 px):  todo igual que antes.
/// - Tablet   (700–1099):  márgenes más amplios, listas en 2 columnas.
/// - Escritorio (≥ 1100):  contenido centrado con ancho máximo, listas en 3 columnas.
class Responsive {
  static const double tabletBreakpoint = 700;
  static const double desktopBreakpoint = 1100;

  // Ancho máximo del contenido de las páginas de listas y del inicio
  static const double contentMaxWidth = 1200;
  // Ancho máximo de los formularios (detalle, perfil)
  static const double formMaxWidth = 820;

  static double widthOf(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isWide(BuildContext context) => widthOf(context) >= tabletBreakpoint;
  static bool isDesktop(BuildContext context) => widthOf(context) >= desktopBreakpoint;

  /// Padding para un SingleChildScrollView: en pantallas grandes agrega
  /// margen lateral para centrar el contenido con un ancho máximo.
  /// La barra de scroll queda en el borde de la ventana, como en la web.
  static EdgeInsets pagePadding(
    BuildContext context, {
    double maxWidth = contentMaxWidth,
    double mobile = 16,
  }) {
    final double width = widthOf(context);
    final double base = width >= desktopBreakpoint
        ? 32
        : width >= tabletBreakpoint
            ? 24
            : mobile;
    final double centered = (width - maxWidth) / 2;
    final double horizontal = math.max(base, centered);
    return EdgeInsets.fromLTRB(horizontal, base, horizontal, base);
  }

  /// Solo margen lateral (para pantallas que ya manejan su espacio vertical)
  static EdgeInsets horizontalPadding(
    BuildContext context, {
    required double maxWidth,
    double mobile = 16,
  }) {
    final double width = widthOf(context);
    return EdgeInsets.symmetric(horizontal: math.max(mobile, (width - maxWidth) / 2));
  }

  /// Cantidad de columnas para una cuadrícula según el ancho disponible
  static int columnsFor(double width) {
    if (width >= 1000) return 3;
    if (width >= 640) return 2;
    return 1;
  }
}

/// Reemplazo de ListView.builder(shrinkWrap: true) que, en pantallas
/// anchas, acomoda las tarjetas en 2 o 3 columnas. En celular es una
/// lista normal de una columna.
class ResponsiveGridList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;

  // Se aceptan para poder reemplazar ListView.builder sin cambiar nada más
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 12,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = Responsive.columnsFor(constraints.maxWidth);
        final List<Widget> items = List<Widget>.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        );

        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          );
        }

        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          children: items
              .map((item) => SizedBox(width: itemWidth, child: item))
              .toList(),
        );
      },
    );
  }
}
