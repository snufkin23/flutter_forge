import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/constants/app_constants.dart';
import 'package:flutter_forge/core/storage/local_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_cubit.freezed.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._storage) : super(const OnboardingState());

  final LocalStorage _storage;
  static const int _totalPages = 3;

  Future<void> checkStatus() async {
    final bool completed =
        _storage.get<bool>(AppConstants.onboardingKey) ?? false;
    emit(
      state.copyWith(
        status: completed
            ? OnboardingStatus.completed
            : OnboardingStatus.notCompleted,
      ),
    );
  }

  void nextPage() {
    if (state.currentPage < _totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < _totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  Future<void> completeOnboarding() async {
    await _storage.put<bool>(AppConstants.onboardingKey, true);
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
