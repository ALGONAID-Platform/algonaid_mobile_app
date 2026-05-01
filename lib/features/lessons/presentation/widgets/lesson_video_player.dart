import 'dart:io';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? localVideoPath;
  final VoidCallback? onProgressComplete; // عند الوصول لـ 90%
  final VoidCallback? onVideoStart; // عند بدء التشغيل

  const LessonVideoPlayer({
    super.key,
    required this.videoUrl,
    this.localVideoPath,
    this.onProgressComplete,
    this.onVideoStart,
  });

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  String? _playerError;
  bool _isStartedReported = false;
  bool _isProgressReported = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _disposeControllers();
    _playerError = null;
    _isStartedReported = false;
    _isProgressReported = false;

    // 1. التحقق من الفيديو المحلي أولاً (في غير الويب)
    if (!kIsWeb &&
        widget.localVideoPath != null &&
        File(widget.localVideoPath!).existsSync()) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.localVideoPath!),
      );
      _setupVideoPlayer();
    }
    // 2. التحقق من الرابط (يوتيوب أو رابط مباشر)
    else {
      final url = _resolveVideoUrl(widget.videoUrl);
      if (url == null || url.isEmpty) return;

      final videoId = YoutubePlayer.convertUrlToId(url);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        )..addListener(_onPlayerStateChange);
      } else {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(url),
        );
        _setupVideoPlayer();
      }
    }
  }

  void _setupVideoPlayer() {
    if (_videoPlayerController == null) return;

    _videoPlayerController!
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController!,
              autoPlay: false,
              looping: false,
            );
          });
          _videoPlayerController!.addListener(_onPlayerStateChange);
        })
        .catchError((Object error) {
          if (!mounted) return;
          setState(() {
            _playerError = 'تعذر تشغيل الفيديو الحالي';
          });
          debugPrint('LessonVideoPlayer initialize error: $error');
        });
  }

  String? _resolveVideoUrl(String? rawUrl) {
    final url = rawUrl?.trim();
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return '${EndPoint.uploadsBaseUrl}$url';
  }

  void _disposeControllers() {
    _youtubeController?.removeListener(_onPlayerStateChange);
    _youtubeController?.dispose();
    _youtubeController = null;

    _videoPlayerController?.removeListener(_onPlayerStateChange);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;

    _chewieController?.dispose();
    _chewieController = null;
  }

  @override
  void didUpdateWidget(covariant LessonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.localVideoPath != widget.localVideoPath) {
      _initializePlayer();
    }
  }

  void _onPlayerStateChange() {
    if (!mounted) return;

    bool isPlaying = false;
    Duration position = Duration.zero;
    Duration duration = Duration.zero;

    // استخراج البيانات بناءً على نوع المشغل النشط
    if (_youtubeController != null) {
      isPlaying = _youtubeController!.value.isPlaying;
      position = _youtubeController!.value.position;
      duration = _youtubeController!.metadata.duration;
    } else if (_videoPlayerController != null) {
      isPlaying = _videoPlayerController!.value.isPlaying;
      position = _videoPlayerController!.value.position;
      duration = _videoPlayerController!.value.duration;
    }

    // أولاً: تتبع بدء المشاهدة
    if (isPlaying && !_isStartedReported) {
      _isStartedReported = true;
      widget.onVideoStart?.call();
    }

    // ثانياً: تتبع نسبة الإنجاز (90%)
    if (!_isProgressReported && duration.inSeconds > 0) {
      final percentage = position.inSeconds / duration.inSeconds;
      if (percentage >= 0.90) {
        _isProgressReported = true;
        _showSuccessSheet(context);
        widget.onProgressComplete?.call();
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
              "تم تسجيل تقدمك بنجاح في المسار التعليمي",
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

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget playerWidget;

    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      playerWidget = Chewie(controller: _chewieController!);
    } else if (_youtubeController != null) {
      playerWidget = YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primaryLight,
        ),
      );
    } else if (_playerError != null) {
      playerWidget = _buildMessageState(
        message: _playerError!,
        icon: Icons.error_outline,
      );
    } else if (widget.videoUrl == null ||
        widget.videoUrl!.trim().isEmpty && widget.localVideoPath == null) {
      playerWidget = _buildMessageState(
        message: 'لا يوجد فيديو متاح لهذا الدرس',
        icon: Icons.ondemand_video_outlined,
      );
    } else {
      playerWidget = const SizedBox(
        height: 210,
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(width: double.infinity, height: 210, child: playerWidget),
    );
  }

  Widget _buildMessageState({required String message, required IconData icon}) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 34),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
