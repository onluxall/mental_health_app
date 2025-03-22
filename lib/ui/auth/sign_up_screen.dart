import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/auth/auth_bloc/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (name) => context.read<AuthBloc>().add(AuthEventChangeName(name: name)),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (email) => context.read<AuthBloc>().add(AuthEventChangeEmail(email: email)),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (password) => context.read<AuthBloc>().add(AuthEventChangePassword(password: password)),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventSignUp());
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventChangeScreen(screenIndex: 1));
              },
              child: const Text("I don't have an account"),
            ),
          ],
        ),
      ),
    );
  }
}
