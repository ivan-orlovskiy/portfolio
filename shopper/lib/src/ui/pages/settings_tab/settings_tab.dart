import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/settings_tab/about_page.dart';
import 'package:shopper/src/ui/pages/settings_tab/account_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/settings_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildSettings(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Lang.settings,
          style: AppFonts.pageTitleLight,
        ),
      ],
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SettingsButton(
              title: Lang.accAndSub,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SettingsButton(
              title: Lang.watchTutorials,
              onPressed: () async {
                Tutorials.runAllTutorials(context);
              },
            ),
            const SizedBox(height: 12),
            SettingsButton(
              title: Lang.privacyPolicy,
              onPressed: () async {
                final Uri url = Uri.parse(
                    'https://docs.google.com/document/d/1oD1mLn4vPZNofi5bNFzVGunoiV3bjSlqd4e28ooJ4hs/edit?usp=sharing');
                if (!await launchUrl(url, mode: LaunchMode.inAppWebView) &&
                    context.mounted) {
                  FlushbarFactory.warningFlushBar(
                    message: Lang.cantOpenResource,
                  ).show(context);
                }
              },
            ),
            const SizedBox(height: 12),
            SettingsButton(
              title: Lang.aboutTheApp,
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 8.0),
        //   child: _SettingsButtonOutlined(
        //     title: Lang.buySub,
        //     onPressed: () async {
        //       final result = await showModalBottomSheet(
        //         isScrollControlled: true,
        //         showDragHandle: true,
        //         enableDrag: true,
        //         shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20),
        //           ),
        //         ),
        //         backgroundColor: AppColors.bgLight,
        //         barrierColor: AppColors.bgDialog.withOpacity(0.7),
        //         context: context,
        //         builder: (context) => const EmailCampaign(),
        //       );

        //       if (result is bool && result && context.mounted) {
        //         _showSuccessFlushBar(context, Lang.success);
        //       }
        //     },
        //   ),
        // ),
      ],
    );
  }

  // void _showSuccessFlushBar(BuildContext context, String successMessage) {
  //   FlushbarFactory.successFlushBar(message: successMessage).show(context);
  // }
}

// class _SettingsButtonOutlined extends StatelessWidget {
//   final String title;
//   final VoidCallback onPressed;

//   const _SettingsButtonOutlined({
//     required this.title,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 55,
//         padding: const EdgeInsets.symmetric(horizontal: 18.5),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: AppColors.accentLight,
//             width: 1.5,
//           ),
//           color: AppColors.bgLight,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: AppFonts.panelTitleLight,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
