import 'package:flutter/material.dart';
import 'package:maternapp/Routes/routes.dart';
import 'package:maternapp/core/providers/next_or_previous_questions_provider.dart';
import 'package:maternapp/core/providers/maternal_draft_provider.dart';
import 'package:maternapp/core/providers/maternal_provider.dart';
import 'package:maternapp/domain/controllers/calendar_controller.dart';
import 'package:maternapp/domain/controllers/maternal_controller.dart';
import 'package:maternapp/domain/controllers/questions_controller.dart';
import 'package:maternapp/domain/services/maternal_services.dart';
import 'package:maternapp/domain/services/questions_services.dart';
import 'package:maternapp/presentation/screens/home/widgets/calendar/custom_table_calendar.dart';
import 'package:maternapp/presentation/screens/questions/widgets/questions_before_login_or_register/dropdown_questions_card.dart';
import 'package:maternapp/presentation/screens/questions/widgets/questions_before_login_or_register/input_question_card.dart';
import 'package:maternapp/presentation/screens/questions/widgets/questions_before_login_or_register/yes_no_questions_card.dart';
import 'package:maternapp/core/utils/alerts/alerts.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  List<Widget> buildQuestions(MaternaDraftProvider draftProviderMaterna) => [
        InputQuestionCard(
          questionText: "¿Cuál es tu nombre?",
          hintText: "Escribe tu nombre",
          inputType: TextInputType.name,
          initialValue: draftProviderMaterna.draft.nombre,
          onChanged: (val) => draftProviderMaterna.updateNombre(val),
        ),
        InputQuestionCard(
          questionText: "¿Cuál es tu edad?",
          hintText: "Ej: 26",
          inputType: TextInputType.number,
          initialValue: draftProviderMaterna.draft.edad?.toString(),
          onChanged: (val) =>
              draftProviderMaterna.updateEdad(int.tryParse(val) ?? 0),
        ),
        InputQuestionCard(
          questionText: "¿Cuál es tu peso en kg?",
          hintText: "Ej: 70",
          inputType: TextInputType.number,
          initialValue: draftProviderMaterna.draft.peso?.toString(),
          onChanged: (val) =>
              draftProviderMaterna.updatePeso(double.tryParse(val) ?? 0),
        ),
        InputQuestionCard(
          questionText: "¿Cuál es tu estatura en metros?",
          hintText: "Ej: 1.60",
          inputType: TextInputType.number,
          initialValue: draftProviderMaterna.draft.estatura?.toString(),
          onChanged: (val) =>
              draftProviderMaterna.updateEstatura(double.tryParse(val) ?? 0),
        ),
        YesNoQuestionCard(
          questionText: "¿Estás embarazada actualmente?",
          initialValue: draftProviderMaterna.draft.embarazoActual,
          onChanged: (val) {
            if (val != null) draftProviderMaterna.updateEmbarazoActual(val);
          },
        ),
        YesNoQuestionCard(
          questionText: "¿Es tu primer embarazo?",
          initialValue: draftProviderMaterna.draft.esPrimerEmbarazo,
          onChanged: (val) {
            if (val != null) draftProviderMaterna.updateEsPrimerEmbarazo(val);
          },
        ),
        DropdownQuestionCard(
          questionText: "¿Tu embarazo es único o múltiple?",
          options: ["Único", "Gemelar", "Trillizos o más"],
          selectedValue: draftProviderMaterna.draft.tipoEmbarazo,
          onChanged: (val) =>
              draftProviderMaterna.updateTipoEmbarazo(val ?? ""),
        ),
        YesNoQuestionCard(
          questionText: "¿Tienes antecedentes médicos relevantes?",
          initialValue: draftProviderMaterna.draft.tieneAntecedentes,
          onChanged: (val) {
            if (val != null) draftProviderMaterna.updateTieneAntecedentes(val);
          },
        ),
        const CustomTableCalendar(),
      ];

  void onFinalizar(BuildContext context) {
    final preguntaController = PreguntaController(
      draftProvider: Provider.of<MaternaDraftProvider>(context, listen: false),
      calendarController: Provider.of<CalendarController>(context, listen: false),
      preguntaService: QuestionsServices(),
      maternaService: MaternalService(),
      maternaController: MaternalController(maternalService: MaternalService()),
      maternaProvider: Provider.of<MaternaProvider>(context, listen: false),
    );
    final error = preguntaController.validarFormulario();
    if (error != null) {
      mostrarAlerta(context, error);
      return;
    }

    try {
      preguntaController.procesarFormulario();
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftProviderMaterna = Provider.of<MaternaDraftProvider>(context);
    final nextOrPreviusQuestionsProvider =
        Provider.of<NextOrPreviousQuestionsProvider>(context);
    final questions = buildQuestions(draftProviderMaterna);
    final isLast = nextOrPreviusQuestionsProvider.index == questions.length - 1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(nextOrPreviusQuestionsProvider.index),
                  child: questions[nextOrPreviusQuestionsProvider.index],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (nextOrPreviusQuestionsProvider.index > 0)
                  ElevatedButton(
                    onPressed: nextOrPreviusQuestionsProvider.previousPage,
                    child: const Text("Anterior"),
                  ),
                ElevatedButton(
                  onPressed: isLast
                      ? () => onFinalizar(context)
                      : () => nextOrPreviusQuestionsProvider
                          .nextPage(questions.length),
                  child: Text(isLast ? "Finalizar" : "Siguiente"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
