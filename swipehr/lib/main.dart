import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:swipehr/src/presentation/screens/main_wrapper.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';

void main() async {
  await init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: SwipeHrColors.pageBackground,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(const AuthAutoSignIn()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: SwipeHrColors.secondary,
            selectionColor: SwipeHrColors.secondary.withOpacity(0.4),
            selectionHandleColor: SwipeHrColors.secondary,
          ),
        ),
        scrollBehavior: const BouncingScrollBehaviour(),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        title: 'SwipeHr',
        home: const MainWrapper(),
        // home: const MainScreen(),
      ),
    );
  }
}

class BouncingScrollBehaviour extends ScrollBehavior {
  const BouncingScrollBehaviour();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const BouncingScrollPhysics();
}
