import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/inputs/input_field.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class SignUpPage extends StatefulWidget {
  final bool isEmployee;
  const SignUpPage({
    Key? key,
    required this.isEmployee,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

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
            // const SizedBox(width: 10),
            PageText('${Lang.signUp} | ${widget.isEmployee ? Lang.employee : Lang.employer}'),
            // const SizedBox(width: 10),
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Ionicons.chevron_back,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        Column(
          children: [
            InputField(
              title: Lang.email,
              hintText: Lang.email,
              controller: _emailController,
              validator: (value) {
                if (value == 'fuck') return 'fuck you';
                return null;
              },
            ),
            if (!widget.isEmployee) const SizedBox(height: 30),
            if (!widget.isEmployee)
              InputField(
                title: Lang.companyName,
                hintText: Lang.companyName,
                controller: _companyController,
                validator: (value) {
                  if (value == 'fuck') return 'fuck you';
                  return null;
                },
              ),
            const SizedBox(height: 30),
            InputField(
              title: Lang.password,
              hintText: Lang.password,
              controller: _passwordController,
              validator: (value) {
                if (value == 'fuck') return 'fuck you';
                return null;
              },
            ),
          ],
        ),
        Column(
          children: [
            ActionButton(
              text: Lang.signUp,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                BlocProvider.of<AuthBloc>(context).add(
                  AuthSignUp(
                    widget.isEmployee,
                    _emailController.text,
                    _passwordController.text,
                    _companyController.text,
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
