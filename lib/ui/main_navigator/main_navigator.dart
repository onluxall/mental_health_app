import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mental_health_app/ui/home/home_screen.dart';
import 'package:mental_health_app/ui/main_navigator/main_navigator_cubit.dart';

import '../../get_it_conf.dart';
import '../journal/journal_bloc/journal_screen.dart';
import '../quiz/quiz_screen.dart';
import '../task/task_screen.dart';
import '../therapist_chat/therapist_chat_screen.dart';

class MainNavigator extends StatelessWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainNavigatorCubit>(
      create: (context) => getIt.get<MainNavigatorCubit>()..init(),
      child: BlocConsumer<MainNavigatorCubit, MainNavigatorState>(listener: (context, state) {
        if (state.userData?.quizCompleted != true && state.isLoading == false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const QuizScreen(),
            ),
          );
        }
      }, builder: (context, state) {
        if (state.isLoading || state.userData?.quizCompleted != true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _buildChildPage(index: state.currentIndex),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                child: GNav(
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 200),
                  tabBackgroundColor: const Color(0xFFEDE7F6),
                  color: Colors.black,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      onPressed: () {
                        context.read<MainNavigatorCubit>().changePage(0);
                      },
                    ),
                    GButton(
                      icon: Icons.edit_note,
                      text: 'Journal',
                      onPressed: () {
                        context.read<MainNavigatorCubit>().changePage(1);
                      },
                    ),
                    GButton(
                      icon: Icons.chat,
                      text: 'Chat',
                      onPressed: () {
                        context.read<MainNavigatorCubit>().changePage(2);
                      },
                    ),
                    GButton(
                      icon: Icons.assignment_turned_in,
                      text: 'Tasks',
                      onPressed: () {
                        context.read<MainNavigatorCubit>().changePage(3);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChildPage({required int index}) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const JournalScreen();
      case 2:
        return const TherapistScreen();
      case 3:
        return const TaskScreen();
      default:
        return Container();
    }
  }
}
