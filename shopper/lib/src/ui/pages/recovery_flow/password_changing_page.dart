import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/blocs/app_bloc/app_bloc.dart';
import 'package:shopper/src/common/validators/validators.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/password_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordChangingPage extends StatefulWidget {
  final String email;

  const PasswordChangingPage({
    super.key,
    required this.email,
  });

  @override
  State<PasswordChangingPage> createState() => _PasswordChangingPageState();
}

class _PasswordChangingPageState extends State<PasswordChangingPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        FlushbarFactory.warningFlushBar(
          message: Lang.firstChangePassword,
        ).show(context);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.bgLight,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewPadding.bottom -
                      MediaQuery.of(context).viewPadding.top,
                  maxHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewPadding.bottom -
                      MediaQuery.of(context).viewPadding.top,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 90.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Lang.enterNewPassword,
                                style: AppFonts.pageTitleLight,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Lang.newPasswordDesc,
                                  style: AppFonts.panelTitleLight,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                PasswordTextField(
                                  controller: _passwordController,
                                  hint: Lang.password,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppButton(
                                title: Lang.changePassword,
                                onPressed: () async {
                                  if (!Validators.password(
                                      _passwordController.text)) {
                                    FlushbarFactory.warningFlushBar(
                                      message: Lang.passwordRules,
                                    ).show(context);
                                    return;
                                  }
                                  final isConnected = await _checkConnection();
                                  if (!isConnected) return;
                                  if (!mounted) return;

                                  FocusManager.instance.primaryFocus?.unfocus();

                                  final closeListener =
                                      ValueNotifier<bool>(false);
                                  final showLoader = ValueNotifier<bool>(true);
                                  var error = '';
                                  var success = false;

                                  _changePassword(
                                    closeListener,
                                    (newError) => error = newError,
                                    (value) => success = value,
                                  );

                                  if (!mounted) {
                                    return;
                                  }
                                  if (!showLoader.value) {
                                    return;
                                  }
                                  await showDialog(
                                    barrierDismissible: false,
                                    useSafeArea: false,
                                    barrierColor:
                                        AppColors.bgDialog.withOpacity(0.7),
                                    context: context,
                                    builder: (_) => ValueListenableBuilder(
                                      valueListenable: closeListener,
                                      builder: (localContext, value, child) {
                                        if (value) {
                                          Navigator.pop(context);
                                        }
                                        return const PopScope(
                                          canPop: false,
                                          child: Loader(),
                                        );
                                      },
                                    ),
                                  );
                                  if (!mounted) return;
                                  if (error.isNotEmpty) {
                                    FlushbarFactory.warningFlushBar(
                                      message: error,
                                    ).show(context);
                                  }
                                  if (success) {
                                    BlocProvider.of<AppBloc>(context).add(
                                      const AppPasswordRecovered(),
                                    );
                                    Navigator.popUntil(
                                      context,
                                      (route) =>
                                          route.settings.name == '/main_page',
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 100,
                      right: -150,
                      child: IgnorePointer(
                        child: Container(
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            backgroundBlendMode: BlendMode.saturation,
                          ),
                          child: Transform.rotate(
                            angle: pi * 0.5,
                            child: Opacity(
                              opacity: 0.3,
                              child: Lottie.asset(
                                'assets/lottie/leaves_animation.json',
                                height: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: -220,
                      child: IgnorePointer(
                        child: Container(
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            backgroundBlendMode: BlendMode.saturation,
                          ),
                          child: Transform.rotate(
                            angle: pi * -0.9,
                            child: Opacity(
                              opacity: 0.3,
                              child: Lottie.asset(
                                'assets/lottie/leaves_animation.json',
                                height: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  void _changePassword(
    ValueNotifier<bool> closeListener,
    Function(String) errorSetter,
    Function(bool) successSetter,
  ) async {
    try {
      await sl<SupabaseClient>().auth.updateUser(
            UserAttributes(
              password: _passwordController.text,
            ),
          );
      closeListener.value = true;
      successSetter(true);
    } catch (_) {
      errorSetter(Lang.passwordCantBeTheSameAsOld);
      closeListener.value = true;
    }
  }

  Future<bool> _checkConnection() async {
    final isConnected = await sl<ConnectionService>().isConnected;
    if (!isConnected) {
      _showErrorFlushBar(Lang.notConnected);
      return false;
    }
    return true;
  }

  void _showErrorFlushBar(String errorMessage) {
    FlushbarFactory.warningFlushBar(message: errorMessage).show(context);
  }
}
