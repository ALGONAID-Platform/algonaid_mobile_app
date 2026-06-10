import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/controllers/global_video_state.dart';
import 'package:algonaid_mobile_app/core/routes/appRouters.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/controllers/native_pip_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class FloatingVideoWidget extends StatefulWidget {
  final int lessonId;

  const FloatingVideoWidget({super.key, required this.lessonId});

  @override
  State<FloatingVideoWidget> createState() => _FloatingVideoWidgetState();
}

class _FloatingVideoWidgetState extends State<FloatingVideoWidget> {
  double _xOffset = 20;
  double _yOffset = 100;
  
  double _width = 180;
  double _height = 100;
  
  double _baseWidth = 180;
  double _baseHeight = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _xOffset = size.width - _width - 20;
        _yOffset = size.height - _height - 100;
      });
      _updatePipRect();
    });
  }

  void _updatePipRect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final dpr = MediaQuery.of(context).devicePixelRatio;
      NativePipHandler().setPipRect(
        (_xOffset * dpr).toInt(),
        (_yOffset * dpr).toInt(),
        ((_xOffset + _width) * dpr).toInt(),
        ((_yOffset + _height) * dpr).toInt(),
      );
    });
  }

  void _onTap() {
    final router = AppRouters.routers;
    final currentUri = router.routerDelegate.currentConfiguration.uri.toString();
    
    if (!currentUri.contains('${Routes.lessonDetails}/${widget.lessonId}')) {
      router.push('${Routes.lessonDetails}/${widget.lessonId}');
    } else {
      GlobalVideoState().hideFloatingVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoController = GlobalVideoState().videoPlayerController;
    if (videoController == null) return const SizedBox.shrink();

    return Positioned(
      left: _xOffset,
      top: _yOffset,
      child: GestureDetector(
        onScaleStart: (details) {
          _baseWidth = _width;
          _baseHeight = _height;
        },
        onScaleUpdate: (details) {
          setState(() {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            if (details.scale != 1.0) {
              _width = (_baseWidth * details.scale).clamp(120.0, screenWidth - 20);
              _height = (_baseHeight * details.scale).clamp(70.0, screenHeight / 2.5);
            }

            _xOffset += details.focalPointDelta.dx;
            _yOffset += details.focalPointDelta.dy;
            
            _xOffset = _xOffset.clamp(5.0, screenWidth - _width - 5.0);
            _yOffset = _yOffset.clamp(30.0, screenHeight - _height - 30.0);
            _updatePipRect();
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.primary, width: 2),
            ),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _onTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoController.value.size.width,
                          height: videoController.value.size.height,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      GlobalVideoState().disposeControllers();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoController,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          if (value.isPlaying) {
                            videoController.pause();
                          } else {
                            videoController.play();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
