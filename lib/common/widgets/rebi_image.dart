import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RebiImage extends StatelessWidget {
  const RebiImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.errorIconSize,
    this.errorWidget,
    this.radius,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final double? errorIconSize;
  final BoxFit? fit;
  final Widget? errorWidget;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        placeholderFadeInDuration: const Duration(milliseconds: 500),
        placeholder: (context, url) {
          return      Lottie.asset('assets/json/loading_gym.json');
        },
        errorWidget: (context, url, error) {
          return errorWidget ?? Image.asset('assets/images/launcher-icon.png');
        },
      ),
    );
  }
}
