import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../layout/layout_scaffold.dart';
import '../../../providers/Auth/auth_provider.dart';
import '../../../providers/familiar/familiar_provider.dart';
import '../../../widgets/general/loading_dialog_widget.dart';
import '../../../widgets/profileScreen/logout_button.dart';

class ProfileFamiliarScreen extends StatelessWidget {
  const ProfileFamiliarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final familiarProvider = Provider.of<FamiliarProvider>(context);
    final familiar = familiarProvider.familiar;
    final bool isLoggedIn = authProvider.user != null;
    final bool needProfileCompletion = authProvider.needsProfileCompletion;

    return LayoutScaffold(
      useMaternalBackground: true,
      centerContent: false,
      title: "Mi perfil familiar 🧑‍🤝‍🧑",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: familiar == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                  'Inicia sesión con Google para guardar tus datos y sincronizar tu cuenta.',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const LoadingDialogWidget(
                                      mensaje:
                                          "Vinculando perfil con Google...",
                                    ),
                                  );

                                  final user =
                                      await authProvider.signInWithGoogle();

                                  if (user != null && context.mounted) {
                                    await authProvider.migrarFamiliarSiExiste(
                                      familiarProvider: familiarProvider,
                                    );

                                    Navigator.pop(context); // Cierra el diálogo

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "✅ Perfil familiar vinculado correctamente con tu cuenta de Google.",
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context); // Cierra el diálogo

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "❗ Error al iniciar sesión con Google.",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Iniciar sesión"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text("Datos del familiar",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _infoRow(Icons.person, 'Nombre', familiar.nombre),
                    const SizedBox(height: 12),
                    _infoRow(Icons.cake, 'Edad', '${familiar.edad} años'),
                    const SizedBox(height: 12),
                    _infoRow(Icons.code, 'Código vinculado',
                        familiar.codigoVinculacion ?? 'N/A'),
                    const SizedBox(height: 30),

                    Text("Conexión con materna",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aquí más adelante puedes lanzar una notificación real
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "📨 Se ha enviado un mensaje a la materna preguntando si se siente bien."),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded),
                      label: const Text(
                          "Preguntar a la materna si se siente bien"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[300],
                        foregroundColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 30),
                    const LogoutButton(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.pink[300], size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
