import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/common/validators/validators.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/auth_flow/verification_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_checkbox.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/password_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _privacyPolicyAgreement = false;

  @override
  void dispose() {
    _nicknameController.dispose();
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
                              Lang.signUpWelcome,
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
                                textInputType: TextInputType.name,
                                controller: _nicknameController,
                                hint: Lang.nickname,
                              ),
                              const SizedBox(height: 12),
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
                              AppCheckbox(
                                onChanged: (value) {
                                  _privacyPolicyAgreement = value;
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        'https://docs.google.com/document/d/1oD1mLn4vPZNofi5bNFzVGunoiV3bjSlqd4e28ooJ4hs/edit?usp=sharing');
                                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView) &&
                                        mounted) {
                                      FlushbarFactory.warningFlushBar(
                                        message: Lang.fillAllTheFields,
                                      ).show(context);
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Lang.iAgreeWithPP,
                                            style: AppFonts.panelTitleLight.copyWith(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 1),
                                      Container(
                                        width: 180,
                                        height: 1,
                                        color: AppColors.accentLight,
                                      ),
                                    ],
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
                              title: Lang.signUp,
                              onPressed: () async {
                                final isConnected = await _checkConnection();
                                if (!isConnected) return;
                                if (!mounted) return;

                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_nicknameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.fillAllTheFields,
                                  ).show(context);
                                  return;
                                }

                                if (!Validators.nickname(_nicknameController.text)) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.nicknameRules,
                                  ).show(context);
                                  return;
                                }
                                if (!Validators.email(_emailController.text)) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.emailRules,
                                  ).show(context);
                                  return;
                                }
                                if (!Validators.password(_passwordController.text)) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.passwordRules,
                                  ).show(context);
                                  return;
                                }

                                if (!_privacyPolicyAgreement) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.mustAcceptPP,
                                  ).show(context);
                                  return;
                                }

                                final closeListener = ValueNotifier<bool>(false);
                                final showLoader = ValueNotifier<bool>(true);
                                var error = '';

                                _verifyNicknameAndEmail(
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
                                  return;
                                }

                                if (mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VerificationPage(
                                        nickname: _nicknameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    ),
                                  );
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

  void _verifyNicknameAndEmail(
      ValueNotifier<bool> closeListener, Function(String) errorSetter) async {
    final usersWithSameNicknames =
        await sl<SupabaseClient>().from('user').select().eq('nickname', _nicknameController.text);
    if (usersWithSameNicknames.isNotEmpty) {
      errorSetter(Lang.nicknameAlreadyTaken);
      closeListener.value = true;
      return;
    }
    final usersWithSameEmails =
        await sl<SupabaseClient>().from('user').select().eq('email', _emailController.text);
    if (usersWithSameEmails.isNotEmpty) {
      errorSetter(Lang.emailAlreadyRegistered);
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
