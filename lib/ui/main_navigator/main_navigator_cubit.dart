import 'package:bloc/bloc.dart';

class MainNavigatorCubit extends Cubit<int> {
  MainNavigatorCubit() : super(0);

  void changePage(int index) {
    emit(index);
  }
}
