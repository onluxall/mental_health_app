import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/home/slider_widget.dart';

import '../../get_it_conf.dart';
import 'daily_note/daily_note_bottom_sheet.dart';
import 'home_bloc.dart';

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
          return state.isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
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
                                              });
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
                  ),
                );
        },
      ),
    );
  }
}
