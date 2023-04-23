import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum HomeNavigationState { home, productDetail }

class HomeNavigationCubit extends Cubit<int> {
  HomeNavigationCubit() : super(0);

  void navigate(HomeNavigationState navState) {
    int index;
    switch (navState) {
      case HomeNavigationState.home:
        index = 0;
        break;
      case HomeNavigationState.productDetail:
        index = 1;
        break;

      default:
        index = 0;
    }

    emit(index);
  }
}
