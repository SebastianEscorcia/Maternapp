import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/QuenstionsMessage/motivational_message_provider.dart';

class QuestionNavigationButtons extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const QuestionNavigationButtons({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.onBack,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isFirst)
            ElevatedButton.icon(
              onPressed: () {
                context.read<MotivationalMessageProvider>().actualizarMensaje();
                onBack();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text("Anterior"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF4B8A),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    color: Color(0xFFFFD6E5),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            )
          else
            const SizedBox(width: 50), // espacio reservado

          ElevatedButton.icon(
            onPressed: () {
              context.read<MotivationalMessageProvider>().actualizarMensaje();
              isLast ? onFinish() : onNext();
            },
            icon: Icon(
              isLast ? Icons.check : Icons.arrow_forward_ios,
              size: 16,
            ),
            label: Text(isLast ? "Finalizar" : "Siguiente"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B8A),
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
