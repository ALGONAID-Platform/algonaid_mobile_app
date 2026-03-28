import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonDetailPage extends StatefulWidget {
  final int lessonId;

  const LessonDetailPage({super.key, required this.lessonId});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  bool _isLoading = false;
  String? _errorMessage;
  _LessonDetail? _lesson;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLesson();
    });
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = context.read<ApiService>();
      final data = await api.get(
        endpoint: EndPoint.lessonDetails(widget.lessonId),
      );

      final lesson = _extractLesson(data);
      setState(() {
        _lesson = lesson;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _lesson = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _LessonDetail _extractLesson(dynamic data) {
    if (data is Map<String, dynamic>) {
      return _LessonDetail.fromJson(data);
    }
    if (data is Map && data['data'] is Map<String, dynamic>) {
      return _LessonDetail.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Unexpected lesson response format');
  }

  String? _resolvePdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.trim().isEmpty) {
      return null;
    }
    if (pdfUrl.startsWith('http')) {
      return pdfUrl;
    }
    final cleaned = pdfUrl.startsWith('uploads/')
        ? pdfUrl.replaceFirst('uploads/', '')
        : pdfUrl;
    return '${EndPoint.uploadsBaseUrl}$cleaned';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: const Text('تفاصيل الدرس'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            label: const Text('قائمة الدروس'),
            icon: const Icon(Icons.list_alt),
          ),
        ),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final lesson = _lesson;
            if (lesson == null) {
              return const Center(child: Text('تعذر تحميل الدرس'));
            }

            final pdfUrl = _resolvePdfUrl(lesson.pdfUrl);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LessonVideoPlayer(videoUrl: lesson.videoUrl),
                  const SizedBox(height: 16),
                  _LessonInfoCard(title: lesson.title),
                  const SizedBox(height: 16),
                  _LessonTabs(
                    description: lesson.description,
                    content: lesson.content,
                  ),
                  const SizedBox(height: 16),
                  _LessonPdfCard(
                    pdfUrl: pdfUrl,
                    onOpen: () {
                      if (pdfUrl == null) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _LessonPdfViewerPage(
                            pdfUrl: pdfUrl,
                            title: lesson.title,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _QuizCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LessonDetail {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? pdfUrl;
  final String? exam;
  final int order;

  const _LessonDetail({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    this.description,
    this.content,
    this.videoUrl,
    this.pdfUrl,
    this.exam,
  });

  factory _LessonDetail.fromJson(Map<String, dynamic> json) {
    return _LessonDetail(
      id: json['id'] ?? 0,
      moduleId: json['moduleId'] ?? 0,
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      content: json['content']?.toString(),
      videoUrl: json['videoUrl']?.toString(),
      pdfUrl: json['pdfUrl']?.toString(),
      exam: json['exam']?.toString(),
      order: json['order'] ?? 0,
    );
  }
}

class _LessonInfoCard extends StatelessWidget {
  final String title;

  const _LessonInfoCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.indigo,
                ),
          ),
        ],
      ),
    );
  }
}

class _LessonTabs extends StatelessWidget {
  final String? description;
  final String? content;

  const _LessonTabs({this.description, this.content});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryLight,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'الوصف'),
                Tab(text: 'التعليقات'),
              ],
            ),
            SizedBox(
              height: 180,
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      description?.isNotEmpty == true
                          ? description!
                          : 'لا يوجد وصف متوفر لهذا الدرس حالياً.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'سيتم إضافة قسم التعليقات قريبًا.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonPdfCard extends StatelessWidget {
  final String? pdfUrl;
  final VoidCallback onOpen;

  const _LessonPdfCard({required this.pdfUrl, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfUrl != null && pdfUrl!.isNotEmpty;

    return InkWell(
      onTap: hasPdf ? onOpen : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص الدرس',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.indigo,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasPdf ? 'عرض ملف PDF' : 'لا يوجد ملف مرفق',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: hasPdf ? AppColors.primary : AppColors.grey300,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonVideoPlayer extends StatefulWidget {
  final String? videoUrl;

  const _LessonVideoPlayer({required this.videoUrl});

  @override
  State<_LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<_LessonVideoPlayer> {
  YoutubePlayerController? _controller;

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
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primaryLight,
        ),
      ),
    );
  }
}

class _LessonPdfViewerPage extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const _LessonPdfViewerPage({required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختبار الدرس',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'اختبر فهمك لهذا الدرس قريبًا',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.white,
                disabledForegroundColor: AppColors.primary,
              ),
              child: const Text('سيتوفر قريبًا'),
            ),
          ),
        ],
      ),
    );
  }
}
