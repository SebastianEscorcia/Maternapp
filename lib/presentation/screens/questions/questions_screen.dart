import 'package:flutter/material.dart';
import 'package:maternapp/Routes/routes.dart';
import 'package:provider/provider.dart';

// Alerts
import '../../../core/utils/alerts/alerts.dart';
//Services
import '../../../domain/services/maternal_services.dart';
import '../../../domain/services/questions_service.dart';
import '../../layout/layout_scaffold.dart';
//Providers
import '../../providers/calendar_provider.dart';
import '../../providers/maternal_draft_provider.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/next_or_previous_questions_provider.dart';

// Widgets
import '../../widgets/home/calendar/custom_table_calendar.dart';
import '../../widgets/questions_before_login_or_register/dropdown_questions_card.dart';
import '../../widgets/questions_before_login_or_register/input_question_card.dart';
import '../../widgets/questions_before_login_or_register/number_picker_questions_card.dart';
import '../../widgets/questions_before_login_or_register/year_picker_question_card.dart';
import '../../widgets/questions_before_login_or_register/yes_no_questions_card.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  List<Widget> buildQuestions(MaternaDraftProvider draftProviderMaterna) => [
        InputQuestionCard(
          questionText: "¿Cuál es tu nombre?",
          hintText: "Escribe tu nombre",
          inputType: TextInputType.name,
          initialValue: draftProviderMaterna.draft.nombre,
          onChanged: (val) => draftProviderMaterna.updateNombre(val),
          icon: Icons.person,
        ),
        YearPickerQuestionCard(
          questionText: "¿Cuándo naciste?",
          selectedYear: draftProviderMaterna.draft.anioNacimiento,
          onChanged: (year) => draftProviderMaterna.updateAnioNacimiento(year),
          icon: Icons.cake,
        ),
        NumberPickerQuestionCard(
          questionText: "¿Cuál es tu peso?",
          selectedValue: draftProviderMaterna.draft.peso?.round(),
          minValue: 30,
          maxValue: 150,
          unit: "kg",
          onChanged: (val) => draftProviderMaterna.updatePeso(val.toDouble()),
          icon: Icons.monitor_weight,
        ),
        NumberPickerQuestionCard(
          questionText: "¿Cuál es tu estatura?",
          selectedValue: draftProviderMaterna.draft.estatura != null
              ? (draftProviderMaterna.draft.estatura! * 100).round()
              : null,
          minValue: 120,
          maxValue: 200,
          unit: "cm",
          onChanged: (val) => draftProviderMaterna.updateEstatura(val / 100),
          icon: Icons.height,
        ),
        YesNoQuestionCard(
          questionText: "¿Estás embarazada actualmente?",
          initialValue: draftProviderMaterna.draft.embarazoActual,
          onChanged: (val) {
            if (val != null) draftProviderMaterna.updateEmbarazoActual(val);
          },
          icon: Icons.favorite,
        ),
        YesNoQuestionCard(
          questionText: "¿Es tu primer embarazo?",
          initialValue: draftProviderMaterna.draft.esPrimerEmbarazo,
          onChanged: (val) {
            if (val != null) draftProviderMaterna.updateEsPrimerEmbarazo(val);
          },
          icon: Icons.pregnant_woman,
        ),
        DropdownQuestionCard(
          questionText: "¿Tu embarazo es único o múltiple?",
          options: ["Único", "Gemelar", "Trillizos o más"],
          selectedValue: draftProviderMaterna.draft.tipoEmbarazo,
          onChanged: (val) =>
              draftProviderMaterna.updateTipoEmbarazo(val ?? ""),
          icon: Icons.family_restroom, // 👨‍👩‍👧
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
    final draftProvider =
        Provider.of<MaternaDraftProvider>(context, listen: false);
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final maternaProvider =
        Provider.of<MaternaProvider>(context, listen: false);

    final service = QuestionService(
      draftProvider: draftProvider,
      calendarProvider: calendarProvider,
      maternaService: MaternalService(),
      maternaProvider: maternaProvider,
    );

    final error = service.validarFormulario();
    if (error != null) {
      mostrarAlerta(context, error);
      return;
    }

    try {
      service.procesarFormulario();
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

    return LayoutScaffold(
      showBack: false,
      child: Column(
        children: [
          Expanded(
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(nextOrPreviusQuestionsProvider.index),
              child: questions[nextOrPreviusQuestionsProvider.index],
            ),
          )),
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
          ),
        ],
      ),
    );
  }
}
