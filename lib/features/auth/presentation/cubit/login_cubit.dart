import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<bool> {
  LoginCubit() : super(false);

  Future<void> login() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(true);
  }
}
