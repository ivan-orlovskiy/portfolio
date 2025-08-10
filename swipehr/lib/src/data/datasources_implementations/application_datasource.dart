import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipehr/src/core/exceptions/common/network_exception.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_application_datasource.dart';
import 'package:swipehr/src/data/models/application_model.dart';
import 'package:uuid/uuid.dart';

class ApplicationDatasource implements IApplicationDatasource {
  final SupabaseClient database;
  final InternetConnectionChecker connectionChecker;

  ApplicationDatasource({
    required this.database,
    required this.connectionChecker,
  });

  @override
  Future<void> createApplication(ApplicationModel newApplicationModel, File file) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Save file
    final fileName = const Uuid().v4();
    await database.storage.from('files').upload(
          fileName,
          file,
        );

    final map = newApplicationModel.toMap();
    map['pdf_path'] = fileName;

    // Create application
    await database.from('application').insert(map);
  }

  @override
  Future<void> deleteApplication(String applicationId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Delete application
    await database.from('application').delete().eq('id', applicationId);
  }

  @override
  Future<List<ApplicationModel>> loadApplicationsForAVacancy(String vacancyId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get applications from base
    final maps = await database
        .from('application')
        .select<List<Map<String, dynamic>>>()
        .eq('vacancy_id', vacancyId);

    return maps.map((e) => ApplicationModel.fromMap(e)).toList();
  }

  @override
  Future<ApplicationModel> loadOwnApplication(String employeeId, String vacancyId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get application from base
    final map = await database
        .from('application')
        .select<Map<String, dynamic>>()
        .eq('employee_id', employeeId)
        .eq('vacancy_id', vacancyId)
        .single();

    return ApplicationModel.fromMap(map);
  }
}
