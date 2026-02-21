import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/channel_extras.dart';
import '../models/serializable/channel_extras_dto.dart';

/// Repository for channel links, tabs, and templates
class ChannelExtrasRepository {
  final RestClient _client;

  ChannelExtrasRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  // --- Links ---

  /// Get links for a channel
  Future<List<ChannelLink>> getLinks(String channelId) async {
    debugPrint('ChannelExtrasRepository: Fetching links for channel $channelId');
    return _client.getList(
      '/api/v1/channels/$channelId/links',
      fromJson: (json) => ChannelLink.fromJson(json),
    );
  }

  /// Create a link in a channel
  Future<ChannelLink> createLink(String channelId, CreateChannelLinkDto data) async {
    debugPrint('ChannelExtrasRepository: Creating link in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/links',
      data: data.toJson(),
      fromJson: (json) => ChannelLink.fromJson(json),
    );
  }

  /// Delete a link from a channel
  Future<void> deleteLink(String channelId, String linkId) async {
    debugPrint('ChannelExtrasRepository: Deleting link $linkId');
    await _client.delete('/api/v1/channels/$channelId/links/$linkId');
  }

  // --- Tabs ---

  /// Get tabs for a channel
  Future<List<ChannelTab>> getTabs(String channelId) async {
    debugPrint('ChannelExtrasRepository: Fetching tabs for channel $channelId');
    return _client.getList(
      '/api/v1/channels/$channelId/tabs',
      fromJson: (json) => ChannelTab.fromJson(json),
    );
  }

  /// Create a tab in a channel
  Future<ChannelTab> createTab(String channelId, CreateChannelTabDto data) async {
    debugPrint('ChannelExtrasRepository: Creating tab in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/tabs',
      data: data.toJson(),
      fromJson: (json) => ChannelTab.fromJson(json),
    );
  }

  /// Update a tab
  Future<ChannelTab> updateTab(
      String channelId, String tabId, CreateChannelTabDto data) async {
    debugPrint('ChannelExtrasRepository: Updating tab $tabId');
    return _client.put(
      '/api/v1/channels/$channelId/tabs/$tabId',
      data: data.toJson(),
      fromJson: (json) => ChannelTab.fromJson(json),
    );
  }

  /// Delete a tab from a channel
  Future<void> deleteTab(String channelId, String tabId) async {
    debugPrint('ChannelExtrasRepository: Deleting tab $tabId');
    await _client.delete('/api/v1/channels/$channelId/tabs/$tabId');
  }

  // --- Templates ---

  /// Get templates for a channel
  Future<List<ChannelTemplate>> getTemplates(String channelId) async {
    debugPrint('ChannelExtrasRepository: Fetching templates for channel $channelId');
    return _client.getList(
      '/api/v1/channels/$channelId/templates',
      fromJson: (json) => ChannelTemplate.fromJson(json),
    );
  }

  /// Create a template in a channel
  Future<ChannelTemplate> createTemplate(
      String channelId, CreateChannelTemplateDto data) async {
    debugPrint('ChannelExtrasRepository: Creating template in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/templates',
      data: data.toJson(),
      fromJson: (json) => ChannelTemplate.fromJson(json),
    );
  }

  /// Update a template
  Future<ChannelTemplate> updateTemplate(
      String channelId, String templateId, CreateChannelTemplateDto data) async {
    debugPrint('ChannelExtrasRepository: Updating template $templateId');
    return _client.put(
      '/api/v1/channels/$channelId/templates/$templateId',
      data: data.toJson(),
      fromJson: (json) => ChannelTemplate.fromJson(json),
    );
  }

  /// Delete a template from a channel
  Future<void> deleteTemplate(String channelId, String templateId) async {
    debugPrint('ChannelExtrasRepository: Deleting template $templateId');
    await _client.delete('/api/v1/channels/$channelId/templates/$templateId');
  }
}
