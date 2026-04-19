import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class LessonVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? localVideoPath; // New optional parameter

  const LessonVideoPlayer({super.key, required this.videoUrl, this.localVideoPath});

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.localVideoPath != null && File(widget.localVideoPath!).existsSync()) {
      _videoPlayerController = VideoPlayerController.file(File(widget.localVideoPath!));
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
        final videoId = YoutubePlayer.convertUrlToId(url) ?? url;
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
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
    if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Chewie(
          controller: _chewieController!,
        ),
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
          child: Icon(
            Icons.play_circle_fill,
            color: AppColors.primary,
            size: 64,
          ),
        ),
      );
    }
  }
}
