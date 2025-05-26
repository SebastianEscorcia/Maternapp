import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/sintomas/sintoma_provider.dart';

class SintomasHoyCard extends StatelessWidget {
  final List<String> sintomasIds;
  final bool loading;

  const SintomasHoyCard({
    super.key,
    required this.sintomasIds,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SintomaProvider>();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.shade50, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade300.withAlpha(100),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Síntomas registrados hoy",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pink,),
          ),
          const SizedBox(height: 10),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (sintomasIds.isEmpty)
            const Text("No se han registrado síntomas hoy.")
          else
            Wrap(
              spacing: 8,
              children: sintomasIds.map((id) {
                final nombre = provider.nombreSintomaPorId(id);
                final color = provider.colorSintomaPorId(id);
                return Chip(
                  label: Text(nombre),
                  backgroundColor: color.withAlpha(1),
                  labelStyle: TextStyle(color: color),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
