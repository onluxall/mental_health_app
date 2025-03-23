import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_bloc/auth_bloc.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<AuthBloc>().add(AuthEventChangeEmail(email: value));
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<AuthBloc>().add(AuthEventChangePassword(password: value));
                },
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventLogIn());
                },
                child: const Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventChangeScreen(screenIndex: 0));
                },
                child: const Text("I don't have an account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
