import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/auth/log_in_screen.dart';
import 'package:mental_health_app/ui/auth/sign_up_screen.dart';
import 'package:mental_health_app/ui/home/home_screen.dart';

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
              ? HomeScreen()
              : state.chosenScreen == 0
                  ? SignUpScreen()
                  : LogInScreen();
        }),
      ),
    );
  }
}
