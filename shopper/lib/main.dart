import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:once/once.dart';
import 'package:shopper/src/blocs/app_bloc/app_bloc.dart';
import 'package:shopper/src/blocs/version_control/verison_control_cubit.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/cache/cards_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_item_cache_service.dart';
import 'package:shopper/src/ui/pages/auth_flow/welcome_page.dart';
import 'package:shopper/src/ui/pages/main_screen.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/loader.dart';

void main() async {
  await init();

  Once.runOnEveryNewVersion(
    callback: () async {
      await sl<ShoppingListCacheService>().clearCache();
      await sl<ShoppingListItemCacheService>().clearCache();
      await sl<CardsCacheService>().clearCache();
    },
  );

  Once.runOnce(
    'appInstallation',
    callback: () => AnalyticsService.appInstallation(),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const ShopperApp(),
    ),
  );
}

class ShopperApp extends StatelessWidget {
  const ShopperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppBloc>()..add(const AppInitialize()),
      child: BlocProvider(
        create: (context) => sl<VerisonControlCubit>()..startVersionCheck(),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          scrollBehavior: const DefaultBouncingScrollBehaviour(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/main_page',
          routes: {
            '/main_page': (context) => Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: AppColors.bgLight,
                  body: SafeArea(
                    child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _buildPage(context, state),
                        );
                      },
                    ),
                  ),
                ),
          },
          title: 'Shopper',
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CustomTransitionBuilder(),
              },
            ),
            colorScheme: const ColorScheme.light(
              background: AppColors.bgLight,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: AppColors.bgLight,
              surfaceTintColor: AppColors.bgLight,
              dragHandleColor: AppColors.accentLight,
              modalBackgroundColor: AppColors.bgLight,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.accentLight,
              selectionColor: AppColors.accentLight.withOpacity(0.2),
              selectionHandleColor: AppColors.accentLight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, AppState state) {
    if (state is AppScreen) {
      return const MainScreen(key: ValueKey('0'));
    } else if (state is AppSignScreen) {
      return const WelcomePage(key: ValueKey('1'));
    }
    return const Scaffold(key: ValueKey('2'), body: Loader());
  }
}

class DefaultBouncingScrollBehaviour extends ScrollBehavior {
  const DefaultBouncingScrollBehaviour();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const ClampingScrollPhysics();
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
