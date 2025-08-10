import 'package:flutter/material.dart';
import 'package:shopper/src/common/validators/validators.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/password_text_field.dart';

class PasswordChangingDialog extends StatefulWidget {
  static const String pageName = '/password_changing_dialog';
  final Function(String oldPassword, String newPassword) changeFunction;

  const PasswordChangingDialog({
    super.key,
    required this.changeFunction,
  });

  @override
  State<PasswordChangingDialog> createState() => _PasswordChangingDialogState();
}

class _PasswordChangingDialogState extends State<PasswordChangingDialog> {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _oldController.dispose();
    _newController.dispose();
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
                height: 225,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PasswordTextField(
                      focusNode: _focusNode,
                      controller: _oldController,
                      hint: 'Old password',
                    ),
                    PasswordTextField(
                      controller: _newController,
                      hint: 'New password',
                      isEnd: true,
                    ),
                    AppButton(
                      title: 'Change',
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_oldController.text.isEmpty ||
                            _newController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: 'Fill both fields',
                          ).show(context);
                          return;
                        }
                        if (!Validators.password(_newController.text)) {
                          FlushbarFactory.warningFlushBar(
                            message:
                                'New password must be at least 8 symbols and contain letters and numbers',
                          ).show(context);
                          return;
                        }
                        final confirmed = await showDialog(
                          useSafeArea: false,
                          barrierDismissible: false,
                          barrierColor: AppColors.bgDialog.withOpacity(0.7),
                          context: context,
                          builder: (_) => const ConfirmationDialog(
                              message: 'Change password?'),
                        );
                        if (confirmed == null || !confirmed) {
                          return;
                        }
                        widget.changeFunction(
                          _oldController.text,
                          _newController.text,
                        );
                        if (!mounted) return;
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name ==
                              PasswordChangingDialog.pageName,
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
