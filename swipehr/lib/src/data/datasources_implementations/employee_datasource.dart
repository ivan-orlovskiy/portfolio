import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipehr/src/core/exceptions/common/network_exception.dart';
import 'package:swipehr/src/core/keys/user_storage.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employee_datasource.dart';
import 'package:swipehr/src/data/models/employee_model.dart';

class EmployeeDatasource implements IEmployeeDatasource {
  final SupabaseClient database;
  final InternetConnectionChecker connectionChecker;
  final SharedPreferences preferences;

  EmployeeDatasource({
    required this.database,
    required this.connectionChecker,
    required this.preferences,
  });

  @override
  Future<void> deleteAccount(String employeeId) async {
    // To be implemented
    throw UnimplementedError();
  }

  @override
  Future<EmployeeModel> loadOwnAccount(String employeeId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get user from base
    final map = await database
        .from('employee')
        .select<Map<String, dynamic>>()
        .eq('id', employeeId)
        .single();

    return EmployeeModel.fromMap(map);
  }

  @override
  Future<EmployeeModel> signIn(String email, String password) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Sign up the user
    await database.auth.signInWithPassword(email: email, password: password);

    // Get user id and email
    final userId = database.auth.currentUser!.id;

    // Save to prefereces
    await preferences.setString(UserStorage.userId, userId);
    await preferences.setString(UserStorage.userEmail, email);

    // Convert to map and change id
    final model = EmployeeModel(
      id: userId,
      email: email,
      photoPath: 'photoPath',
      subscriptionExpirationDateTime: DateTime.now(),
    );

    return model;
  }

  @override
  Future<void> signOut() async {
    await preferences.remove(UserStorage.userId);
    await preferences.remove(UserStorage.userEmail);
    await database.auth.signOut();
  }

  @override
  Future<EmployeeModel> signUp(String email, String password, File photo) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Sign up the user
    await database.auth.signUp(email: email, password: password);

    // Get user id and email
    final userId = database.auth.currentUser!.id;

    // Save to prefereces
    await preferences.setString(UserStorage.userId, userId);
    await preferences.setString(UserStorage.userEmail, email);

    // Convert to map and change id
    final model = EmployeeModel(
      id: userId,
      email: email,
      photoPath: 'photoPath',
      subscriptionExpirationDateTime: DateTime.now(),
    );

    // Write user to base
    await database.from('employee').insert(
          model.toMap(),
        );

    return model;
  }
}
