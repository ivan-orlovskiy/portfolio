import 'dart:io';

import 'package:swipehr/src/data/models/employee_model.dart';

abstract class IEmployeeDatasource {
  Future<void> deleteAccount(String employeeId);
  Future<EmployeeModel> loadOwnAccount(String employeeId);
  Future<EmployeeModel> signIn(String email, String password);
  Future<EmployeeModel> signUp(String email, String password, File photo);
  Future<void> signOut();
}
