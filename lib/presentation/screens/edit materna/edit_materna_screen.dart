import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/materna_edit_provider.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/navigation_navbar_provider.dart';
import '../../widgets/home/navbar/botton_navbar.dart';
import '../../layout/layout_scaffold.dart';

class EditMaternaScreen extends StatelessWidget {
  const EditMaternaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editProvider = Provider.of<EditMaternaProvider>(context);
    final navProvider = Provider.of<NavigationNavbarProvider>(context);
    final maternaProvider = Provider.of<MaternaProvider>(context);

    if (maternaProvider.materna == null) {
      return  Scaffold(
        appBar: AppBar(title: Text("Editar datos 👩‍⚕️")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return LayoutScaffold(
      title: "Editar datos 👩‍⚕️",
      showBack: true,
      useMaternalBackground: true,
      bottomNav: BottonNavbar(
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          if (navProvider.currentIndex != index) {
            navProvider.setIndex(index);
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: Colors.white.withAlpha(235),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: editProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Actualiza tu información personal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Nombre
                    TextFormField(
                      controller: editProvider.nombreController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 16),

                    // Peso
                    TextFormField(
                      controller: editProvider.pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        prefixIcon: const Icon(Icons.monitor_weight_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          double.tryParse(value ?? '') == null
                              ? 'Número inválido'
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // Estatura
                    TextFormField(
                      controller: editProvider.estaturaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Estatura (m)",
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          double.tryParse(value ?? '') == null
                              ? 'Número inválido'
                              : null,
                    ),
                    const SizedBox(height: 30),

                    // Botón guardar
                    ElevatedButton.icon(
                      onPressed: () {
                        if (editProvider.formKey.currentState!.validate()) {
                          editProvider.guardarCambiosMatenaFirebase(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.save_alt),
                      label: const Text(
                        "Guardar cambios",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
