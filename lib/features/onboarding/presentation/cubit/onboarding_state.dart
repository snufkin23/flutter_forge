part of 'onboarding_cubit.dart';

enum OnboardingStatus { initial, completed, notCompleted }

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStatus.initial) OnboardingStatus status,
    @Default(0) int currentPage,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get isInitial => status == OnboardingStatus.initial;
  bool get isCompleted => status == OnboardingStatus.completed;
  bool get isNotCompleted => status == OnboardingStatus.notCompleted;
}
