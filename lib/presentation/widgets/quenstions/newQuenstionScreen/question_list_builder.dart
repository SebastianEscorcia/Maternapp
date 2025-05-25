import 'package:flutter/material.dart';
import '../../../providers/familiar/familiar_provider.dart';
import '../../../providers/maternal_draft_provider.dart';

//CALENDARIO
import '../../calendar/custom_table_calendar.dart';

// Widgets de preguntas
import '../dropdown_questions_card.dart';
import '../input_question_card.dart';
import '../number_picker_questions_card.dart';
import '../year_picker_question_card.dart';
import '../yes_no_questions_card.dart';

List<Widget> buildQuestions(
  MaternaDraftProvider draftProviderMaterna,
  BuildContext context,
) =>
    [
      InputQuestionCard(
        questionText: "¿Cuál es tu nombre?",
        hintText: "Escribe tu nombre",
        inputType: TextInputType.name,
        initialValue: draftProviderMaterna.draft.nombre,
        onChanged: (val) => draftProviderMaterna.updateNombre(val),
        icon: Icons.favorite_border,
        imageAsset: 'assets/images/nameicon.png',
        motivationalText:
            "¡Es un placer conocerte! Tu nombre nos ayudará a personalizar tu experiencia",
      ),
      YearPickerQuestionCard(
        questionText: "¿Cuándo naciste?",
        selectedYear: draftProviderMaterna.draft.anioNacimiento,
        onChanged: (year) => draftProviderMaterna.updateAnioNacimiento(year),
        icon: Icons.cake,
        imageAsset: 'assets/images/birthdayicon.png',
        motivationalText:
            "Tu edad es importante para brindarte el mejor cuidado",
      ),
      NumberPickerQuestionCard(
        questionText: "¿Cuál es tu peso?",
        selectedValue: draftProviderMaterna.draft.peso?.round(),
        minValue: 30,
        maxValue: 150,
        unit: "kg",
        onChanged: (val) => draftProviderMaterna.updatePeso(val.toDouble()),
        icon: Icons.monitor_weight,
        imageAsset: 'assets/images/weight_icon.png',
        motivationalText:
            "¡Cada cuerpo es único y hermoso durante el embarazo!",
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
        imageAsset: 'assets/images/height_icon.png',
        motivationalText:
            "Tu estatura nos ayuda a personalizar tu plan de cuidado",
      ),
      YesNoQuestionCard(
        questionText: "¿Estás embarazada actualmente?",
        initialValue: draftProviderMaterna.draft.embarazoActual,
        onChanged: (val) {
          if (val != null) draftProviderMaterna.updateEmbarazoActual(val);
        },
        icon: Icons.favorite,
        imageAsset: 'assets/images/pregnant_icon.png',
        motivationalText: "¡Un nuevo camino comienza para ti!",
      ),
      YesNoQuestionCard(
        questionText: "¿Es tu primer embarazo?",
        initialValue: draftProviderMaterna.draft.esPrimerEmbarazo,
        onChanged: (val) {
          if (val != null) draftProviderMaterna.updateEsPrimerEmbarazo(val);
        },
        icon: Icons.pregnant_woman,
        imageAsset: 'assets/images/first_pregnancy_icon.png',
        motivationalText: "Cada embarazo es una experiencia única y especial",
      ),
      DropdownQuestionCard(
        questionText: "¿Tu embarazo es único o múltiple?",
        options: ["Único", "Gemelar", "Trillizos o más", "no lo sé"],
        selectedValue: draftProviderMaterna.draft.tipoEmbarazo,
        onChanged: (val) => draftProviderMaterna.updateTipoEmbarazo(val ?? ""),
        icon: Icons.family_restroom,
        imageAsset: 'assets/images/multiple_pregnancy_icon.png',
        motivationalText: "¡Más bebés significan más amor para compartir!",
      ),
      YesNoQuestionCard(
        questionText: "¿Tienes antecedentes médicos relevantes?",
        initialValue: draftProviderMaterna.draft.tieneAntecedentes,
        onChanged: (val) {
          if (val != null) draftProviderMaterna.updateTieneAntecedentes(val);
        },
        imageAsset: 'assets/images/medical_icon.png',
        motivationalText: "Tu salud es nuestra prioridad para este viaje",
      ),
      const CustomTableCalendar(),
    ];
List<Widget> buildFamiliarQuestions(FamiliarProvider familiarProvider) {
  return [
    InputQuestionCard(
      questionText: "¿Cuál es tu nombre?",
      hintText: "Escribe tu nombre",
      inputType: TextInputType.name,
      initialValue: familiarProvider.familiar?.nombre ?? '',
      onChanged: (val) => familiarProvider.updateNombre(val),
      icon: Icons.person,
      imageAsset: 'assets/images/nameicon.png',
      motivationalText: "¡Bienvenido! Tu apoyo será muy valioso.",
    ),
    NumberPickerQuestionCard(
      questionText: "¿Cuál es tu edad?",
      selectedValue: familiarProvider.familiar?.edad,
      minValue: 10,
      maxValue: 100,
      unit: "años",
      onChanged: (val) => familiarProvider.updateEdad(val),
      icon: Icons.cake,
      imageAsset: 'assets/images/birthdayicon.png',
      motivationalText: "Tu edad nos ayudará a adaptar tu experiencia.",
    ),
    InputQuestionCard(
      questionText: "Código de vinculación",
      hintText: "Ej: ABC123",
      inputType: TextInputType.text,
      initialValue: familiarProvider.familiar?.codigoVinculacion ?? '',
      onChanged: (val) => familiarProvider.updateCodigoVinculacion(val),
      icon: Icons.key,
      imageAsset: 'assets/images/locked_icon.png',
      motivationalText:
          "Este código lo genera tu pareja desde su perfil en MaternApp.",
    ),
  ];
}
