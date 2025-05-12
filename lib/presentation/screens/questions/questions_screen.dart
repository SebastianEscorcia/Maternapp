// Archivo: lib/widgets/question_screen/question_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../layout/layout_scaffold.dart';
import '../../providers/QuenstionsMessage/motivational_message_provider.dart';
import '../../providers/maternal_draft_provider.dart';
import '../../providers/next_or_previous_questions_provider.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_card_transition.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_finish_handler.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_footer_message.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_list_builder.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_navigation_buttons.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_progress_bar.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_step_card_decorations.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_step_indicator.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draftProviderMaterna = Provider.of<MaternaDraftProvider>(context);
    final nextOrPreviusQuestionsProvider =
        Provider.of<NextOrPreviousQuestionsProvider>(context);
    final questions = buildQuestions(draftProviderMaterna);
    final isLast = nextOrPreviusQuestionsProvider.index == questions.length - 1;

    return LayoutScaffold(
      showBack: false,
      backgroudColor: const Color(0xFFFFF9FB),
      title: "Tu Perfil Materno",
      child: Stack(
        children: [
          const QuestionStepCardDecorations(),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Indicador de pasos
                      QuestionStepIndicator(
                        index: nextOrPreviusQuestionsProvider.index,
                        total: questions.length,
                      ),

                      // Barra de progreso
                      QuestionProgressBar(
                        index: nextOrPreviusQuestionsProvider.index,
                        total: questions.length,
                      ),

                      const SizedBox(height: 20),

                      // Animación de cambio de pregunta
                      QuestionCardTransition(
                        child: KeyedSubtree(
                          key: ValueKey(nextOrPreviusQuestionsProvider.index),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child:
                                questions[nextOrPreviusQuestionsProvider.index],
                          ),
                        ),
                      ),

                      // Mensaje motivador
                      QuestionFooterMessage(
                        message: context
                            .watch<MotivationalMessageProvider>()
                            .mensajeActual,
                      ),

                      // Botones
                      QuestionNavigationButtons(
                        isFirst: nextOrPreviusQuestionsProvider.index == 0,
                        isLast: isLast,
                        onBack: nextOrPreviusQuestionsProvider.previousPage,
                        onNext: () => nextOrPreviusQuestionsProvider
                            .nextPage(questions.length),
                        onFinish: () => onFinalizar(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
