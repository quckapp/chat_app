import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Data model for link preview
class LinkPreviewData {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? favicon;

  const LinkPreviewData({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.favicon,
  });
}

/// Widget to display link previews in messages
class LinkPreview extends StatelessWidget {
  final LinkPreviewData data;
  final bool isSent;
  final VoidCallback? onTap;

  const LinkPreview({
    super.key,
    required this.data,
    required this.isSent,
    this.onTap,
  });

  String get _displayUrl {
    try {
      final uri = Uri.parse(data.url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return data.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSent
              ? Colors.white.withValues(alpha: 0.15)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: isSent ? Colors.white.withValues(alpha: 0.5) : AppColors.primary,
              width: 3,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            if (data.imageUrl != null)
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                width: double.infinity,
                child: Image.network(
                  data.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site name/domain
                  Row(
                    children: [
                      if (data.favicon != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            data.favicon!,
                            width: 16,
                            height: 16,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.link,
                                size: 16,
                                color: isSent ? Colors.white.withValues(alpha: 0.7) : AppColors.grey500,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          data.siteName ?? _displayUrl,
                          style: TextStyle(
                            color: isSent ? Colors.white.withValues(alpha: 0.7) : AppColors.grey500,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Title
                  if (data.title != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      data.title!,
                      style: TextStyle(
                        color: isSent ? Colors.white : AppColors.grey900,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Description
                  if (data.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      data.description!,
                      style: TextStyle(
                        color: isSent ? Colors.white.withValues(alpha: 0.8) : AppColors.grey600,
                        fontSize: 13,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Utility to extract URLs from text
class LinkExtractor {
  static final _urlRegex = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    caseSensitive: false,
  );

  /// Extract all URLs from text
  static List<String> extractUrls(String text) {
    final matches = _urlRegex.allMatches(text);
    return matches.map((m) => m.group(0)!).toList();
  }

  /// Check if text contains a URL
  static bool containsUrl(String text) {
    return _urlRegex.hasMatch(text);
  }

  /// Get the first URL from text
  static String? getFirstUrl(String text) {
    final match = _urlRegex.firstMatch(text);
    return match?.group(0);
  }
}

/// Inline link text that can be tapped
class TappableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final void Function(String url)? onLinkTap;

  const TappableText({
    super.key,
    required this.text,
    this.style,
    this.linkStyle,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final defaultLinkStyle = linkStyle ?? defaultStyle.copyWith(
      color: AppColors.primary,
      decoration: TextDecoration.underline,
    );

    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in urlRegex.allMatches(text)) {
      // Add text before the link
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: defaultStyle,
        ));
      }

      // Add the link
      final url = match.group(0)!;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () => onLinkTap?.call(url),
          child: Text(
            url,
            style: defaultLinkStyle,
          ),
        ),
      ));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: defaultStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
