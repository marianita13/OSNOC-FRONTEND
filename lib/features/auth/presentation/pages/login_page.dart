import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../theme/login_styles.dart';
import '../views/login_content_view.dart';
import '../widgets/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginStyles.scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: Responsive.horizontalPadding(context, maxWidth: 460, mobile: 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: LoginContentView(controller: _controller),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}