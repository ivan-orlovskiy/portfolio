import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:swipehr/src/presentation/pages/shared/welcome_page.dart';
import 'package:swipehr/src/presentation/screens/main_employee_screen.dart';
import 'package:swipehr/src/presentation/screens/main_employer_screen.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state) {
          case AuthLoggedOut _:
            {
              return const WelcomePage();
            }
          case AuthLoggedIn state:
            {
              if (state.isEmployee) {
                return const MainEmployeeScreen();
              } else {
                return const MainEmployerScreen();
              }
            }
          case AuthError _:
            {
              return const WelcomePage();
            }
          case AuthLoading _:
            {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: SwipeHrColors.secondary,
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
