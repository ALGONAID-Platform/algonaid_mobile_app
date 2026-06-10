import 'dart:io';

import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

enum _AttachmentType { pdf, office, unsupported }

class _ResolvedAttachment {
  final File file;
  final _AttachmentType type;

  const _ResolvedAttachment({required this.file, required this.type});
}

class LessonPdfViewerPage extends StatefulWidget {
  final String? pdfUrl;
  final String? localPdfPath;
  final String title;

  const LessonPdfViewerPage({
    super.key,
    this.pdfUrl,
    this.localPdfPath,
    required this.title,
  });

  @override
  State<LessonPdfViewerPage> createState() => _LessonPdfViewerPageState();
}

class _LessonPdfViewerPageState extends State<LessonPdfViewerPage> {
  final Dio _dio = Dio();

  File? _localFile;
  _AttachmentType _attachmentType = _AttachmentType.unsupported;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorDetails = '';

  @override
  void initState() {
    super.initState();
    _prepareAttachment();
  }

  Future<void> _prepareAttachment() async {
    try {
      final localPath = widget.localPdfPath;
      if (localPath != null && File(localPath).existsSync()) {
        await _setLocalFile(File(localPath));
        return;
      }

      final sourceUrl = widget.pdfUrl?.trim();
      if (sourceUrl == null || sourceUrl.isEmpty) {
        _setError('الملف غير متوفر');
        return;
      }

      final resolvedUrl = _resolveDownloadUrl(sourceUrl);
      final cachedFile = await _downloadAttachment(resolvedUrl, sourceUrl);
      if (!mounted) return;

      await _setLocalFile(cachedFile, sourceUrl: sourceUrl);
    } catch (e) {
      if (!mounted) return;
      _setError('تعذر فتح الملف', details: e.toString());
    }
  }

  String _resolveDownloadUrl(String sourceUrl) {
    final driveFileId = _extractDriveFileId(sourceUrl);
    if (driveFileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$driveFileId';
    }
    return sourceUrl;
  }

  String? _extractDriveFileId(String url) {
    final patterns = <RegExp>[
      RegExp(r'https?://drive\.google\.com/file/d/([^/]+)/view'),
      RegExp(r'https?://drive\.google\.com/open\?id=([^&]+)'),
      RegExp(r'https?://drive\.google\.com/uc\?export=download&id=([^&]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  Future<File> _downloadAttachment(String url, String sourceUrl) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${_buildCacheFileName(sourceUrl)}';
    final file = File(tempPath);

    if (await file.exists()) {
      return file;
    }

    await _dio.download(url, tempPath);
    return file;
  }

  String _buildCacheFileName(String sourceUrl) {
    final extension = _guessExtension(sourceUrl);
    final sanitizedTitle = widget.title
        .replaceAll(RegExp(r'[\\\/:*?"<>|]'), '_')
        .trim();
    final fileName = sanitizedTitle.isEmpty
        ? 'lesson_attachment'
        : sanitizedTitle;
    return '$fileName.$extension';
  }

  String _guessExtension(String sourceUrl) {
    final parsed = Uri.tryParse(sourceUrl);
    final path = parsed?.path.isNotEmpty == true ? parsed!.path : sourceUrl;
    final lowerPath = path.toLowerCase();

    const knownExtensions = <String>[
      'pdf',
      'ppt',
      'pptx',
      'pptm',
      'pps',
      'ppsx',
    ];

    for (final extension in knownExtensions) {
      if (lowerPath.endsWith('.$extension')) {
        return extension;
      }
    }

    if (_extractDriveFileId(sourceUrl) != null) {
      return 'pdf';
    }

    return 'pdf';
  }

  Future<void> _setLocalFile(File file, {String? sourceUrl}) async {
    final resolvedAttachment = await _resolveAttachment(
      file,
      sourceUrl: sourceUrl,
    );
    if (!mounted) return;

    setState(() {
      _localFile = resolvedAttachment.file;
      _attachmentType = resolvedAttachment.type;
      _isLoading = false;
      _hasError = false;
      _errorDetails = '';
    });
  }

  Future<_ResolvedAttachment> _resolveAttachment(
    File file, {
    String? sourceUrl,
  }) async {
    final sourceExtension = _guessExtension(sourceUrl ?? file.path);
    if (sourceExtension == 'pdf') {
      final header = await _readHeader(file);
      if (_looksLikePdf(header)) {
        return _ResolvedAttachment(file: file, type: _AttachmentType.pdf);
      }

      if (_looksLikeOfficePackage(header)) {
        if (file.path.toLowerCase().endsWith('.pdf')) {
          final renamed = await _renameFile(file, 'pptx');
          if (renamed != null) {
            return _ResolvedAttachment(
              file: renamed,
              type: _AttachmentType.office,
            );
          }
        }
        return _ResolvedAttachment(file: file, type: _AttachmentType.office);
      }

      return _ResolvedAttachment(file: file, type: _AttachmentType.pdf);
    }

    return _ResolvedAttachment(file: file, type: _AttachmentType.office);
  }

  Future<List<int>> _readHeader(File file) async {
    try {
      return await file.openRead(0, 8).first;
    } catch (_) {
      return const <int>[];
    }
  }

  bool _looksLikePdf(List<int> header) {
    return header.length >= 4 &&
        header[0] == 0x25 &&
        header[1] == 0x50 &&
        header[2] == 0x44 &&
        header[3] == 0x46;
  }

  bool _looksLikeOfficePackage(List<int> header) {
    return header.length >= 2 && header[0] == 0x50 && header[1] == 0x4B;
  }

  Future<File?> _renameFile(File file, String extension) async {
    try {
      final sanitizedName = widget.title
          .replaceAll(RegExp(r'[\\\/:*?"<>|]'), '_')
          .trim();
      final baseName = sanitizedName.isEmpty
          ? 'lesson_attachment'
          : sanitizedName;
      final renamedPath = '${file.parent.path}/$baseName.$extension';

      if (renamedPath == file.path) {
        return file;
      }

      if (await File(renamedPath).exists()) {
        return File(renamedPath);
      }

      return await file.copy(renamedPath);
    } catch (_) {
      return null;
    }
  }

  void _setError(String message, {String? details}) {
    setState(() {
      _hasError = true;
      _isLoading = false;
      _errorDetails = details ?? '';
    });
  }

  Future<void> _openAttachmentExternally() async {
    final file = _localFile;
    final sourceUrl = widget.pdfUrl?.trim();

    try {
      if (file != null && await file.exists()) {
        final opened = await launchUrl(
          Uri.file(file.path),
          mode: LaunchMode.externalApplication,
        );
        if (opened) return;
      }

      if (sourceUrl != null && sourceUrl.isNotEmpty) {
        final previewUrl = _resolvePreviewUrl(sourceUrl);
        final opened = await launchUrl(
          Uri.parse(previewUrl),
          mode: LaunchMode.externalApplication,
        );
        if (opened) return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الملف خارج التطبيق')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  String _resolvePreviewUrl(String sourceUrl) {
    final driveFileId = _extractDriveFileId(sourceUrl);
    if (driveFileId != null) {
      final downloadUrl =
          'https://drive.google.com/uc?export=download&id=$driveFileId';
      return 'https://docs.google.com/gview?embedded=1&url=${Uri.encodeComponent(downloadUrl)}';
    }
    return sourceUrl;
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.redAccent,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'تعذر فتح الملف',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (_errorDetails.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _errorDetails,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            if (widget.pdfUrl != null && widget.pdfUrl!.isNotEmpty) ...[
              ElevatedButton.icon(
                onPressed: _openAttachmentExternally,
                icon: const Icon(Icons.open_in_browser, color: Colors.white),
                label: const Text(
                  'فتح الملف في تطبيق خارجي',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    final file = _localFile;
    if (file == null || !file.existsSync()) {
      return _buildErrorView();
    }

    return SfPdfViewer.file(
      file,
      canShowPaginationDialog: true,
      canShowScrollHead: true,
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        setState(() {
          _hasError = true;
          _errorDetails = details.description;
        });
      },
    );
  }

  Widget _buildOfficeView() {
    final file = _localFile;
    final hasLocalFile = file != null && file.existsSync();
    final sourceUrl = widget.pdfUrl?.trim();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.slideshow_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'هذا الملف من نوع PowerPoint',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              hasLocalFile
                  ? 'تم حفظ الملف ويمكن فتحه الآن باستخدام تطبيق العروض المثبت على الجهاز.'
                  : 'سيتم فتح الملف عبر الرابط الأصلي في تطبيق خارجي.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openAttachmentExternally,
              icon: const Icon(Icons.open_in_new, color: Colors.white),
              label: Text(
                hasLocalFile ? 'فتح الملف المحفوظ' : 'فتح الملف',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            if (sourceUrl != null && sourceUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(_resolvePreviewUrl(sourceUrl)),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text('فتح الرابط في المتصفح'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;

    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      body = _buildErrorView();
    } else if (_attachmentType == _AttachmentType.pdf) {
      body = _buildPdfViewer();
    } else if (_attachmentType == _AttachmentType.office) {
      body = _buildOfficeView();
    } else {
      body = const Center(child: Text('الملف غير متوفر'));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: SharedAppBar(title: widget.title),
        body: body,
      ),
    );
  }
}
