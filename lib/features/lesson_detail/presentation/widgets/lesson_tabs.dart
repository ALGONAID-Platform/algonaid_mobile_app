import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/app_shadows.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonTabs extends StatefulWidget {
  final String? description;
  final String? content;

  const LessonTabs({super.key, this.description, this.content});

  @override
  State<LessonTabs> createState() => _LessonTabsState();
}

class _LessonTabsState extends State<LessonTabs> {
  bool _isExpanded = false;
  final GlobalKey _containerKey = GlobalKey();

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_containerKey.currentContext != null) {
          Scrollable.ensureVisible(
            _containerKey.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutQuart,
            alignment: 0.0, // Scroll so the top of the description is at the top of the screen
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = widget.description?.isNotEmpty == true
        ? widget.description!
        : (widget.content?.isNotEmpty == true
            ? widget.content!
            : 'لا يوجد وصف متوفر لهذا الدرس حالياً.');

    return Container(
      key: _containerKey,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
        border: AppBorder.main_border,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expand Button on the right
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: _isExpanded ? 'تصغير' : 'تكبير',
              child: InkWell(
                onTap: _toggleExpand,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    _isExpanded ? Icons.close_fullscreen_rounded : Icons.open_in_full_rounded,
                    color: context.primary.withOpacity(0.7),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Description Content
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutQuart,
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: _isExpanded ? double.infinity : 160,
              ),
              child: SingleChildScrollView(
                physics: _isExpanded ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MarkdownBody(
                    data: text,
                    selectable: true,
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    imageBuilder: (uri, title, alt) {
                      return CachedNetworkImage(
                        imageUrl: uri.toString(),
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image_rounded, color: Colors.grey),
                        fit: BoxFit.contain,
                      );
                    },
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final url = Uri.parse(href);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: context.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.78),
                        height: 1.6,
                      ),
                      h1: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      h2: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      h3: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Center(
              child: InkWell(
                onTap: _toggleExpand,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'تصغير الوصف',
                        style: TextStyle(
                          color: context.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.expand_less_rounded,
                        color: context.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
