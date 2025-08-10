import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/blocs/app_bloc/app_bloc.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/recovery_flow/recovery_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/password_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                              Lang.signInWelcome,
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
                              AppTextField(
                                textInputType: TextInputType.emailAddress,
                                controller: _emailController,
                                hint: Lang.email,
                              ),
                              const SizedBox(height: 12),
                              PasswordTextField(
                                controller: _passwordController,
                                hint: Lang.password,
                                isEnd: true,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_emailController.text.isEmpty) {
                                      FlushbarFactory.warningFlushBar(
                                        message: Lang.fillEmail,
                                      ).show(context);
                                      return;
                                    }
                                    final isConnected = await _checkConnection();
                                    if (!isConnected) return;
                                    if (!mounted) return;

                                    FocusManager.instance.primaryFocus?.unfocus();

                                    final closeListener = ValueNotifier<bool>(false);
                                    final showLoader = ValueNotifier<bool>(true);
                                    var error = '';

                                    _verifyEmail(
                                      closeListener,
                                      (newError) => error = newError,
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
                                      barrierColor: AppColors.bgDialog.withOpacity(0.7),
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
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              RecoveryPage(email: _emailController.text),
                                        ),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Forgot password?',
                                      style: AppFonts.panelAttributeLight.copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppButton(
                              title: Lang.signIn,
                              onPressed: () async {
                                final isConnected = await _checkConnection();
                                if (!isConnected) return;
                                if (!mounted) return;

                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.fillAllTheFields,
                                  ).show(context);
                                  return;
                                }

                                final closeListener = ValueNotifier<bool>(false);
                                var error = '';
                                BlocProvider.of<AppBloc>(context).add(
                                  AppSignIn(
                                    _emailController.text,
                                    _passwordController.text,
                                    () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    (errorMessage) {
                                      error = errorMessage;
                                      closeListener.value = true;
                                    },
                                  ),
                                );
                                if (!mounted) {
                                  return;
                                }
                                await showDialog(
                                  barrierDismissible: false,
                                  useSafeArea: false,
                                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
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
                              },
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              inverted: true,
                              title: Lang.back,
                              onPressed: () {
                                Navigator.pop(context);
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
    );
  }

  void _verifyEmail(ValueNotifier<bool> closeListener, Function(String) errorSetter) async {
    final usersWithSameEmails =
        await sl<SupabaseClient>().from('user').select().eq('email', _emailController.text);
    if (usersWithSameEmails.isEmpty) {
      errorSetter('No user with this email');
      closeListener.value = true;
      return;
    }
    closeListener.value = true;
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
