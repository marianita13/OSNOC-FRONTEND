import 'package:flutter/material.dart';
import '../theme/publications_styles.dart';
import '../views/publications_content_view.dart';
import '../widgets/home_footer.dart';

class PublicationsPage extends StatelessWidget {
  const PublicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        backgroundColor: PublicationsStyles.appBarBg,
      ),
      body: const PublicationsContentView(),
      bottomNavigationBar: const HomeFooter(),
    );
  }
}

