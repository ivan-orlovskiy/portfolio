import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipehr/secrets/database.dart';
import 'package:swipehr/src/data/datasources_implementations/application_datasource.dart';
import 'package:swipehr/src/data/datasources_implementations/employee_datasource.dart';
import 'package:swipehr/src/data/datasources_implementations/employer_datasource.dart';
import 'package:swipehr/src/data/datasources_implementations/vacancy_datasource.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_application_datasource.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employee_datasource.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_employer_datasource.dart';
import 'package:swipehr/src/data/datasources_interfaces/i_vacancy_datasource.dart';
import 'package:swipehr/src/data/repositories/application_repository.dart';
import 'package:swipehr/src/data/repositories/employee_repository.dart';
import 'package:swipehr/src/data/repositories/employer_repository.dart';
import 'package:swipehr/src/data/repositories/vacancy_repository.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_application_repository.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employee_repository.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_employer_repository.dart';
import 'package:swipehr/src/domain/repositories_interfaces/i_vacancy_repository.dart';
import 'package:swipehr/src/domain/usecases/employee/application/create_application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/delete_application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_companies.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_own_application.dart';
import 'package:swipehr/src/domain/usecases/employee/application/load_vacancies_for_employer.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_delete_account.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_load_own_account.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_in.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_out.dart';
import 'package:swipehr/src/domain/usecases/employee/auth/employee_sign_up.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_delete_account.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_load_own_account.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_in.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_out.dart';
import 'package:swipehr/src/domain/usecases/employer/auth/employer_sign_up.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/create_vacancy.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/delete_vacancy.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/load_applications_for_a_vacancy.dart';
import 'package:swipehr/src/domain/usecases/employer/vacancies/load_own_vacancies.dart';
import 'package:swipehr/src/presentation/blocs/application_bloc/application_bloc.dart';
import 'package:swipehr/src/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:swipehr/src/presentation/blocs/companies_bloc/companies_bloc.dart';
import 'package:swipehr/src/presentation/blocs/document_bloc/document_bloc.dart';
import 'package:swipehr/src/presentation/blocs/employee_vacancies_bloc/employee_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/blocs/employer_vacancies_bloc/employer_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/blocs/vacancy_applications/vacancy_applications_bloc.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Service initialization
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(
    url: databaseUrl,
    anonKey: anonKey,
  );

  // Utils
  final sp = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sp);
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);
  sl.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  // Datasources
  sl.registerSingleton<IApplicationDatasource>(
    ApplicationDatasource(
      database: sl(),
      connectionChecker: sl(),
    ),
  );
  sl.registerSingleton<IEmployeeDatasource>(
    EmployeeDatasource(
      preferences: sl(),
      database: sl(),
      connectionChecker: sl(),
    ),
  );
  sl.registerSingleton<IEmployerDatasource>(
    EmployerDatasource(
      preferences: sl(),
      database: sl(),
      connectionChecker: sl(),
    ),
  );
  sl.registerSingleton<IVacancyDatasource>(
    VacancyDatasource(
      database: sl(),
      connectionChecker: sl(),
    ),
  );

  // Repositories
  sl.registerSingleton<IApplicationRepository>(
    ApplicationRepository(datasource: sl()),
  );
  sl.registerSingleton<IEmployeeRepository>(
    EmployeeRepository(datasource: sl()),
  );
  sl.registerSingleton<IEmployerRepository>(
    EmployerRepository(datasource: sl()),
  );
  sl.registerSingleton<IVacancyRepository>(
    VacancyRepository(datasource: sl()),
  );

  // Usecases
  // ---
  sl.registerSingleton<CreateApplication>(
    CreateApplication(sl()),
  );
  sl.registerSingleton<DeleteApplication>(
    DeleteApplication(sl()),
  );
  sl.registerSingleton<LoadCompanies>(
    LoadCompanies(sl()),
  );
  sl.registerSingleton<LoadOwnApplication>(
    LoadOwnApplication(sl()),
  );
  sl.registerSingleton<LoadVacanciesForEmployer>(
    LoadVacanciesForEmployer(sl()),
  );
  // ---
  sl.registerSingleton<EmployeeDeleteAccount>(
    EmployeeDeleteAccount(sl()),
  );
  sl.registerSingleton<EmployeeLoadOwnAccount>(
    EmployeeLoadOwnAccount(sl()),
  );
  sl.registerSingleton<EmployeeSignIn>(
    EmployeeSignIn(sl()),
  );
  sl.registerSingleton<EmployeeSignOut>(
    EmployeeSignOut(sl()),
  );
  sl.registerSingleton<EmployeeSignUp>(
    EmployeeSignUp(sl()),
  );
  // ---
  // sl.registerSingleton<EmployeeBuySubscription>(
  //   EmployeeBuySubscription(sl()),
  // );
  // ---
  sl.registerSingleton<EmployerDeleteAccount>(
    EmployerDeleteAccount(sl()),
  );
  sl.registerSingleton<EmployerLoadOwnAccount>(
    EmployerLoadOwnAccount(sl()),
  );
  sl.registerSingleton<EmployerSignIn>(
    EmployerSignIn(sl()),
  );
  sl.registerSingleton<EmployerSignOut>(
    EmployerSignOut(sl()),
  );
  sl.registerSingleton<EmployerSignUp>(
    EmployerSignUp(sl()),
  );
  // ---
  // sl.registerSingleton<EmployerBuySubscription>(
  //   EmployerBuySubscription(sl()),
  // );
  // ---
  sl.registerSingleton<CreateVacancy>(
    CreateVacancy(sl()),
  );
  sl.registerSingleton<DeleteVacancy>(
    DeleteVacancy(sl()),
  );
  sl.registerSingleton<LoadApplicationsForAVacancy>(
    LoadApplicationsForAVacancy(sl()),
  );
  sl.registerSingleton<LoadOwnVacancies>(
    LoadOwnVacancies(sl()),
  );

  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sp: sl(),
      employeeSignIn: sl(),
      employeeSignOut: sl(),
      employeeSignUp: sl(),
      employerSignIn: sl(),
      employerSignOut: sl(),
      employerSignUp: sl(),
    ),
  );
  sl.registerFactory<CompaniesBloc>(
    () => CompaniesBloc(
      loadCompanies: sl(),
    ),
  );
  sl.registerFactory<EmployeeVacanciesBloc>(
    () => EmployeeVacanciesBloc(
      loadVacanciesForEmployer: sl(),
    ),
  );
  sl.registerFactory<EmployerVacanciesBloc>(
    () => EmployerVacanciesBloc(
      sp: sl(),
      loadVacanciesForEmployer: sl(),
      createVacancy: sl(),
      deleteVacancy: sl(),
    ),
  );
  sl.registerFactory<ApplicationBloc>(
    () => ApplicationBloc(
      sp: sl(),
      deleteApplication: sl(),
      loadOwnApplication: sl(),
      createApplication: sl(),
    ),
  );
  sl.registerFactory<VacancyApplicationsBloc>(
    () => VacancyApplicationsBloc(
      loadApplicationsForAVacancy: sl(),
    ),
  );
  sl.registerFactory<DocumentBloc>(
    () => DocumentBloc(
      database: sl(),
    ),
  );
}
