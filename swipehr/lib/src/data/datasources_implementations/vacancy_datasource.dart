import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipehr/src/core/exceptions/common/network_exception.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_vacancy_datasource.dart';
import 'package:swipehr/src/data/models/vacancy_model.dart';

class VacancyDatasource implements IVacancyDatasource {
  final SupabaseClient database;
  final InternetConnectionChecker connectionChecker;

  VacancyDatasource({
    required this.database,
    required this.connectionChecker,
  });

  @override
  Future<void> createVacancy(VacancyModel newVacancyModel) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Create vacancy
    await database.from('vacancy').insert(newVacancyModel.toMap());
  }

  @override
  Future<void> deleteVacancy(String vacancyId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Delete vacancy
    await database.from('vacancy').delete().eq('id', vacancyId);
  }

  @override
  Future<List<VacancyModel>> loadOwnVacancies(String employerId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get vacancies from base
    final maps = await database
        .from('vacancy')
        .select<List<Map<String, dynamic>>>()
        .eq('employer_id', employerId);

    return maps.map((e) => VacancyModel.fromMap(e)).toList();
  }
}
