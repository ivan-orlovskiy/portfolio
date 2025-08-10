import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/shared/sign_in_page.dart';
import 'package:swipehr/src/presentation/pages/shared/sign_up_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class ChooseRolePage extends StatelessWidget {
  final bool isSignIn;
  const ChooseRolePage({
    Key? key,
    required this.isSignIn,
  }) : super(key: key);

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Ionicons.chevron_back,
                  color: SwipeHrColors.text,
                ),
              ),
            ),
            // const SizedBox(width: 30),
            PageText(Lang.whatIsYourRole),
            // const SizedBox(width: 30),
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Ionicons.chevron_back,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        SvgPicture.asset('assets/images/welcome_logo.svg'),
        Column(
          children: [
            SmallText(Lang.chooseYourRole),
            const SizedBox(height: 10),
            ActionButton(
              text: Lang.iEmployee,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isSignIn
                        ? const SignInPage(isEmployee: true)
                        : const SignUpPage(isEmployee: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ActionButton(
              text: Lang.iEmployer,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isSignIn
                        ? const SignInPage(isEmployee: false)
                        : const SignUpPage(isEmployee: false),
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
