import 'dart:io';

import 'package:swipehr/src/data/models/application_model.dart';

abstract class IApplicationDatasource {
  Future<void> createApplication(ApplicationModel newApplicationModel, File file);
  Future<void> deleteApplication(String applicationId);
  Future<List<ApplicationModel>> loadApplicationsForAVacancy(String vacancyId);
  Future<ApplicationModel> loadOwnApplication(String employeeId, String vacancyId);
}
