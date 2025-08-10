import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/shared/choose_role_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageText(Lang.welcomePageTitle),
        SvgPicture.asset('assets/images/welcome_logo.svg'),
        Column(
          children: [
            SmallText(Lang.signInOrSignUp),
            const SizedBox(height: 10),
            ActionButton(
              text: Lang.haveAccount,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseRolePage(isSignIn: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ActionButtonSecondary(
              text: Lang.noAccount,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseRolePage(isSignIn: false),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
