import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/app.dart';
import 'package:shopper/src/ui/dialogs/service/report_bug_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/settings_button.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTitle(context),
        const SizedBox(height: 10),
        _buildInfoTable(context),
        const SizedBox(height: 10),
        _buildActions(context),
        Expanded(child: _buildMyLabel(context)),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ThemedIcon(
                    assetName: 'assets/icons/back.svg',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              Lang.aboutTheApp,
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTable(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.panelLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.appMadeBy,
                  style: AppFonts.panelTitleLight,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Lang.contactEmail}:',
                  style: AppFonts.panelSmallLight,
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(const ClipboardData(text: 'app.shopper@gmail.com'));
                    if (!context.mounted) return;
                    _showSuccessFlushBar(context, Lang.copied);
                  },
                  child: Text(
                    Lang.ourEmail,
                    style: AppFonts.panelTitleLight,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Lang.version}:',
                  style: AppFonts.panelSmallLight,
                ),
                const SizedBox(height: 3),
                Text(
                  App.appVersion,
                  style: AppFonts.panelTitleLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SettingsButton(
            title: Lang.reportBug,
            onPressed: () {
              showDialog(
                useSafeArea: false,
                barrierColor: AppColors.bgDialog.withOpacity(0.7),
                context: context,
                builder: (_) => const ReportBugDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyLabel(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }

  void _showSuccessFlushBar(BuildContext context, String successMessage) {
    FlushbarFactory.successFlushBar(message: successMessage).show(context);
  }
}
