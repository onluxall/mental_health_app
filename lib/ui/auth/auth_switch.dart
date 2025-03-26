import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/auth/log_in_screen.dart';
import 'package:mental_health_app/ui/auth/sign_up_screen.dart';
import 'package:mental_health_app/ui/main_navigator/main_navigator.dart';

import '../../get_it_conf.dart';
import 'auth_bloc/auth_bloc.dart';

class AuthSwitch extends StatelessWidget {
  const AuthSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthBloc>(
        create: (context) => getIt.get<AuthBloc>()..add(AuthEventInit()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return state.isLoggedIn
              ? const MainNavigator()
              : state.chosenScreen == 0
                  ? const SignUpScreen()
                  : const LogInScreen();
        }),
      ),
    );
  }
}
