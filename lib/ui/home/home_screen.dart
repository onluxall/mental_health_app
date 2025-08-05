import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/home/emotions_slider/emotions_slider_widget.dart';
import 'package:mental_health_app/ui/main_navigator/main_navigator_cubit.dart';

import '../../data/activity/data.dart';
import '../../get_it_conf.dart';
import '../../widgets/activity_details_sheet.dart';
import 'bloc/home_bloc.dart';
import 'daily_note/daily_note_bottom_sheet.dart';

enum ActivityCategory {
  mindfulness,
  creative,
  social,
  active,
}

Color getCategoryColor(ActivityCategory category) {
  switch (category) {
    case ActivityCategory.mindfulness:
      return Colors.purple;
    case ActivityCategory.creative:
      return Colors.red;
    case ActivityCategory.social:
      return Colors.blue;
    case ActivityCategory.active:
      return Colors.green;
  }
}

final List<Map<String, dynamic>> _recommendedActivities = [
  {
    'title': 'Morning Meditation',
    'duration': '10 min',
    'note': 'Start your day with mindfulness',
    'icon': Icons.favorite,
  },
  {
    'title': 'Evening Journal',
    'duration': '15 min',
    'note': 'Reflect on your day',
    'icon': Icons.book,
  },
];

void _showActivityDetails(
  BuildContext context, {
  required String title,
  required String note,
  required String duration,
  required IconData icon,
  required Color color,
  required Function(String note, String duration) onSave,
  required Function() goToChat,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ActivityDetailsSheet(
      title: title,
      note: note,
      duration: duration,
      icon: icon,
      color: color,
      onSave: onSave,
      goToChat: goToChat,
    ),
  );
}

Widget _buildActivityCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Color color,
  required Function() goToChat,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey.shade200,
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showActivityDetails(
            context,
            title: title,
            note: 'A calming practice to help you find peace and clarity in your daily life.',
            duration: '10 min',
            icon: icon,
            color: color,
            onSave: (note, duration) {
              context.read<HomeBloc>().add(
                    HomeEventAddActivity(
                      activity: Activity(
                        createdAt: Timestamp.now(),
                        title: title,
                        note: note,
                        duration: duration,
                      ),
                    ),
                  );
            },
            goToChat: goToChat,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => getIt.get<HomeBloc>()..add(HomeEventInit()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (blocContext, state) {
          if (state.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting()}, ${state.user?.name ?? ''}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Visibility(
                              visible: state.quote?.text != null && state.quote?.author != null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    state.quote?.text ?? "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(state.quote?.author ?? ""),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return DailyNoteBottomSheet(
                                                todayEntry: state.todayJournalEntry,
                                              );
                                            },
                                          );
                                        },
                                        child: Text(state.todayJournalEntry != null ? 'Edit Daily Note' : 'Create Daily Note'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            EmotionsSliderWidget(initialEmotionData: state.todayEmotionData),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                        child: Text(
                          'All Activities',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          children: activities
                              .map(
                                (activity) => _buildActivityCard(context,
                                    icon: getCategoryIcon(activity.type),
                                    title: activity.title,
                                    color: activity.color,
                                    goToChat: () => context.read<MainNavigatorCubit>().changePage(2)),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
