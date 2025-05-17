import 'package:flutter/material.dart';

import '../../layout/layout_scaffold.dart';


class SelectWearDeviceScreen extends StatelessWidget {
  const SelectWearDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dispositivos = [
      {"name": "Reloj Wear OS 1", "id": "node-abc"},
      {"name": "Galaxy Watch", "id": "node-xyz"},
    ];

    return LayoutScaffold(
      useMaternalBackground: true,
      showBack: true,
      title: "Dispositivos Wear OS",
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: dispositivos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final dispositivo = dispositivos[index];
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.pink.shade50, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            shadowColor: Colors.pink.withAlpha(50),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.watch, color: Colors.pink),
              title: Text(
                dispositivo["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("ID: ${dispositivo["id"]}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                enviarMensajeAlWear(dispositivo["id"]!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.pink,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content:
                        Text("📤 Mensaje enviado a ${dispositivo["name"]}"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void enviarMensajeAlWear(String nodeId) {
    // TODO: implementa esto con MethodChannel hacia Android
    // Ejemplo:
    // MethodChannel('wear_channel').invokeMethod('sendMessageToWear', {
    //   "nodeId": nodeId,
    //   "message": "HR_START"
    // });
  }
}
