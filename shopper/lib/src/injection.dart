import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopper/src/blocs/app_bloc/app_bloc.dart';
import 'package:shopper/src/blocs/cards_tab_bloc/cards_tab_bloc.dart';
import 'package:shopper/src/blocs/list_participants_bloc/list_participants_bloc.dart';
import 'package:shopper/src/blocs/shopping_list_page_bloc/shopping_list_page_bloc.dart';
import 'package:shopper/src/blocs/shopping_list_tab_bloc/shopping_list_tab_bloc.dart';
import 'package:shopper/src/blocs/version_control/verison_control_cubit.dart';
import 'package:shopper/src/common/constants/boxes.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/app/email_service.dart';
import 'package:shopper/src/services/app/version_control_service.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/services/cache/cards_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_item_cache_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/services/data/card_service.dart';
import 'package:shopper/src/services/data/shopping_list_item_service.dart';
import 'package:shopper/src/services/data/shopping_list_service.dart';
import 'package:shopper/src/services/data/shopping_list_user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.I;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await AnalyticsService.initialize();
  await Supabase.initialize(
    url: '---FROM ENV---',
    anonKey: '---FROM ENV---',
  );

  await Hive.initFlutter();
  await Hive.openBox(Boxes.listsBox);
  await Hive.openBox(Boxes.listItemsBox);
  await Hive.openBox(Boxes.cardsBox);

  // Utils
  sl.registerSingleton<SmtpServer>(
    SmtpServer(
      '---FROM ENV---',
      port: 777,
      username: '---FROM ENV---',
      password: '---FROM ENV---',
      ssl: true,
    ),
  );
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);
  sl.registerSingleton<Uuid>(const Uuid());
  sl.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());
  final sp = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sp);

  // Services
  sl.registerSingleton(
    ShoppingListItemService(
      database: sl(),
    ),
  );
  sl.registerSingleton(
    ShoppingListItemCacheService(
      database: Hive.box(Boxes.listItemsBox),
    ),
  );
  sl.registerSingleton(
    ShoppingListService(
      uuid: sl(),
      database: sl(),
    ),
  );
  sl.registerSingleton(
    ShoppingListCacheService(
      database: Hive.box(Boxes.listsBox),
    ),
  );
  sl.registerSingleton(
    ShoppingListUserService(
      uuid: sl(),
      database: sl(),
    ),
  );
  sl.registerSingleton(
    ConnectionService(
      internetConnectionChecker: sl(),
    ),
  );
  sl.registerSingleton(
    AuthenticationService(
      database: sl(),
      localStorage: sl(),
    ),
  );
  sl.registerSingleton(
    CardService(
      uuid: sl(),
      database: sl(),
    ),
  );
  sl.registerSingleton(
    CardsCacheService(
      database: Hive.box(Boxes.cardsBox),
    ),
  );
  sl.registerSingleton(
    VersionControlService(
      database: sl(),
    ),
  );
  sl.registerSingleton(
    EmailService(
      smtpServer: sl(),
    ),
  );

  // Blocs
  sl.registerFactory(
    () => ShoppingListPageBloc(
      connectionService: sl(),
      service: sl(),
      cacheService: sl(),
    ),
  );
  sl.registerFactory(
    () => ShoppingListTabBloc(
      connectionService: sl(),
      service: sl(),
      userService: sl(),
      listCacheService: sl(),
      listItemCacheService: sl(),
      authenticationService: sl(),
    ),
  );
  sl.registerFactory(
    () => ListParticipantsBloc(
      service: sl(),
    ),
  );
  sl.registerSingleton(
    AppBloc(
      authService: sl(),
      listCacheService: sl(),
      itemCacheService: sl(),
      cardsCacheService: sl(),
    ),
  );
  sl.registerFactory(
    () => CardsTabBloc(
      connectionService: sl(),
      service: sl(),
      cacheService: sl(),
    ),
  );
  sl.registerFactory(
    () => VerisonControlCubit(
      versionControlService: sl(),
    ),
  );
}
