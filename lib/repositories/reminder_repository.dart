import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/reminder.dart';
import '../models/serializable/reminder_dto.dart';

/// Repository for reminder operations
class ReminderRepository {
  final RestClient _client;

  ReminderRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List reminders with optional status filter
  Future<List<Reminder>> getReminders({String? status, int page = 1, int perPage = 20}) async {
    debugPrint('ReminderRepository: Fetching reminders');
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null) {
      queryParams['status'] = status;
    }
    final result = await _client.get(
      '/api/v1/reminders',
      queryParams: queryParams,
      fromJson: ReminderListDto.fromJson,
    );
    return result.reminders.map((dto) => Reminder.fromJson(dto.toJson())).toList();
  }

  /// Get a single reminder
  Future<Reminder> getReminder(String id) async {
    return _client.get('/api/v1/reminders/$id', fromJson: (json) => Reminder.fromJson(json));
  }

  /// Create a reminder
  Future<Reminder> createReminder(CreateReminderDto data) async {
    return _client.post('/api/v1/reminders', data: data.toJson(), fromJson: (json) => Reminder.fromJson(json));
  }

  /// Update a reminder
  Future<Reminder> updateReminder(String id, UpdateReminderDto data) async {
    return _client.put('/api/v1/reminders/$id', data: data.toJson(), fromJson: (json) => Reminder.fromJson(json));
  }

  /// Delete a reminder
  Future<void> deleteReminder(String id) async {
    await _client.delete('/api/v1/reminders/$id');
  }

  /// Snooze a reminder
  Future<Reminder> snoozeReminder(String id, DateTime snoozeUntil) async {
    return _client.post(
      '/api/v1/reminders/$id/snooze',
      data: {'snooze_until': snoozeUntil.toIso8601String()},
      fromJson: (json) => Reminder.fromJson(json),
    );
  }

  /// Mark a reminder as completed
  Future<Reminder> completeReminder(String id) async {
    return _client.post(
      '/api/v1/reminders/$id/complete',
      fromJson: (json) => Reminder.fromJson(json),
    );
  }
}
