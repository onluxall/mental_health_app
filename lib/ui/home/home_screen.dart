import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/home/slider_widget.dart';

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
    ),
  );
}

Widget _buildActivityCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Color color,
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
        builder: (context, state) {
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
                child: CustomScrollView(
                  slivers: [
                    // Greeting, quote, and mood slider
                    SliverToBoxAdapter(
                      child: Padding(
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
                            SliderWidget(
                              value: state.mood ?? 3.0,
                              onChanged: (value) {
                                context.read<HomeBloc>().add(HomeEventChangeMood(mood: value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Recommended Activities Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommended Activities',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all activities
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final activity = _recommendedActivities[index];
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
                                      title: activity['title'],
                                      note: activity['note'],
                                      duration: activity['duration'],
                                      icon: activity['icon'],
                                      color: Theme.of(context).primaryColor,
                                      onSave: (note, duration) {
                                        context.read<HomeBloc>().add(
                                              HomeEventAddActivity(
                                                activity: Activity(
                                                  createdAt: Timestamp.now(),
                                                  title: activity['title'],
                                                  note: note,
                                                  duration: duration,
                                                  isRecommended: true,
                                                ),
                                              ),
                                            );
                                      },
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          activity['icon'],
                                          size: 32,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        activity['title'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        activity['note'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          activity['duration'],
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _recommendedActivities.length,
                        ),
                      ),
                    ),

                    // All Activities Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'All Activities',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all activities
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildListDelegate([
                          _buildActivityCard(
                            context,
                            icon: Icons.favorite,
                            title: 'Meditation',
                            color: getCategoryColor(ActivityCategory.mindfulness),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.book,
                            title: 'Journaling',
                            color: getCategoryColor(ActivityCategory.mindfulness),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.air,
                            title: 'Breathing',
                            color: getCategoryColor(ActivityCategory.mindfulness),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.music_note,
                            title: 'Music',
                            color: getCategoryColor(ActivityCategory.creative),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.sports_basketball,
                            title: 'Exercise',
                            color: getCategoryColor(ActivityCategory.active),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.nightlight_round,
                            title: 'Sleep',
                            color: getCategoryColor(ActivityCategory.mindfulness),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.people,
                            title: 'Social',
                            color: getCategoryColor(ActivityCategory.social),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.brush,
                            title: 'Art',
                            color: getCategoryColor(ActivityCategory.creative),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.wb_sunny,
                            title: 'Nature',
                            color: getCategoryColor(ActivityCategory.active),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.chat,
                            title: 'Therapy',
                            color: getCategoryColor(ActivityCategory.social),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.sports_esports,
                            title: 'Games',
                            color: getCategoryColor(ActivityCategory.active),
                          ),
                          _buildActivityCard(
                            context,
                            icon: Icons.favorite_border,
                            title: 'Self Care',
                            color: getCategoryColor(ActivityCategory.mindfulness),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
