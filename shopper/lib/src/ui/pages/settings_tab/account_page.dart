import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/blocs/app_bloc/app_bloc.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/dialogs/service/contact_us_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/recovery_flow/logged_recovery_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/settings_button.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
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
        _buildInfoTable(),
        const SizedBox(height: 10),
        _buildActions(context),
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
              Lang.account,
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 150,
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
                  '${Lang.nickname}:',
                  style: AppFonts.panelSmallLight,
                ),
                const SizedBox(height: 3),
                Text(
                  sl<AuthenticationService>().userNickname,
                  style: AppFonts.panelTitleLight,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Lang.email}:',
                  style: AppFonts.panelSmallLight,
                ),
                const SizedBox(height: 3),
                Text(
                  sl<AuthenticationService>().userEmail,
                  style: AppFonts.panelTitleLight,
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '${Lang.subscription}:',
            //       style: AppFonts.panelSmallLight,
            //     ),
            //     const SizedBox(height: 3),
            //     Text(
            //       Lang.trial,
            //       style: AppFonts.panelTitleLight,
            //     ),
            //   ],
            // ),
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
            title: Lang.changePassword,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoggedRecoveryPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          SettingsButton(
            title: Lang.requestDataDeletion,
            onPressed: () {
              showDialog(
                useSafeArea: false,
                barrierColor: AppColors.bgDialog.withOpacity(0.7),
                context: context,
                builder: (_) => const ContactUsDialog(),
              );
            },
          ),
          const SizedBox(height: 12),
          SettingsButton(
            title: Lang.signOutFromAccount,
            onPressed: () async {
              final confirmed = await showDialog(
                useSafeArea: false,
                barrierColor: AppColors.bgDialog.withOpacity(0.7),
                context: context,
                barrierDismissible: false,
                builder: (_) => ConfirmationDialog(message: Lang.signOut),
              );
              if (confirmed == null || !confirmed) {
                return;
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              BlocProvider.of<AppBloc>(context).add(const AppSignOut());
            },
          ),
          // const SizedBox(height: 12),
          // SettingsButton(
          //   title: Lang.declineSub,
          //   onPressed: () async {
          //     final confirmed = await showDialog(
          //       useSafeArea: false,
          //       barrierColor: AppColors.bgDialog.withOpacity(0.7),
          //       context: context,
          //       builder: (_) =>
          //           ConfirmationDialog(message: '${Lang.declineSub}?'),
          //     );
          //     if (confirmed == null || !confirmed) {
          //       return;
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
