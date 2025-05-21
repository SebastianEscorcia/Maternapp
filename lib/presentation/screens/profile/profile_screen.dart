import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layout/layout_scaffold.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/navigation_navbar_provider.dart';
import '../../widgets/historial_sintomas/historial_sintomas_button.dart';
import '../../widgets/profileScreen/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = authProvider.user != null;
    final bool needProfileCompletion = authProvider.needsProfileCompletion;

    return LayoutScaffold(
      useMaternalBackground: true,
      centerContent: false,
      title: "Mi perfil 🧍‍♀️",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔐 Alerta si no ha iniciado sesión
              if (!isLoggedIn || needProfileCompletion)
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.pink.shade50,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.red.withAlpha(50),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.red),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Registrarse con google para guardar tus datos',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final user = await authProvider.signInWithGoogle();
                            if (user != null && context.mounted) {
                              final maternaProvider =
                                  Provider.of<MaternaProvider>(context,
                                      listen: false);
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final uid = user.uid;

                              await maternaProvider.cargarMaternaFirebase(uid);

                              if (maternaProvider.materna != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("✅ Sesión iniciada correctamente"),
                                  ),
                                );
                              } else {
                                final uidTemporal =
                                    prefs.getString('maternaTemporalUid');

                                if (uidTemporal != null &&
                                    uidTemporal.isNotEmpty) {
                                  await maternaProvider
                                      .cargarMaternaFirebase(uidTemporal);

                                  if (maternaProvider.materna != null) {
                                    final nuevaMaterna = maternaProvider
                                        .materna!
                                        .copyWith(uid: uid);

                                    await FirebaseFirestore.instance
                                        .collection('maternas')
                                        .doc(uid)
                                        .set(nuevaMaterna.toJson());

                                    await FirebaseFirestore.instance
                                        .collection('maternas')
                                        .doc(uidTemporal)
                                        .delete();
                                    await prefs.remove('maternaTemporalUid');

                                    maternaProvider.setMaterna(nuevaMaterna);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "🔄 Perfil vinculado con éxito.")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "❗ No se encontró perfil previo para migrar.")),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "❗ No se encontró perfil previo para migrar.")),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text("Iniciar sesión"),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              Text("Editar perfil",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              // 🧍‍♀️ Mis datos
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.pink.shade50,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.pink),
                  title: const Text("Mis datos"),
                  subtitle: const Text("Editar peso, estatura, nombre..."),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(context, '/editMaterna');
                  },
                ),
              ),

              const SizedBox(height: 30),

              // ❤️ Vincular familiar
              Text("Vincular con familiar",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: flujo de vinculación
                },
                icon: const Icon(Icons.group_add),
                label: const Text("Vincular cuenta de pareja"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 📈 Signos vitales
              Text("Salud en tiempo real",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.teal.shade50,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.monitor_heart, color: Colors.teal),
                  title: const Text("Monitorear signos vitales"),
                  subtitle: const Text(
                      "Frecuencia cardíaca, oxigenación, temperatura"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final navProvider = Provider.of<NavigationNavbarProvider>(
                        context,
                        listen: false);
                    navProvider.setIndex(4);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 🎯 Objetivo
              Text("Mi objetivo",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: const Text("Controlar embarazo"),
                    selected: true,
                    selectedColor: Colors.pink[200],
                  ),
                  ChoiceChip(
                    label: const Text("Conectar con especialista"),
                    selected: false,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Historial de síntomas",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              const HistorialSintomasButton(),
              const SizedBox(height: 40),

              // 🔓 Logout
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
