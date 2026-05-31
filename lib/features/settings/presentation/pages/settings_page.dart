import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/shared_app_bar.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/about_settings_section.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/appearance_settings_section.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/logout_settings_button.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/notifications_settings_section.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/storage_settings_section.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/video_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enableNotifications = true;
  bool _floatingVideo = true;
  bool _autoPlayNext = false;
  String _downloadQuality = 'متوسطة';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _enableNotifications = CacheHelper.getBool(key: AppConstants.enableNotifications) ?? true;
      _floatingVideo = CacheHelper.getBool(key: AppConstants.floatingVideo) ?? true;
      _autoPlayNext = CacheHelper.getBool(key: AppConstants.autoPlayNext) ?? false;
      _downloadQuality = CacheHelper.getString(key: AppConstants.downloadQuality) ?? 'متوسطة';
    });
  }

  void _saveSetting(String key, dynamic value) {
    CacheHelper.saveData(key: key, value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const SharedAppBar(
          title: 'الإعدادات المتقدمة',
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            NotificationsSettingsSection(
              enableNotifications: _enableNotifications,
              onNotificationsChanged: (val) {
                setState(() => _enableNotifications = val);
                _saveSetting(AppConstants.enableNotifications, val);
              },
            ),
            const SizedBox(height: 24),
            VideoSettingsSection(
              floatingVideo: _floatingVideo,
              onFloatingVideoChanged: (val) {
                setState(() => _floatingVideo = val);
                _saveSetting(AppConstants.floatingVideo, val);
              },
              autoPlayNext: _autoPlayNext,
              onAutoPlayNextChanged: (val) {
                setState(() => _autoPlayNext = val);
                _saveSetting(AppConstants.autoPlayNext, val);
              },
              downloadQuality: _downloadQuality,
              onSelectDownloadQuality: () => _showQualityBottomSheet(context),
            ),
            const SizedBox(height: 24),
            const AppearanceSettingsSection(),
            const SizedBox(height: 24),
            const StorageSettingsSection(),
            const SizedBox(height: 24),
            const AboutSettingsSection(),
            const SizedBox(height: 24),
            const LogoutSettingsButton(),
          ],
        ),
      ),
    );
  }

  void _showQualityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر جودة التحميل',
                  style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQualityOption('عالية (HD)', context),
                _buildQualityOption('متوسطة', context),
                _buildQualityOption('منخفضة (توفير البيانات)', context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQualityOption(String quality, BuildContext context) {
    return ListTile(
      title: Text(quality),
      trailing: _downloadQuality == quality ? Icon(Icons.check_circle, color: context.primary) : null,
      onTap: () {
        setState(() => _downloadQuality = quality);
        _saveSetting(AppConstants.downloadQuality, quality);
        context.pop();
      },
    );
  }
}
