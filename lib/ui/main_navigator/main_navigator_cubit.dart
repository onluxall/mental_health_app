import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/interface.dart';

import '../../data/user/data.dart';

@Injectable()
class MainNavigatorCubit extends Cubit<MainNavigatorState> {
  MainNavigatorCubit(this.userRepo, this.auth) : super(const MainNavigatorState(currentIndex: 0, isLoading: true));

  final IUserRepo userRepo;
  final FirebaseAuth auth;

  void init() async {
    final userId = auth.currentUser?.uid;
    await userRepo.getUser(id: userId ?? "").then((user) {
      if (user != null) {
        emit(MainNavigatorState(currentIndex: state.currentIndex, userData: user));
      }
    });
  }

  void changePage(int index) {
    emit(MainNavigatorState(currentIndex: index, userData: state.userData));
  }
}

class MainNavigatorState extends Equatable {
  final int currentIndex;
  final UserData? userData;
  final bool isLoading;

  const MainNavigatorState({required this.currentIndex, this.userData, this.isLoading = false});

  @override
  List<Object?> get props => [
        currentIndex,
        userData,
        isLoading,
      ];
}
