import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/app_shadows.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/widgets/shared/linearProgress.dart';
import 'package:algonaid/features/modules/domain/entities/module.dart';
import 'package:algonaid/core/constants/endpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.module, this.onTap});

  @override
  Widget build(BuildContext context) {
    String? resolvedUrl = module.imageUrl;
    if (resolvedUrl != null && resolvedUrl.isNotEmpty && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 12),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(18),
              border: AppBorder.main_border,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: context.isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.grey400,
                  size: 20,
                ),

                const SizedBox(width: 16),

                ModuleCardContent(module: module, theme: context.theme),

                const SizedBox(width: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: resolvedUrl != null && resolvedUrl.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(16),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    InteractiveViewer(
                                      child: Hero(
                                        tag: 'module_image_${module.id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: resolvedUrl!,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => _buildFallbackIcon(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'module_image_${module.id}',
                            child: CachedNetworkImage(
                              imageUrl: resolvedUrl,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 75,
                                height: 75,
                                color: context.surfaceContainer,
                              ),
                              errorWidget: (context, url, error) => _buildFallbackIcon(context),
                            ),
                          ),
                        )
                      : _buildFallbackIcon(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.1),
      ),
      child: Icon(
        Icons.auto_awesome_mosaic_rounded,
        color: context.primary.withOpacity(0.7),
        size: 28,
      ),
    );
  }
}

class ModuleCardContent extends StatelessWidget {
  const ModuleCardContent({
    super.key,
    required this.module,
    required this.theme,
  });

  final Module module;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              module.title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              module.description,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: LinearProgress(
                  progressPercentage: module.progressPercentage,
                  hPadding: 0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${(module.progressPercentage).toInt()}%",
                style: TextStyle(
                  color: context.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
