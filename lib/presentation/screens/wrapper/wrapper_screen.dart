import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../../Routes/routes.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, Routes.welcomeScreen);
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
