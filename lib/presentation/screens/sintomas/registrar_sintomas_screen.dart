import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/sintomas/sintoma_provider.dart';
import '../../layout/layout_scaffold.dart';
import 'package:flutter/services.dart';

class SeleccionarSintomasScreen extends StatelessWidget {
  const SeleccionarSintomasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SintomaProvider>();
    final materna = context.read<MaternaProvider>().materna;

    if (materna != null &&
        (provider.catalogo.isEmpty || provider.registroHoy == null)) {
      Future.microtask(() => provider.inicializarDatosSiNecesario(materna.uid));
    }

    if (provider.catalogo.isEmpty || provider.isLoading || materna == null) {
      return const LayoutScaffold(
        useMaternalBackground: true,
        showBack: true,
        centerContent: true,
        child: CircularProgressIndicator(),
      );
    }

    final sintomasSeleccionados = Set<String>.from(
      provider.registroHoy?.sintomasIds ?? [],
    );

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
                children:
                    provider.sintomasPorCategoria.entries.map((categoria) {
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
                              bool isSelected =
                                  sintomasSeleccionados.contains(sintoma.id);

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
                                  final nuevoSet = {...sintomasSeleccionados};
                                  final fueSeleccionado = !isSelected;

                                  if (isSelected) {
                                    nuevoSet.remove(sintoma.id);
                                    HapticFeedback
                                        .mediumImpact(); // ❌ Eliminado
                                  } else {
                                    nuevoSet.add(sintoma.id);
                                    HapticFeedback
                                        .lightImpact(); // ✅ Registrado
                                  }

                                  await provider.actualizarSintomasDeHoy(
                                    materna.uid,
                                    nuevoSet.toList(),
                                  );
                                  // Actualiza el estado
                                  provider.limpiarCacheHistorial();

                                  if (context.mounted) {
                                    final snackBar = SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            fueSeleccionado
                                                ? Icons.check_circle_outline
                                                : Icons.cancel_outlined,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              fueSeleccionado
                                                  ? "Síntoma registrado con éxito"
                                                  : "Síntoma eliminado",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: fueSeleccionado
                                          ? Colors.green
                                          : Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      duration: const Duration(seconds: 2),
                                      elevation: 6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
            if (provider.guardandoSeleccion)
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Colors.white,
                    color: Colors.pink,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
