import 'dart:io';

import 'package:swipehr/src/data/models/employer_model.dart';

abstract class IEmployerDatasource {
  Future<void> deleteAccount(String employerId);
  Future<List<EmployerModel>> loadCompanies();
  Future<EmployerModel> loadOwnAccount(String employerId);
  Future<EmployerModel> signIn(String email, String password);
  Future<EmployerModel> signUp(String email, String password, String companyName, File photo);
  Future<void> signOut();
}
