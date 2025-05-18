import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/sintoma.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/sintomas/sintoma_provider.dart';
import '../../layout/layout_scaffold.dart';

class SeleccionarSintomasScreen extends StatelessWidget {
  const SeleccionarSintomasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sintomasPorCategoria =
        context.watch<SintomaProvider>().sintomasVisualesPorCategoria;

    final provider = Provider.of<SintomaProvider>(context);
    final materna = Provider.of<MaternaProvider>(context).materna;

    final selected = provider.sintomas.map((s) => s.descripcion).toSet();

    return LayoutScaffold(
      title: "Seleccionar síntomas",
      useMaternalBackground: true,
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Cómo te sientes hoy?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: sintomasPorCategoria.entries.map((categoria) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoria.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categoria.value.map((sintoma) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              final isSelected =
                                  selected.contains(sintoma.nombre);
                              return ChoiceChip(
                                label: Text(sintoma.nombre),
                                avatar: Icon(
                                  sintoma.icono,
                                  color:
                                      isSelected ? Colors.white : sintoma.color,
                                ),
                                selected: isSelected,
                                selectedColor: sintoma.color,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : sintoma.color,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? sintoma.color
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                onSelected: (_) async {
                                  setState(() {
                                    if (isSelected) {
                                      selected.remove(sintoma.nombre);
                                    } else {
                                      selected.add(sintoma.nombre);
                                    }
                                  });

                                  if (materna != null) {
                                    if (isSelected) {
                                      await provider
                                          .eliminarSintomaPorDescripcion(
                                        uid: materna.uid,
                                        descripcion: sintoma.nombre,
                                      );
                                    } else {
                                      final nuevo = Sintoma(
                                        id: '',
                                        descripcion: sintoma.nombre,
                                        fecha: DateTime.now(),
                                        maternaUid: materna.uid,
                                      );
                                      await provider.registrarSintoma(nuevo);
                                    }
                                  }
                                },
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
