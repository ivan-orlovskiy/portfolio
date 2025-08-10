import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/recovery_flow/password_changing_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecoveryPage extends StatefulWidget {
  final String email;

  const RecoveryPage({
    super.key,
    required this.email,
  });

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final TextEditingController _codeController = TextEditingController();
  int _time = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _retrieveCode();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_time == 0) {
          _timer?.cancel();
        } else {
          setState(() {
            _time--;
          });
        }
      },
    );
  }

  void _retrieveCode() async {
    if (_time > 0) return;
    setState(() {
      _time = 60;
    });

    sl<SupabaseClient>().auth.resetPasswordForEmail(widget.email);

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
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
                              Lang.enterCode,
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
                                Lang.messageWithCodeWasSent,
                                style: AppFonts.panelTitleLight,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                textInputType: TextInputType.emailAddress,
                                controller: _codeController,
                                hint: Lang.verificationCode,
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => _retrieveCode(),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _time == 0
                                          ? Lang.sendAgain
                                          : '${Lang.sendAgainIn} $_time ${Lang.seconds}',
                                      style:
                                          AppFonts.panelAttributeLight.copyWith(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppButton(
                              title: Lang.recoverPassword,
                              onPressed: () async {
                                if (_codeController.text.isEmpty) {
                                  FlushbarFactory.warningFlushBar(
                                    message: Lang.inputCode,
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

                                _verifyOTPCode(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PasswordChangingPage(
                                          email: widget.email),
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

  void _verifyOTPCode(
    ValueNotifier<bool> closeListener,
    Function(String) errorSetter,
    Function(bool) successSetter,
  ) async {
    try {
      await sl<SupabaseClient>().auth.verifyOTP(
            email: widget.email,
            token: _codeController.text,
            type: OtpType.recovery,
          );
      closeListener.value = true;
      successSetter(true);
    } catch (_) {
      errorSetter(Lang.inputCode);
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
