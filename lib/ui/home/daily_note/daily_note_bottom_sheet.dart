import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/data/journal/data.dart';

import '../../../get_it_conf.dart';
import 'daily_note_bloc.dart';

class DailyNoteBottomSheet extends StatefulWidget {
  const DailyNoteBottomSheet({required this.todayEntry, super.key});

  final JournalEntry? todayEntry;

  @override
  State<DailyNoteBottomSheet> createState() => _DailyNoteBottomSheetState();
}

class _DailyNoteBottomSheetState extends State<DailyNoteBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todayEntry?.title ?? '');
    _contentController = TextEditingController(text: widget.todayEntry?.content ?? '');
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
      create: (context) => getIt<DailyNoteBloc>()
        ..add(DailyNoteEventInit(
          id: widget.todayEntry?.id,
          title: widget.todayEntry?.title,
          content: widget.todayEntry?.content,
        )),
      child: BlocConsumer<DailyNoteBloc, DailyNoteState>(
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
                        onChanged: (value) => context.read<DailyNoteBloc>().add(UpdateTitleEvent(title: value)),
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
                        onChanged: (value) => context.read<DailyNoteBloc>().add(UpdateContentEvent(content: value)),
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
                                  if (state.id == null) {
                                    context.read<DailyNoteBloc>().add(SubmitEvent(context: context));
                                  } else {
                                    context.read<DailyNoteBloc>().add(UpdateEvent());
                                  }
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(state.id == null ? 'Save' : 'Update'),
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
