import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';

class ContactUsDialog extends StatelessWidget {
  const ContactUsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  Lang.contactUs,
                  style: AppFonts.panelTitleLight,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                Text(
                  Lang.tapEmailToCopy,
                  style: AppFonts.panelAttributeLight,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: Lang.ourEmail));
                    if (!context.mounted) return;
                    _showSuccessFlushBar(context, Lang.copied);
                  },
                  child: Text(
                    Lang.ourEmail,
                    style: AppFonts.panelTitleLight,
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  title: Lang.iCopiedEmail,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessFlushBar(BuildContext context, String successMessage) {
    FlushbarFactory.successFlushBar(message: successMessage).show(context);
  }
}
