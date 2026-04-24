import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class LessonVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? localVideoPath; // New optional parameter

  const LessonVideoPlayer({
    super.key,
    required this.videoUrl,
    this.localVideoPath,
  });

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String? _youtubeVideoId;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb &&
        widget.localVideoPath != null &&
        File(widget.localVideoPath!).existsSync()) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.localVideoPath!),
      );
      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: false,
            looping: false,
            // Additional Chewie options
          );
        });
      });
    } else {
      final url = widget.videoUrl?.trim();
      if (url != null && url.isNotEmpty) {
        final videoId = YoutubePlayer.convertUrlToId(url);

        if (videoId != null) {
          // This is a YouTube URL
          _youtubeVideoId = videoId;
          if (!kIsWeb) {
            _youtubeController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                enableCaption: true,
              ),
            );
          }
        } else if (!kIsWeb) {
          // This is a direct video URL (not YouTube) for non-web platforms
          _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
          _videoPlayerController!.initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController!,
                autoPlay: false,
                looping: false,
                // Additional Chewie options
              );
            });
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Chewie(controller: _chewieController!),
      );
    } else if (kIsWeb && _youtubeVideoId != null) {
      return _WebYoutubeFallback(
        videoId: _youtubeVideoId!,
      );
    } else if (_youtubeController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColors.primary,
          progressColors: const ProgressBarColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primaryLight,
          ),
        ),
      );
    } else {
      return Container(
        height: 210,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: Text(
            'لا يوجد فيديو متاح', // "No video available" in Arabic
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }
  }
}

class _WebYoutubeFallback extends StatelessWidget {
  final String videoId;

  const _WebYoutubeFallback({required this.videoId});

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return Container(
      height: 250,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
          onError: (error, stackTrace) {},
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.15),
              Colors.black.withValues(alpha: 0.65),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

          ],
        ),
      ),
    );
  }
}
