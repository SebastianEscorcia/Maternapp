import 'package:maternapp/data/models/calendar_model.dart';
import 'package:maternapp/data/models/drafts/maternal_draft.dart';
import 'package:maternapp/data/models/maternal_model.dart';
import 'package:maternapp/domain/services/maternal_services.dart';

class MaternalController {
  final MaternalService maternalService;

  MaternalController({required this.maternalService});

  Materna crear({required MaternaDraft draft, required CalendarModel calendario,}) 
  {
    return maternalService.construirMaterna(draft, calendario);
  }
}