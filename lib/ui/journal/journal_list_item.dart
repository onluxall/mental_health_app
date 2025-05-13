import 'package:flutter/material.dart';

import '../../data/journal/data.dart';
import 'journal_entry_edit_bottom_sheet/journal_entry_edit_bottom_sheet.dart';

class JournalListItem extends StatelessWidget {
  const JournalListItem({required this.journalEntry, super.key});

  final JournalEntry journalEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journalEntry.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    journalEntry.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return JournalEntryEditBottomSheet(entry: journalEntry);
                      });
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
