import 'package:flutter/cupertino.dart';

class TherapistScreen extends StatelessWidget {
  const TherapistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Therapist'),
      ),
      child: Center(
        child: Text(
          'Loading...',
        ),
      ),
    );
  }
}
