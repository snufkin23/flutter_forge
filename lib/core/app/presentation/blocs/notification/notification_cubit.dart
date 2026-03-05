// notification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/notifications/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'notification_cubit.freezed.dart';
part 'notification_state.dart';

@lazySingleton
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._notificationService)
      : super(const NotificationState());

  final NotificationService _notificationService;

  // ── Check if enabled ──────────────────────────────────────────
  Future<void> checkStatus() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final bool? enabled =
          await _notificationService.areNotificationsEnabled();
      emit(
        state.copyWith(
          isLoading: false,
          status: enabled == true
              ? NotificationStatus.enabled
              : NotificationStatus.disabled,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Show instantly ────────────────────────────────────────────
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _notificationService.showNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Schedule at datetime ──────────────────────────────────────
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _notificationService.scheduleNotification(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      );
      await refreshPending();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Schedule daily ────────────────────────────────────────────
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDayValue time,
    String? payload,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _notificationService.scheduleDailyNotification(
        id: id,
        title: title,
        body: body,
        time: time,
        payload: payload,
      );
      await refreshPending();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Schedule weekly ───────────────────────────────────────────
  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required TimeOfDayValue time,
    String? payload,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _notificationService.scheduleWeeklyNotification(
        id: id,
        title: title,
        body: body,
        weekday: weekday,
        time: time,
        payload: payload,
      );
      await refreshPending();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── Refresh pending list ──────────────────────────────────────
  Future<void> refreshPending() async {
    final List<PendingNotificationRequest> pending =
        await _notificationService.getPendingNotifications();
    emit(state.copyWith(pending: pending));
  }

  // ── Cancel single ─────────────────────────────────────────────
  Future<void> cancel(int id) async {
    await _notificationService.cancelNotification(id);
    await refreshPending();
  }

  // ── Cancel all ────────────────────────────────────────────────
  Future<void> cancelAll() async {
    await _notificationService.cancelAllNotifications();
    emit(state.copyWith(pending: <PendingNotificationRequest>[]));
  }
}
