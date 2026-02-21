import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/event_dto.dart';

/// Repository for event broadcast operations
class EventRepository {
  final RestClient _client;

  EventRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Broadcast an event
  Future<EventDto> broadcastEvent(BroadcastEventDto data) async {
    debugPrint('EventRepository: Broadcasting event of type ${data.type}');
    return _client.post(
      '/api/v1/events/broadcast',
      data: data.toJson(),
      fromJson: (json) => EventDto.fromJson(json),
    );
  }

  /// Get events with pagination
  Future<List<EventDto>> getEvents({int page = 1, int perPage = 20}) async {
    debugPrint('EventRepository: Fetching events page $page');
    final result = await _client.get(
      '/api/v1/events',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: EventListDto.fromJson,
    );
    return result.items;
  }

  /// Get a single event by ID
  Future<EventDto> getEvent(String id) async {
    debugPrint('EventRepository: Fetching event $id');
    return _client.get(
      '/api/v1/events/$id',
      fromJson: (json) => EventDto.fromJson(json),
    );
  }
}
