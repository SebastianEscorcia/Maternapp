import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layout/layout_scaffold.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/navigation_navbar_provider.dart';
import '../../widgets/profileScreen/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = authProvider.user != null;
    final bool needProfileCompletion = authProvider.needsProfileCompletion;

    return LayoutScaffold(
      title: "Mi perfil 👤",
      centerContent: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔐 Alerta si no ha iniciado sesión
            if (!isLoggedIn || needProfileCompletion)
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
                      onPressed: () async {
                        final user = await authProvider.signInWithGoogle();

                        if (user != null && context.mounted) {
                          final maternaProvider = Provider.of<MaternaProvider>(
                              context,
                              listen: false);
                          final prefs = await SharedPreferences.getInstance();
                          final uid = user.uid;

                          // Intentar cargar una materna existente con el UID de Google
                          await maternaProvider.cargarMaternaFirebase(uid);

                          if (maternaProvider.materna != null) {
                            print("✅ Materna ya vinculada a Google, cargada.");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("✅ Sesión iniciada correctamente")),
                            );
                          } else {
                            print(
                                "ℹ️ No se encontró una materna con el UID de Google. Intentamos migrar.");

                            final uidTemporal =
                                prefs.getString('maternaTemporalUid');

                            if (uidTemporal != null && uidTemporal.isNotEmpty) {
                              await maternaProvider
                                  .cargarMaternaFirebase(uidTemporal);

                              if (maternaProvider.materna != null) {
                                final nuevaMaterna =
                                    maternaProvider.materna!.copyWith(uid: uid);
                                await FirebaseFirestore.instance
                                    .collection('maternas')
                                    .doc(uid)
                                    .set(nuevaMaterna.toJson());

                                // ✅ Eliminar la materna temporal y limpiar preferencias
                                await FirebaseFirestore.instance
                                    .collection('maternas')
                                    .doc(uidTemporal)
                                    .delete();
                                await prefs.remove('maternaTemporalUid');

                                maternaProvider.setMaterna(nuevaMaterna);

                                print(
                                    "✅ Materna migrada del UID temporal al de Google.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "🔄 Perfil vinculado con éxito.")),
                                );
                              } else {
                                print(
                                    "❌ No se pudo cargar la materna temporal.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "❗ No se encontró perfil previo para migrar.")),
                                );
                              }
                            } else {
                              print("❌ No había UID temporal guardado.");
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
                  //Navigator.pushNamed(context, '/vitals');
                  //SOLUCIÓN PARA IR A SIGNOS VITALES
                  final navProvider = Provider.of<NavigationNavbarProvider>(
                      context,
                      listen: false);
                  navProvider.setIndex(4); //  "Signos" es el índice 4
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  //Provider.of<NavigationNavbarProvider>(context,listen: false).irAPestania(context, 4);
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
            
            const LogoutButton(),
          ],
          
        ),
      ),
    );
  }
}
