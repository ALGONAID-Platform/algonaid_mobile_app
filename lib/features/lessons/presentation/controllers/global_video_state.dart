import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/floating_video_widget.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/native_pip_handler.dart';

class GlobalVideoState {
  static final GlobalVideoState _instance = GlobalVideoState._internal();
  factory GlobalVideoState() => _instance;
  GlobalVideoState._internal();

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  
  String? currentVideoUrl;
  String? currentLocalPath;
  int? currentLessonId;

  final ValueNotifier<bool> isFloatingNotifier = ValueNotifier<bool>(false);

  void showFloatingVideo(BuildContext context, int lessonId, String? videoUrl, String? localVideoPath) {
    if (isFloatingNotifier.value || videoPlayerController == null) return;
    
    currentLessonId = lessonId;
    currentVideoUrl = videoUrl;
    currentLocalPath = localVideoPath;
    Future.microtask(() {
      isFloatingNotifier.value = true;
    });
  }

  void hideFloatingVideo() {
    Future.microtask(() {
      isFloatingNotifier.value = false;
    });
  }

  void disposeControllers() {
    hideFloatingVideo();
    NativePipHandler().setPipAllowed(false);
    videoPlayerController?.dispose();
    chewieController?.dispose();
    videoPlayerController = null;
    chewieController = null;
    currentLessonId = null;
    currentVideoUrl = null;
    currentLocalPath = null;
  }
}
