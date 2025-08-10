import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';

class ParticipantAdditionDialog extends StatefulWidget {
  static const pageName = '/participant_addition_dialog';
  final Function(String userNickname) creationFunction;

  const ParticipantAdditionDialog({
    super.key,
    required this.creationFunction,
  });

  @override
  State<ParticipantAdditionDialog> createState() =>
      _ParticipantAdditionDialogState();
}

class _ParticipantAdditionDialogState extends State<ParticipantAdditionDialog> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _participantNicknameController =
      TextEditingController();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _participantNicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                width: 300,
                height: 160,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextField(
                      focusNode: _focusNode,
                      controller: _participantNicknameController,
                      hint: Lang.nickname,
                    ),
                    AppButton(
                      title: Lang.addUser,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_participantNicknameController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.inputParticipant,
                          ).show(context);
                          return;
                        }
                        widget.creationFunction(
                            _participantNicknameController.text);
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name ==
                              ParticipantAdditionDialog.pageName,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
