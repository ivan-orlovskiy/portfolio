import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/employer_vacancies_bloc/employer_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/pages/employer/vacancies_page.dart';
import 'package:swipehr/src/presentation/pages/shared/settings_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/bottom_nav_button.dart';

class MainEmployerScreen extends StatefulWidget {
  const MainEmployerScreen({super.key});

  @override
  State<MainEmployerScreen> createState() => _MainEmployeeScreenState();
}

class _MainEmployeeScreenState extends State<MainEmployerScreen> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EmployerVacanciesBloc>()..add(const EmployerVacanciesLoad()),
        ),
      ],
      child: const VacanciesPage(),
    ),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    return _pages[_currentPage];
  }

  Widget _buildBottomNavBar() {
    var additionalPadding = 0.0;
    if (MediaQuery.of(context).padding.bottom > 0) {
      additionalPadding = 20;
    }
    return Container(
      padding: EdgeInsets.only(bottom: additionalPadding),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: SwipeHrColors.secondary.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, -3),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: kBottomNavigationBarHeight + additionalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomNavButton(
            icon: Ionicons.list,
            isCurrent: _currentPage == 0,
            onPressed: () {
              setState(() {
                _currentPage = 0;
              });
            },
          ),
          const SizedBox(width: 40),
          BottomNavButton(
            icon: Ionicons.settings,
            isCurrent: _currentPage == 1,
            onPressed: () {
              setState(() {
                _currentPage = 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
