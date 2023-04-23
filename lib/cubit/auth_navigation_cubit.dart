import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum AuthNavigationState { login, signup, home, productDetail }

class AuthNavigationCubit extends Cubit<int> {
  AuthNavigationCubit() : super(0);

  void navigate(AuthNavigationState navState) {
    int index;
    switch (navState) {
      case AuthNavigationState.login:
        index = 0;
        break;
      case AuthNavigationState.signup:
        index = 1;
        break;
      case AuthNavigationState.home:
        index = 2;
        break;
      case AuthNavigationState.productDetail:
        index = 3;
        break;

      default:
        index = 0;
    }

    emit(index);
  }
}
