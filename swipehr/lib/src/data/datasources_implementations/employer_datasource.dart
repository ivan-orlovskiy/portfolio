import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipehr/src/core/exceptions/common/network_exception.dart';
import 'package:swipehr/src/core/keys/user_storage.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employer_datasource.dart';
import 'package:swipehr/src/data/models/employer_model.dart';

class EmployerDatasource implements IEmployerDatasource {
  final SupabaseClient database;
  final InternetConnectionChecker connectionChecker;
  final SharedPreferences preferences;

  EmployerDatasource({
    required this.database,
    required this.connectionChecker,
    required this.preferences,
  });

  @override
  Future<void> deleteAccount(String employerId) async {
    // To be implemented
    throw UnimplementedError();
  }

  @override
  Future<List<EmployerModel>> loadCompanies() async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get users from base
    final maps = await database.from('employer').select<List<Map<String, dynamic>>>();

    return maps.map((e) => EmployerModel.fromMap(e)).toList();
  }

  @override
  Future<EmployerModel> loadOwnAccount(String employerId) async {
    final hasConnection = await connectionChecker.hasConnection;
    if (!hasConnection) {
      throw const NetworkException();
    }

    // Get user from base
    final map = await database
        .from('employer')
        .select<Map<String, dynamic>>()
        .eq('id', employerId)
        .single();

    return EmployerModel.fromMap(map);
  }

  @override
  Future<EmployerModel> signIn(String email, String password) async {
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

    // Get user from base
    final map =
        await database.from('employer').select<Map<String, dynamic>>().eq('email', email).single();

    return EmployerModel.fromMap(map);
  }

  @override
  Future<void> signOut() async {
    await preferences.remove(UserStorage.userId);
    await preferences.remove(UserStorage.userEmail);
    await database.auth.signOut();
  }

  @override
  Future<EmployerModel> signUp(
      String email, String password, String companyName, File photo) async {
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
    final model = EmployerModel(
      id: userId,
      email: email,
      companyName: companyName,
      photoPath: 'photoPath',
      subscriptionExpirationDateTime: DateTime.now(),
    );

    // Write user to base
    await database.from('employer').insert(
          model.toMap(),
        );

    return model;
  }
}
