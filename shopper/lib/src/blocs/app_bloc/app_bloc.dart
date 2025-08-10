import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:once/once.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/services/cache/cards_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_cache_service.dart';
import 'package:shopper/src/services/cache/shopping_list_item_cache_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationService authService;
  final ShoppingListCacheService listCacheService;
  final ShoppingListItemCacheService itemCacheService;
  final CardsCacheService cardsCacheService;

  AppBloc({
    required this.authService,
    required this.listCacheService,
    required this.itemCacheService,
    required this.cardsCacheService,
  }) : super(const AppLoadingScreen()) {
    on<AppEvent>(
      (event, emit) async {
        switch (event) {
          case AppInitialize():
            await _onInitialize(event, emit);
          case AppSignIn():
            await _onSignIn(event, emit);
          case AppSignUp():
            await _onSignUp(event, emit);
          case AppSignOut():
            await _onSignOut(event, emit);
          case AppPasswordRecovered():
            await _onPasswordRecovered(event, emit);
        }
      },
    );
  }

  Future<void> _onInitialize(AppInitialize _, Emitter<AppState> emit) async {
    emit(const AppLoadingScreen());

    final result = authService.initialize();

    if (result.isSuccess()) {
      emit(const AppScreen());
    } else {
      emit(const AppSignScreen());
    }
  }

  Future<void> _onSignIn(AppSignIn event, Emitter<AppState> emit) async {
    final result = await authService.signIn(event.email, event.password);

    if (result.isSuccess()) {
      event.onSuccess();
      emit(const AppScreen());
    } else {
      event.onError(result.tryGetError()!.message);
      AnalyticsService.error('signIn', {
        'message': result.tryGetError()!.message,
      });
    }
  }

  Future<void> _onSignUp(AppSignUp event, Emitter<AppState> emit) async {
    final result =
        await authService.signUp(event.nickname, event.email, event.password);

    if (result.isSuccess()) {
      event.onSuccess();
      AnalyticsService.signUp();
      emit(const AppScreen());
    } else {
      event.onError(result.tryGetError()!.message);
      AnalyticsService.error('signUp', {
        'message': result.tryGetError()!.message,
      });
    }
  }

  Future<void> _onSignOut(AppSignOut _, Emitter<AppState> emit) async {
    emit(const AppLoadingScreen());

    final result = await authService.signOut();
    await listCacheService.clearCache();
    await itemCacheService.clearCache();
    await cardsCacheService.clearCache();
    Once.clearAll();

    if (result.isSuccess()) {
      emit(const AppSignScreen());
    } else {
      emit(const AppScreen());
      AnalyticsService.error('signOut', {
        'message': result.tryGetError()!.message,
      });
    }
  }

  Future<void> _onPasswordRecovered(
      AppPasswordRecovered event, Emitter<AppState> emit) async {
    final result = await authService.recoverPassword();

    if (result.isSuccess()) {
      emit(const AppScreen());
    } else {
      emit(const AppSignScreen());
    }
  }
}
