import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mental_health_app/ui/home/home_screen.dart';
import 'package:mental_health_app/ui/main_navigator/main_navigator_cubit.dart';

import '../journal/journal_screen.dart';
import '../therapist_chat/therapist_chat_screen.dart';

class MainNavigator extends StatelessWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainNavigatorCubit>(
      create: (context) => MainNavigatorCubit(),
      child: BlocBuilder<MainNavigatorCubit, int>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: _buildChildPage(index: state),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.4),
                    offset: Offset(0, 25),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 200),
                  tabBackgroundColor: Colors.grey[100]!,
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
        return HomeScreen();
      case 1:
        return JournalScreen();
      case 2:
        return TherapistScreen();
      case 3:
        return Scaffold(
          body: Center(
            child: Text("Tasks"),
          ),
        );
      default:
        return Container();
    }
  }
}
