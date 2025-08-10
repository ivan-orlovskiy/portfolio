import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper/src/blocs/cards_tab_bloc/cards_tab_bloc.dart';
import 'package:shopper/src/blocs/shopping_list_tab_bloc/shopping_list_tab_bloc.dart';
import 'package:shopper/src/blocs/version_control/verison_control_cubit.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/ui/dialogs/update/update_dialog_non_strict.dart';
import 'package:shopper/src/ui/dialogs/update/update_dialog_strict.dart';
import 'package:shopper/src/ui/pages/cards_tab/cards_tab.dart';
import 'package:shopper/src/ui/pages/lists_tab/shopping_lists_tab.dart';
import 'package:shopper/src/ui/pages/settings_tab/settings_tab.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _tabWidgets = [
    BlocProvider.value(
      value: sl<ShoppingListTabBloc>(),
      child: const ShoppingListsTab(key: ValueKey(0)),
    ),
    BlocProvider.value(
      value: sl<CardsTabBloc>(),
      child: const CardsTab(
        key: ValueKey(1),
      ),
    ),
    const SettingsTab(key: ValueKey(2)),
  ];

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerisonControlCubit, VerisonControlState>(
      listenWhen: (previous, current) => previous is VersionUnchecked && current is VersionChecked,
      listener: (context, state) {
        if (state is VersionChecked) {
          showDialog(
            barrierDismissible: !state.isStrict,
            useSafeArea: false,
            barrierColor: AppColors.bgDialog.withOpacity(0.7),
            context: context,
            builder: (_) =>
                state.isStrict ? const UpdateDialogStrict() : const UpdateDialogNonStrict(),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.bgLight,
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
      child: _tabWidgets[_selectedTabIndex],
    );
  }

  Widget _buildBottomNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton('assets/icons/lists.svg', 0),
        _buildButton('assets/icons/creditcard.svg', 1),
        _buildButton('assets/icons/settings.svg', 2),
      ],
    );
  }

  Widget _buildButton(String assetName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: CircleAvatar(
        radius: 27,
        backgroundColor: Colors.transparent,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            _selectedTabIndex == index ? AppColors.accentLight : AppColors.weakLight,
            BlendMode.srcIn,
          ),
          child: ThemedIcon(assetName: assetName),
        ),
      ),
    );
  }
}
