import 'package:flutter/cupertino.dart';

class ActivityDetailsSheet extends StatefulWidget {
  final String title;
  String note;
  final String duration;
  final IconData icon;
  final Color color;
  final Function(String note, String duration) onSave;

  ActivityDetailsSheet({
    super.key,
    required this.title,
    this.note = '',
    required this.duration,
    required this.icon,
    required this.color,
    required this.onSave,
  });

  @override
  State<ActivityDetailsSheet> createState() => _ActivityDetailsSheetState();
}

class _ActivityDetailsSheetState extends State<ActivityDetailsSheet> {
  late double _selectedDuration;
  final TextEditingController _noteController = TextEditingController();
  String _activityNote = '';

  @override
  void initState() {
    super.initState();
    // Convert duration string (e.g., "10 min") to double
    _selectedDuration = double.parse(widget.duration.split(' ')[0]);
    _activityNote = widget.note;
    _noteController.text = _activityNote;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _getDurationText(double value) {
    return '${value.round()} min';
  }

  void _startActivity() {
    widget.note = _activityNote;
    widget.onSave(_activityNote, _getDurationText(_selectedDuration));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7 + bottomPadding,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.icon,
                          size: 24,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getDurationText(_selectedDuration),
                              style: TextStyle(
                                fontSize: 15,
                                color: CupertinoColors.systemGrey.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: 1,
                  color: CupertinoColors.systemGrey5,
                ),
                
                // Duration Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.color.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getDurationText(_selectedDuration),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: widget.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.time,
                                color: widget.color,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: 1,
                  color: CupertinoColors.systemGrey5,
                ),
                
                // Note Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        onChanged: (value) {
                          setState(() {
                            _activityNote = value;
                          });
                        },
                        maxLines: 3,
                        decoration: null,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        autofocus: false,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Start Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoButton.filled(
                    onPressed: _startActivity,
                    child: const Text('Start Activity'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 