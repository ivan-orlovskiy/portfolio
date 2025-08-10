import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopper/src/common/exceptions/base_exception.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  final SupabaseClient database;
  final SharedPreferences localStorage;

  static const userIdKey = 'userIdKey';
  static const userNicknameKey = 'userNicknameKey';

  AuthenticationService({
    required this.database,
    required this.localStorage,
  });

  String _userId = '';
  String _userNickname = '';

  String get userId => _userId;
  String get userNickname => _userNickname;
  String get userEmail =>
      database.auth.currentUser?.email ?? 'LOGOUT AND LOGIN AGAIN';

  Result<Unit, BaseException> initialize() {
    try {
      final maybeUserId = localStorage.getString(userIdKey);
      final maybeUserNickname = localStorage.getString(userNicknameKey);
      if (maybeUserId == null || maybeUserNickname == null) {
        return Error(BaseException(message: '-- internal --'));
      }
      _userId = maybeUserId;
      _userNickname = maybeUserNickname;
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: '-- internal --'));
    }
  }

  Future<Result<Unit, BaseException>> signUp(
      String nickname, String email, String password) async {
    try {
      final usersWithSameNicknames =
          await database.from('user').select().eq('nickname', nickname);
      if (usersWithSameNicknames.isNotEmpty) {
        return Error(BaseException(message: Lang.nicknameAlreadyTaken));
      }
      await database.auth.signUp(
          email: email, password: password, data: {'nickname': nickname});
      await database.from('user').insert({
        'id': database.auth.currentUser!.id,
        'nickname': nickname,
        'email': email,
        'sub_type': 'trial',
        'sub_expiration':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      });
      _userId = database.auth.currentUser!.id;
      _userNickname = database.auth.currentUser!.userMetadata!['nickname'];
      await localStorage.setString(userIdKey, _userId);
      await localStorage.setString(userNicknameKey, _userNickname);
      return const Success(unit);
    } on AuthException catch (e) {
      if (e.message == 'User already registered') {
        return Error(BaseException(message: Lang.emailAlreadyRegistered));
      }
      rethrow;
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> recoverPassword() async {
    try {
      _userId = database.auth.currentUser!.id;
      _userNickname = database.auth.currentUser!.userMetadata!['nickname'];
      await localStorage.setString(userIdKey, _userId);
      await localStorage.setString(userNicknameKey, _userNickname);
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> signIn(
      String email, String password) async {
    try {
      await database.auth.signInWithPassword(email: email, password: password);
      _userId = database.auth.currentUser!.id;
      _userNickname = database.auth.currentUser!.userMetadata!['nickname'];
      await localStorage.setString(userIdKey, _userId);
      await localStorage.setString(userNicknameKey, _userNickname);
      return const Success(unit);
    } on AuthException catch (_) {
      return Error(BaseException(message: Lang.invalidCredentials));
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> signOut() async {
    try {
      await database.auth.signOut();
      await localStorage.clear();
      _userId = '';
      _userNickname = '';
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }

  Future<Result<Unit, BaseException>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final verified = await database.rpc(
        'verify_user_password',
        params: {
          'password': oldPassword,
        },
      ) as bool;
      if (!verified) {
        return Error(BaseException(message: Lang.oldPasswordIsIncorrect));
      }
      await database.auth.updateUser(UserAttributes(password: newPassword));
      return const Success(unit);
    } catch (_) {
      return Error(BaseException(message: Lang.smthWentWrong));
    }
  }
}
