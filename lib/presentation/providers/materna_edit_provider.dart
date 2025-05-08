import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/maternal_model.dart';
import 'maternal_provider.dart';

class EditMaternaProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final pesoController = TextEditingController();
  final estaturaController = TextEditingController();

  void cargarDesdeMaterna(Materna materna) {
    nombreController.text = materna.nombre;
    pesoController.text = materna.peso.toString();
    estaturaController.text = materna.estatura.toString();
  }

  void guardarCambios(BuildContext context) {
    final provider = Provider.of<MaternaProvider>(context, listen: false);
    final materna = provider.materna;
    if (materna != null) {
      provider.setMaterna(Materna(
          nombre: nombreController.text,
          edad: materna.edad,
          peso: double.parse(pesoController.text),
          estatura: double.parse(estaturaController.text),
          fum: materna.fum,
          fechaEstimadaParto: materna.fechaEstimadaParto,
          semanasGestacion: materna.semanasGestacion,
          embarazoActual: materna.embarazoActual,
          esPrimerEmbarazo: materna.esPrimerEmbarazo,
          tipoEmbarazo: materna.tipoEmbarazo,
          tieneAntecedentes: materna.tieneAntecedentes,
          uid: materna.uid));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Datos actualizados")),
      );

      Navigator.pop(context);
    }
  }

  Future<void> guardarCambiosMatenaFirebase(BuildContext context) async {
    final provider = Provider.of<MaternaProvider>(context, listen: false);
    final materna = provider.materna;

    if (materna != null) {
      provider.setMaterna(Materna(
        nombre: nombreController.text,
        edad: materna.edad,
        peso: double.parse(pesoController.text),
        estatura: double.parse(estaturaController.text),
        fum: materna.fum,
        fechaEstimadaParto: materna.fechaEstimadaParto,
        semanasGestacion: materna.semanasGestacion,
        embarazoActual: materna.embarazoActual,
        esPrimerEmbarazo: materna.esPrimerEmbarazo,
        tipoEmbarazo: materna.tipoEmbarazo,
        tieneAntecedentes: materna.tieneAntecedentes,
        uid: materna.uid,
      ));

      await provider.guardarCambiosMaternaFirebase(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("DATOS ACTUALIZADOS ")),
      );

      Navigator.pop(context);
    }
  }

  void disposeControllers() {
    nombreController.dispose();
    pesoController.dispose();
    estaturaController.dispose();
  }
}
