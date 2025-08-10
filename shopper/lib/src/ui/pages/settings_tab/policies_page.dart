import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/settings_button.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({
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
        _buildActions(),
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
              'Policies',
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SettingsButton(
            title: 'Privacy policy',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          SettingsButton(
            title: 'Confirmations',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          SettingsButton(
            title: 'Terms & conditions',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
