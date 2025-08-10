part of 'verison_control_cubit.dart';

sealed class VerisonControlState extends Equatable {
  const VerisonControlState();

  @override
  List<Object> get props => [];
}

final class VersionUnchecked extends VerisonControlState {
  const VersionUnchecked();
}

final class VersionChecked extends VerisonControlState {
  final bool isStrict;
  const VersionChecked(this.isStrict);

  @override
  List<Object> get props => [isStrict];
}
