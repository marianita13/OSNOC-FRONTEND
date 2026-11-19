import 'package:flutter/material.dart';
import '../theme/projects_styles.dart';
import '../views/projects_content_view.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Proyectos'),
        backgroundColor: ProjectsStyles.appBarBg,
        foregroundColor: Colors.white,
      ),
      // Igual que Contenidos Sitio: el footer lo pinta la vista al final de la lista.
      body: const SafeArea(
        child: ProjectsContentView(),
      ),
    );
  }
}
