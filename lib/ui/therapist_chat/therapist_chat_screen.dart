import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TherapistScreen extends StatelessWidget {
  const TherapistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Therapist'),
      ),
      child: Center(
        child:
               Text(
                 'Loading...',
              ),
      ),
    );
  }
}

