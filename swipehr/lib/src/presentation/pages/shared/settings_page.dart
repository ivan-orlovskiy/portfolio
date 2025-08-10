import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: PageText('Settings'),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ActionButton(
                text: 'Log out',
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(const AuthSignOut());
                }),
          ),
        ],
      ),
    );
  }
}
