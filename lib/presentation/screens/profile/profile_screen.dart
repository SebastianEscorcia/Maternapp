import 'package:flutter/material.dart';

import '../../layout/layout_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = false; // Aquí validarás si hay sesión

    return LayoutScaffold(
      title: "Mi perfil 👤",
      centerContent: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔐 Alerta si no ha iniciado sesión
            if (!isLoggedIn)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Regístrate o inicia sesión para guardar tus datos en la nube.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Abrir flujo Firebase Login
                      },
                      child: const Text("Iniciar sesión"),
                    ),
                  ],
                ),
              ),
      
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.pink),
              title: const Text("Mis datos"),
              subtitle: const Text("Editar peso, estatura, nombre..."),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editMaterna');
              },
            ),

            const SizedBox(height: 20),

            /// ❤️ Vincular pareja o familiar
            Text("Vincular con familiar",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Abrir flujo para generar código de vinculación o QR
              },
              icon: const Icon(Icons.group_add),
              label: const Text("Vincular cuenta de pareja"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            /// 📈 Signos vitales y alertas
            Text("Salud en tiempo real",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.teal[50],
              child: ListTile(
                leading: const Icon(Icons.monitor_heart, color: Colors.teal),
                title: const Text("Monitorear signos vitales"),
                subtitle:
                    const Text("Frecuencia cardíaca, oxigenación, temperatura"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/vitals');
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 🎯 Objetivo (opcional)
            Text("Mi objetivo", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                    label: const Text("Controlar embarazo"), selected: true),
                ChoiceChip(
                    label: const Text("Conectar con especialista"),
                    selected: false),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
