import 'package:flutter/cupertino.dart';
import '../widgets/activity_note_panel.dart';
import '../services/app_data_service.dart';

class EditNoteScreen extends StatefulWidget {
  final ActivityNote note;
  final Function(ActivityNote) onSave;
  final Function(ActivityNote) onDelete;

  const EditNoteScreen({
    super.key,
    required this.note,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _noteController;
  late double _selectedDuration;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note.note);
    _selectedDuration = double.parse(widget.note.duration.split(' ')[0]);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _getDurationText(double value) {
    return '${value.round()} min';
  }

  void _saveNote() {
    final updatedNote = ActivityNote(
      title: widget.note.title,
      note: _noteController.text,
      duration: _getDurationText(_selectedDuration),
      icon: widget.note.icon,
      color: widget.note.color,
      timestamp: DateTime.now(),
    );
    widget.onSave(updatedNote);
    Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AppDataService.instance.deleteActivityNote(widget.note.timestamp);
      widget.onDelete(widget.note);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Edit ${widget.note.title}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _deleteNote,
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.destructiveRed,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.note.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.note.icon,
                      size: 24,
                      color: widget.note.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.note.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      child: SafeArea(
                        top: false,
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          scrollController: FixedExtentScrollController(
                            initialItem: (_selectedDuration / 5).round() - 1,
                          ),
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              _selectedDuration = (selectedItem + 1) * 5.0;
                            });
                          },
                          children: List<Widget>.generate(12, (int index) {
                            final duration = (index + 1) * 5;
                            return Center(child: Text('$duration min'));
                          }),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.note.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.note.color.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getDurationText(_selectedDuration),
                        style: TextStyle(
                          fontSize: 17,
                          color: widget.note.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        CupertinoIcons.time,
                        color: widget.note.color,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Note',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _noteController,
                placeholder: 'How are you feeling?',
                placeholderStyle: TextStyle(
                  color: CupertinoColors.systemGrey.resolveFrom(context),
                ),
                maxLines: 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 