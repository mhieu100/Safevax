import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

/// Image widget with support for network, file, and asset images
/// and placeholder and error widgets
/// Also supports SVG images
/// If the image is a network image, it will be cached using the cacheKey
/// If the image is a file image, it will be loaded from the file system
/// required parameters are [url]
class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.url, {
    super.key,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
    this.color,
    this.cacheKey,
    this.semanticsLabel,
    this.radius,
    this.shape = BoxShape.rectangle,
    this.errorWidget,
    this.aspectRatio,
    this.borderRadius,
    this.useAnimation,
    this.defaultName,
  });

  final double width;
  final double height;
  final BoxFit fit;
  final String url;
  final Color? color;
  final String? cacheKey;
  final String? semanticsLabel;
  final double? radius;
  final double? aspectRatio;
  final BoxShape shape;
  final Widget? errorWidget;
  final BorderRadiusGeometry? borderRadius;
  final bool? useAnimation;
  final String? defaultName;

  @override
  Widget build(BuildContext context) {
    return _buildImage(context);
  }

  Widget _buildImage(BuildContext context) {
    if (url.isEmpty) {
      return _buildEmpty(context);
    }

    if (url.startsWith('http')) {
      return _networkImageWidget(context, url);
    }

    if (url.endsWith('.svg')) {
      return _svgWidget(context, url);
    }

    if (File(url).existsSync()) {
      return _imageFileWidget(context, url);
    }

    return _imageWidget(context, url);
  }

  _svgWidget(BuildContext context, String url) {
    final child = SvgPicture.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );

    return _buildImageWrapBorder(child);
  }

  _networkImageWidget(BuildContext context, String url) {
    debugPrint('ImageWidget: Loading network image from URL: $url');
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          debugPrint('ImageWidget: Successfully loaded image from: $url');
          return child;
        }
        return _placeHolderWidget(context);
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('ImageWidget: Failed to load image from: $url');
        debugPrint('ImageWidget: Error: $error');
        debugPrint('ImageWidget: StackTrace: $stackTrace');
        return errorWidget ?? _placeHolderWidget(context);
      },
    );
  }

  _imageWidget(BuildContext context, String url) {
    final child = Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      package: semanticsLabel,
      semanticLabel: cacheKey,
    );
    return _buildImageWrapBorder(child);
  }

  _imageFileWidget(BuildContext context, String url) {
    final child = Image.file(
      File(url),
      width: width,
      height: height,
      fit: fit,
      color: color,
      semanticLabel: cacheKey,
    );
    return _buildImageWrapBorder(child);
  }

  _placeHolderWidget(BuildContext context) {
    final image = Image.asset(
      'assets/images/image.png',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );

    return Center(
        child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: image,
    ));
  }

  Widget _buildImageWrapBorder(Widget image) {
    return shape == BoxShape.circle
        ? CircleAvatar(
            backgroundColor: color,
            radius: (width / 2),
            child: CircleAvatar(
              radius: (width / 2),
              child: image,
            ),
          )
        : ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            child: image,
          );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : borderRadius ?? BorderRadius.circular(12),
        gradient: const LinearGradient(colors: []),
      ),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: const Text(
        // defaultName?.getCharacterName() ?? 'N/A',
        // style: context.headline.copyWith(
        //   color: context.colors.surface,
        //   fontSize: width / 4,
        // ),
        "N/A",
      ),
    );
  }
}
