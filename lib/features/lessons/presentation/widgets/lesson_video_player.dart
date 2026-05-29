import 'dart:io';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/global_video_state.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/native_pip_handler.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';

class VideoQuality {
  final String resolution;
  final String url;
  VideoQuality(this.resolution, this.url);
}

class LessonVideoPlayer extends StatefulWidget {
  final int lessonId;
  final String? videoUrl;
  final String? localVideoPath;
  final VoidCallback? onProgressComplete; // عند الوصول لـ 90%
  final VoidCallback? onVideoStart; // عند بدء التشغيل
  final VoidCallback? onVideoEnd; // عند انتهاء الفيديو

  const LessonVideoPlayer({
    super.key,
    required this.lessonId,
    required this.videoUrl,
    this.localVideoPath,
    this.onProgressComplete,
    this.onVideoStart,
    this.onVideoEnd,
  });

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  final YoutubeExplode _yt = YoutubeExplode();

  String? _playerError;
  bool _isStartedReported = false;
  bool _isProgressReported = false;
  bool _isVideoEndedReported = false;
  bool _isLoading = false;

  List<VideoQuality> _availableQualities = [];
  VideoQuality? _selectedQuality;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final globalState = GlobalVideoState();

    if (globalState.currentLessonId == widget.lessonId &&
        globalState.chewieController != null) {
      globalState.hideFloatingVideo();
      setState(() {
        _isLoading = false;
        _playerError = null;
      });
      globalState.videoPlayerController?.addListener(_onPlayerStateChange);
      return;
    }

    _disposeControllers();
    setState(() {
      _playerError = null;
      _isLoading = true;
      _isStartedReported = false;
      _isProgressReported = false;
      _isVideoEndedReported = false;
      _availableQualities.clear();
      _selectedQuality = null;
    });

    try {
      if (!kIsWeb &&
          widget.localVideoPath != null &&
          File(widget.localVideoPath!).existsSync()) {
        globalState.videoPlayerController = VideoPlayerController.file(
          File(widget.localVideoPath!),
        );
        await _setupVideoPlayer();
      } else {
        final rawUrl = widget.videoUrl?.trim();
        if (rawUrl == null || rawUrl.isEmpty) {
          setState(() {
            _isLoading = false;
          });
          return;
        }

        String targetUrl = '';

        if (rawUrl.contains('youtube.com') || rawUrl.contains('youtu.be')) {
          final videoId = VideoId(rawUrl);
          final manifest = await _yt.videos.streamsClient.getManifest(videoId);
          final muxedStreams = manifest.muxed.sortByVideoQuality();

          if (muxedStreams.isNotEmpty) {
            for (var stream in muxedStreams) {
              _availableQualities.add(VideoQuality(
                '${stream.videoQuality.name} (${stream.size.totalMegaBytes.toStringAsFixed(1)}MB)',
                stream.url.toString(),
              ));
            }
            _availableQualities = _availableQualities.reversed.toList();
            _selectedQuality = _availableQualities.first;
            targetUrl = _selectedQuality!.url;
          } else {
            throw Exception('No streams found for this video');
          }
        } else {
          targetUrl = rawUrl.startsWith('http')
              ? rawUrl
              : '${EndPoint.uploadsBaseUrl}$rawUrl';
        }

        globalState.videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(targetUrl),
        );
        await _setupVideoPlayer();
      }

      globalState.currentLessonId = widget.lessonId;
      globalState.currentVideoUrl = widget.videoUrl;
      globalState.currentLocalPath = widget.localVideoPath;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _playerError = 'تعذر تشغيل الفيديو الحالي';
        _isLoading = false;
      });
      debugPrint('LessonVideoPlayer initialize error: $e');
    }
  }

  Future<void> _setupVideoPlayer() async {
    final globalState = GlobalVideoState();
    if (globalState.videoPlayerController == null) return;

    try {
      await globalState.videoPlayerController!.initialize();
      if (!mounted) return;

      setState(() {
        globalState.chewieController = ChewieController(
          videoPlayerController: globalState.videoPlayerController!,
          autoPlay: CacheHelper.getBool(key: 'autoPlayNext') ?? false,
          looping: false,
          allowPlaybackSpeedChanging: true,
          allowFullScreen: true,
          allowMuting: true,
          additionalOptions: (context) {
            if (_availableQualities.isEmpty) return [];
            return [
              OptionItem(
                onTap: (context) {
                  Navigator.pop(context); // Close the chewie options menu
                  _showQualitySelector();
                },
                iconData: Icons.hd_outlined,
                title: 'الجودة (${_selectedQuality?.resolution.split(' ').first ?? "تلقائي"})',
              )
            ];
          },
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primaryLight,
            backgroundColor: Colors.white24,
            bufferedColor: Colors.white54,
          ),
        );
        _isLoading = false;
      });

      globalState.videoPlayerController!.addListener(_onPlayerStateChange);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _playerError = 'تعذر تشغيل الفيديو الحالي';
        _isLoading = false;
      });
      debugPrint('LessonVideoPlayer setup error: $e');
    }
  }

  void _showQualitySelector() {
    AppBottomSheet.show(
      context: context,
      title: 'اختر جودة الفيديو',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _availableQualities.map((quality) {
          return ListTile(
            title: Text(quality.resolution),
            trailing: _selectedQuality == quality
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              Navigator.pop(context);
              _changeQuality(quality);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _changeQuality(VideoQuality newQuality) async {
    final globalState = GlobalVideoState();
    if (_selectedQuality == newQuality || globalState.videoPlayerController == null) return;

    setState(() {
      _isLoading = true;
    });

    final currentPosition = globalState.videoPlayerController!.value.position;
    final wasPlaying = globalState.videoPlayerController!.value.isPlaying;

    _disposeVideoControllerOnly();
    
    _selectedQuality = newQuality;
    globalState.videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(newQuality.url));
    
    try {
      await globalState.videoPlayerController!.initialize();
      await globalState.videoPlayerController!.seekTo(currentPosition);
      
      if (!mounted) return;

      setState(() {
        globalState.chewieController = ChewieController(
          videoPlayerController: globalState.videoPlayerController!,
          autoPlay: wasPlaying,
          looping: false,
          allowPlaybackSpeedChanging: true,
          allowFullScreen: true,
          allowMuting: true,
          additionalOptions: (context) {
            if (_availableQualities.isEmpty) return [];
            return [
              OptionItem(
                onTap: (context) {
                  Navigator.pop(context);
                  _showQualitySelector();
                },
                iconData: Icons.hd_outlined,
                title: 'الجودة (${_selectedQuality?.resolution.split(' ').first ?? "تلقائي"})',
              )
            ];
          },
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primaryLight,
            backgroundColor: Colors.white24,
            bufferedColor: Colors.white54,
          ),
        );
        _isLoading = false;
      });

      globalState.videoPlayerController!.addListener(_onPlayerStateChange);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _playerError = 'فشل في تغيير الجودة';
        _isLoading = false;
      });
    }
  }

  void _disposeVideoControllerOnly() {
    GlobalVideoState().videoPlayerController?.removeListener(_onPlayerStateChange);
    GlobalVideoState().disposeControllers();
  }

  void _disposeControllers() {
    _disposeVideoControllerOnly();
  }

  @override
  void didUpdateWidget(covariant LessonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.localVideoPath != widget.localVideoPath ||
        oldWidget.lessonId != widget.lessonId) {
      _initializePlayer();
    }
  }

  void _onPlayerStateChange() {
    final globalState = GlobalVideoState();
    if (!mounted || globalState.videoPlayerController == null) return;

    final isPlaying = globalState.videoPlayerController!.value.isPlaying;
    final position = globalState.videoPlayerController!.value.position;
    final duration = globalState.videoPlayerController!.value.duration;

    NativePipHandler().setPipAllowed(isPlaying);

    if (isPlaying && !_isStartedReported) {
      _isStartedReported = true;
      widget.onVideoStart?.call();
    }

    if (!_isProgressReported && duration.inSeconds > 0) {
      final percentage = position.inSeconds / duration.inSeconds;
      if (percentage >= 0.90) {
        _isProgressReported = true;
        widget.onProgressComplete?.call();
        
        final autoPlayNext = CacheHelper.getBool(key: 'autoPlayNext') ?? false;
        if (!autoPlayNext && mounted) {
          _showSuccessSheet(context);
        }
      }
    }

    if (!_isVideoEndedReported && duration.inSeconds > 0) {
      if (position >= duration) {
        _isVideoEndedReported = true;
        widget.onVideoEnd?.call();
      }
    }
  }

  void _showSuccessSheet(BuildContext context) {
    AppDialog.showDynamicDialog(
      context: context,
      title: "أحسنت! لقد أتممت الدرس",
      message: "تم تسجيل تقدمك بنجاح في المسار التعليمي",
      showCancelButton: false,
      confirmText: "تم",
    );
  }

  @override
  void dispose() {
    final globalState = GlobalVideoState();
    globalState.videoPlayerController?.removeListener(_onPlayerStateChange);
    
    // Instead of disposing, check if it's playing and we should show floating video
    if (globalState.videoPlayerController != null &&
        globalState.videoPlayerController!.value.isPlaying) {
      
      // Delay showing the floating video until after the current frame to avoid Overlay conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Find top level context using navigator key or similar if possible.
        // Actually, since this widget is disposing, context is invalid.
        // But we can trigger it in LessonDetailPage's pop!
      });
      // We will handle showing the overlay in LessonDetailPage before this widget is disposed.
    } else {
      globalState.disposeControllers();
    }
    
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget playerWidget;
    final globalState = GlobalVideoState();

    if (_isLoading) {
      playerWidget = const SizedBox(
        height: 210,
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    } else if (globalState.chewieController != null &&
        globalState.chewieController!.videoPlayerController.value.isInitialized) {
      playerWidget = Chewie(controller: globalState.chewieController!);
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
      child: SizedBox(
        width: double.infinity,
        height: 210,
        child: playerWidget,
      ),
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
