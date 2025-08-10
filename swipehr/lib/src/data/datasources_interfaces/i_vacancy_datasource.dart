import 'package:swipehr/src/data/models/vacancy_model.dart';

abstract class IVacancyDatasource {
  Future<void> createVacancy(VacancyModel newVacancyModel);
  Future<void> deleteVacancy(String vacancyId);
  Future<List<VacancyModel>> loadOwnVacancies(String employerId);
}
