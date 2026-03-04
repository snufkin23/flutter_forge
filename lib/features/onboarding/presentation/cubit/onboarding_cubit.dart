import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/constants/app_constants.dart';
import 'package:flutter_forge/core/storage/local_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit(this._storage) : super(false);
  final LocalStorage _storage;

  Future<void> checkStatus() async {
    final bool completed = _storage.get<bool>(AppConstants.onboardingKey) ?? false;
    emit(completed);
  }

  Future<void> completeOnboarding() async {
    await _storage.put<bool>(AppConstants.onboardingKey, true);
    emit(true);
  }
}
