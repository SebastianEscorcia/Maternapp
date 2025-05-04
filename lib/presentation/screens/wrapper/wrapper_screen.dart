import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../../Routes/routes.dart';
import '../../providers/maternal_provider.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, MaternaProvider>(
        builder: (context, authProvider, maternaProvider, child) {
          final user = authProvider.user;
          final materna = maternaProvider.materna;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (user != null) {
              if (materna == null) {
                // Si hay usuario pero no materna, cargarla
                maternaProvider.cargarMaternaFirebase(user.uid).then((_) {
                  final updatedMaterna = maternaProvider.materna;
                  if (updatedMaterna != null) {
                    Navigator.pushReplacementNamed(context, Routes.homeScreen);
                  } else {
                    Navigator.pushReplacementNamed(
                        context, Routes.welcomeScreen);
                  }
                });
              } else {
                Navigator.pushReplacementNamed(context, Routes.homeScreen);
              }
            } else {
              Navigator.pushReplacementNamed(context, Routes.welcomeScreen);
            }
          });

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
