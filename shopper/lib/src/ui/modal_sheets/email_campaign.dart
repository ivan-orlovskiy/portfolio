import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/common/validators/validators.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/analytics/analytics_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EmailCampaign extends StatefulWidget {
  const EmailCampaign({super.key});

  @override
  State<EmailCampaign> createState() => _EmailCampaignState();
}

class _EmailCampaignState extends State<EmailCampaign> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgLight,
          ),
          child: SafeArea(
            child: SizedBox(
              height: 550,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              foregroundDecoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              child: Lottie.asset(
                                'assets/lottie/email_animation.json',
                                height: 300,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${Lang.paywallTitle}!',
                                      style: AppFonts.pageTitleLight,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${Lang.paywallContent}!',
                                      style: AppFonts.panelTitleLight,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        AppTextField(
                          isEnd: true,
                          controller: _emailController,
                          hint: Lang.email,
                        ),
                        const SizedBox(height: 6),
                        AppButton(
                          title: Lang.send,
                          onPressed: () async {
                            if (_emailController.text.isEmpty) {
                              _showErrorFlushBar(Lang.fillEmail);
                              return;
                            }
                            if (!Validators.email(_emailController.text)) {
                              _showErrorFlushBar(Lang.emailRules);
                              return;
                            }

                            if (!await _sendEmail(context, _emailController.text)) return;
                            if (mounted) Navigator.pop(context, true);
                          },
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => Navigator.pop(context, false),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                Lang.noThanks,
                                style: AppFonts.panelAttributeLight,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showErrorFlushBar(String errorMessage) {
    FlushbarFactory.warningFlushBar(message: errorMessage).show(context);
  }

  Future<bool> _sendEmail(BuildContext context, String email) async {
    final isConnected = await sl<ConnectionService>().isConnected;
    if (!isConnected) {
      _showErrorFlushBar(Lang.notConnected);
      return false;
    }
    final rawEmails = await sl<SupabaseClient>().from('user').select('email');
    final emails = rawEmails.map((e) => e['email'] as String).toList();
    if (!emails.contains(email)) {
      _showErrorFlushBar(Lang.emailMustBeRegistered);
      return false;
    }
    final rawPromoEmails = await sl<SupabaseClient>().from('promo').select('email');
    final promoEmails = rawPromoEmails.map((e) => e['email'] as String).toList();
    if (promoEmails.contains(email)) {
      _showErrorFlushBar(Lang.emailIsUsedInCampaign);
      return false;
    }
    await sl<SupabaseClient>().from('promo').insert(
      {
        'id': sl<Uuid>().v4(),
        'email': email,
        'promocode': _getRandomString(7),
      },
    );
    AnalyticsService.emailAdded(email);
    return true;
  }

  String _getRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
