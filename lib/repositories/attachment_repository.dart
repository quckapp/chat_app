import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/attachment_dto.dart';

/// Repository for attachment operations
class AttachmentRepository {
  final RestClient _client;

  AttachmentRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Create an attachment
  Future<MessageAttachmentDto> createAttachment(AttachmentUploadDto data) async {
    return _client.post(
      '/api/v1/attachments',
      data: data.toJson(),
      fromJson: (json) => MessageAttachmentDto.fromJson(json),
    );
  }

  /// Get attachment by id
  Future<MessageAttachmentDto> getAttachment(String id) async {
    return _client.get('/api/v1/attachments/$id', fromJson: (json) => MessageAttachmentDto.fromJson(json));
  }

  /// Get attachments for a message
  Future<List<MessageAttachmentDto>> getAttachmentsByMessage(String messageId) async {
    debugPrint('AttachmentRepository: Fetching attachments for message $messageId');
    return _client.getList(
      '/api/v1/attachments',
      queryParams: {'message_id': messageId},
      fromJson: (json) => MessageAttachmentDto.fromJson(json),
    );
  }

  /// Delete an attachment
  Future<void> deleteAttachment(String id) async {
    await _client.delete('/api/v1/attachments/$id');
  }
}
