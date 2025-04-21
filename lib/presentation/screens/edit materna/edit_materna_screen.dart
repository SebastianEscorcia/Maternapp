import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../layout/layout_scaffold.dart';
import '../../providers/materna_edit_provider.dart';

class EditMaternaScreen extends StatelessWidget {
  const EditMaternaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editProvider = Provider.of<EditMaternaProvider>(context);

    return LayoutScaffold(
      title: "Editar datos 👩‍⚕️",
      centerContent: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: editProvider.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: editProvider.nombreController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: editProvider.pesoController,
                  decoration: const InputDecoration(labelText: "Peso (kg)"),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value ?? '') == null ? 'Número inválido' : null,
                ),
                TextFormField(
                  controller: editProvider.estaturaController,
                  decoration: const InputDecoration(labelText: "Estatura (m)"),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value ?? '') == null ? 'Número inválido' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (editProvider.formKey.currentState!.validate()) {
                      editProvider.guardarCambios(context);
                    }
                  },
                  child: const Text("Guardar cambios"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
