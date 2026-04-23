import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final VoidCallback? onProgressComplete; // للـ 90% (مكتمل)
  final VoidCallback? onVideoStart; // عند البدء (قيد التقدم)

  const LessonVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onProgressComplete,
    this.onVideoStart, // أضفه هنا
  });

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  YoutubePlayerController? _controller;

  bool _isStartedReported = false; // لمنع التكرار عند كل ضغطة Play
  bool _isProgressReported = false;

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container(
        height: 210,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Icon(Icons.play_circle_fill, color: context.primary, size: 64),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: context.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primaryLight,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final url = widget.videoUrl?.trim();
    if (url != null && url.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(url) ?? url;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      )..addListener(_onPlayerStateChange);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlayerStateChange);
    _controller?.dispose();
    super.dispose();
  }

  void _onPlayerStateChange() {
    if (!mounted || _controller == null) return;

    // أولاً: التحقق من بدء المشاهدة (قيد التقدم)
    if (_controller!.value.isPlaying && !_isStartedReported) {
      _isStartedReported = true;
      if (widget.onVideoStart != null) {
        widget
            .onVideoStart!(); // نبلغ الـ Provider بإنشاء السجل (isCompleted = false)
      }
    }

    if (_isProgressReported) return;

    final metadata = _controller!.metadata;
    final position = _controller!.value.position;

    if (metadata.duration.inSeconds > 0) {
      final percentage = position.inSeconds / metadata.duration.inSeconds;
      if (percentage >= 0.90) {
        _showSuccessSheet(context);
        _isProgressReported = true;
        if (widget.onProgressComplete != null) {
          widget.onProgressComplete!(); // نحدث السجل ليصبح (isCompleted = true)
        }
      }
    }
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF33E1B3),
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              "أحسنت! لقد أتممت الدرس",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "تم تسجيل تقدمك بنجاح في المسار الجمهوري",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "متابعة المسار",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
