import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/services/app/version_control_service.dart';

part 'verison_control_state.dart';

class VerisonControlCubit extends Cubit<VerisonControlState> {
  final VersionControlService versionControlService;

  VerisonControlCubit({
    required this.versionControlService,
  }) : super(const VersionUnchecked());

  void startVersionCheck() async {
    final versionResult = await versionControlService.checkVersion();

    if (versionResult.isSuccess()) {
      final (needsUpdate, isStrict) = (
        versionResult.tryGetSuccess()!.needsUpdate,
        versionResult.tryGetSuccess()!.isStrict,
      );

      if (needsUpdate) {
        emit(VersionChecked(isStrict));
      }
    } else {
      Future.delayed(const Duration(seconds: 5), () => startVersionCheck());
    }
  }
}
