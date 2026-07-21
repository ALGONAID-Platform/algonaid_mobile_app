import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TimeoutImageWrapper extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const TimeoutImageWrapper({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  State<TimeoutImageWrapper> createState() => _TimeoutImageWrapperState();
}

class _TimeoutImageWrapperState extends State<TimeoutImageWrapper> {
  bool _isLoaded = false;
  bool _timeoutReached = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isLoaded) {
        setState(() {
          _timeoutReached = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timeoutReached && !_isLoaded) {
      return Image.asset(
        Images.noImageFound,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      imageBuilder: (context, imageProvider) {
        _isLoaded = true;
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: widget.fit,
            ),
          ),
        );
      },
      placeholder: (context, url) => Container(
        color: context.colorScheme.surfaceVariant.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        Images.noImageFound,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      ),
    );
  }
}
