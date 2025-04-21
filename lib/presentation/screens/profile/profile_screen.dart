import 'package:flutter/material.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "Mi perfil 👤",
      centerContent: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Desde aquí podrás consultar o modificar tu información personal.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          // Aquí puedes mostrar la info de la materna y editarla
        ],
      ),
    );
  }
}
  