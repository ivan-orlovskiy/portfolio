import 'package:multiple_result/multiple_result.dart';
import 'package:shopper/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VersionControlService {
  final SupabaseClient database;

  VersionControlService({required this.database});

  Future<Result<VersionDialogSetup, Unit>> checkVersion() async {
    try {
      final versionDetails = await database
          .from('service')
          .select()
          .eq('field_name', 'app_version')
          .single();
      final actualAppVersion = versionDetails['field_value'] as String;
      final isStrict = versionDetails['field_helper'] as String;

      if (actualAppVersion != App.appVersion) {
        return Result.success(
          VersionDialogSetup(
            needsUpdate: true,
            isStrict: isStrict == 'strict',
          ),
        );
      } else {
        return const Result.success(
          VersionDialogSetup(
            needsUpdate: false,
            isStrict: false,
          ),
        );
      }
    } catch (_) {
      return const Result.error(unit);
    }
  }
}

class VersionDialogSetup {
  final bool needsUpdate;
  final bool isStrict;

  const VersionDialogSetup({
    required this.needsUpdate,
    required this.isStrict,
  });
}
