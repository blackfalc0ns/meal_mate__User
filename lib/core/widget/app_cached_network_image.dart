import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.loadingWidget,
    this.errorWidget,
    this.semanticLabel,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final url = _resolveUrl(imageUrl);

    final child = url == null || url.isEmpty
        ? _buildError(context)
        : Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            semanticLabel: semanticLabel ?? locale.error_unknown,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) return child;
              return _buildLoading(context);
            },
            errorBuilder: (context, error, stackTrace) => _buildError(context),
          );

    final imageContent = ColoredBox(
      color: color.surfaceContainerHighest,
      child: SizedBox(width: width, height: height, child: child),
    );

    return shape == BoxShape.circle
        ? ClipOval(child: imageContent)
        : ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: imageContent,
          );
  }

  String? _resolveUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme) return url;
    if (url.startsWith('/')) return '${NetworkConstants.baseUrl}$url';
    return url;
  }

  Widget _buildLoading(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child:
          loadingWidget ??
          Semantics(
            label: locale.refresh,
            child: SizedBox(
              width: Spacing.lg,
              height: Spacing.lg,
              child: CircularProgressIndicator(
                strokeWidth: Spacing.border,
                color: color.primary,
              ),
            ),
          ),
    );
  }

  Widget _buildError(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child:
          errorWidget ??
          Semantics(
            label: locale.error_unknown,
            child: Icon(
              Icons.broken_image_rounded,
              color: color.onSurfaceVariant,
              size: Spacing.iconMd,
            ),
          ),
    );
  }
}
