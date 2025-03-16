import 'package:flutter/cupertino.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Journal'),
      ),
      child: Center(
        child: Text(
          'Journal Screen - Coming Soon',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
    );
  }
} 