import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/journal/journal_entry_edit_bottom_sheet/edit_journal_entry_bloc.dart';

import '../../../data/journal/data.dart';
import '../../../get_it_conf.dart';

class JournalEntryEditBottomSheet extends StatefulWidget {
  const JournalEntryEditBottomSheet({super.key, required this.entry});

  final JournalEntry entry;

  @override
  State<JournalEntryEditBottomSheet> createState() => _JournalEntryEditBottomSheetState();
}

class _JournalEntryEditBottomSheetState extends State<JournalEntryEditBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditJournalEntryBloc>()
        ..add(
          EditJournalEntryEventInit(
            title: widget.entry.title,
            content: widget.entry.content,
          ),
        ),
      child: BlocConsumer<EditJournalEntryBloc, EditJournalEntryState>(
        listener: (context, state) {
          if (state.navigateBack) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        onChanged: (value) => context.read<EditJournalEntryBloc>().add(
                              EditJournalEntryEventUpdateTitle(title: value),
                            ),
                        decoration: InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorText: state.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        onChanged: (value) => context.read<EditJournalEntryBloc>().add(
                              EditJournalEntryEventUpdateContent(content: value),
                            ),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Content",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<EditJournalEntryBloc>().add(
                                        EditJournalEntryEventSaveEntry(id: widget.entry.id ?? ''),
                                      );
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
