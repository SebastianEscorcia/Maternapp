import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/materna_edit_provider.dart';
import '../../providers/navigation_navbar_provider.dart';
import '../../widgets/home/navbar/botton_navbar.dart';

class EditMaternaScreen extends StatelessWidget {
  const EditMaternaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editProvider = Provider.of<EditMaternaProvider>(context);
    final navProvider = Provider.of<NavigationNavbarProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Editar datos 👩‍⚕️")),
      bottomNavigationBar: BottonNavbar(
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          // SI ESTAMOS EN LA MISMA SCREEN NO SE REDIBUJA EVITA NAVEGACIÓN INNESESARIA 
          if (navProvider.currentIndex != index) {
            navProvider.setIndex(index);
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: editProvider.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: editProvider.nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: editProvider.pesoController,
                decoration: const InputDecoration(labelText: "Peso (kg)"),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Número inválido'
                    : null,
              ),
              TextFormField(
                controller: editProvider.estaturaController,
                decoration: const InputDecoration(labelText: "Estatura (m)"),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Número inválido'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (editProvider.formKey.currentState!.validate()) {
                    editProvider.guardarCambiosMatenaFirebase(context);
                  }
                },
                child: const Text("Guardar cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
