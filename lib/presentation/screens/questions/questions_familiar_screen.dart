import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../layout/layout_scaffold.dart';
import '../../providers/familiar/familiar_provider.dart';
import '../../providers/next_or_previous_questions_provider.dart';
import '../../widgets/quenstions/familiar/question_familiar_finish_handler.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_card_transition.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_footer_message.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_list_builder.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_navigation_buttons.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_progress_bar.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_step_card_decorations.dart';
import '../../widgets/quenstions/newQuenstionScreen/question_step_indicator.dart';


class QuestionFamiliarScreen extends StatelessWidget {
  const QuestionFamiliarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familiarProvider = context.watch<FamiliarProvider>();
    final nav = context.watch<NextOrPreviousQuestionsProvider>();
    final questions = buildFamiliarQuestions(familiarProvider);
    final isLast = nav.index == questions.length - 1;

    return LayoutScaffold(
      showBack: true,
      useMaternalBackground: true,
      centerContent: true,
      title: "Tu Perfil Familiar",
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
                      QuestionStepIndicator(index: nav.index, total: questions.length),
                      QuestionProgressBar(index: nav.index, total: questions.length),
                      const SizedBox(height: 20),
                      QuestionCardTransition(
                        child: KeyedSubtree(
                          key: ValueKey(nav.index),
                          child: questions[nav.index],
                        ),
                      ),
                      const QuestionFooterMessage(
                        message: "Gracias por acompañar a tu ser querido 💕",
                      ),
                      QuestionNavigationButtons(
                        isFirst: nav.index == 0,
                        isLast: isLast,
                        onBack: nav.previousPage,
                        onNext: () => nav.nextPage(questions.length),
                        onFinish: () => onFinalizarFamiliar(context),
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
