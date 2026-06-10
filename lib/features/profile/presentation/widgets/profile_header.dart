import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';
import 'edit_profile_dialog.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.loadTotalPoints();
      provider.loadUserProfile();
      provider.loadUserBadges();
    });
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "U";
    final names = name.trim().split(" ");
    if (names.length >= 2) {
      return "${names[0][0]}${names[1][0]}".toUpperCase();
    }
    return names[0].substring(0, names[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.userProfile;

        final userName = profile?.name != null && profile!.name.isNotEmpty
            ? profile.name
            : (CacheHelper.getString(key: AppConstants.userName) ?? "مستخدم");

        final userEmail =
            CacheHelper.getString(key: AppConstants.userEmail) ??
            "user@example.com";
        final initials = _getInitials(userName);

        final hasBackground = false;

        // تحديد الألوان بذكاء بناءً على وجود خلفية مخصصة أو الاعتماد على ثيم التطبيق
        final textColor = context.textTheme.titleLarge?.color;
        final subTextColor = context.colorScheme.onSurface.withOpacity(0.6);
        final cardColor = context.colorScheme.surface;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: AppBorder.main_border,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // القسم الأول: الصورة الشخصية والاسم والنقاط
                        Row(
                          children: [
                            _buildAvatar(profile, initials),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: context.textTheme.titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userEmail,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: subTextColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildPointsBadge(provider),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Divider(color: textColor?.withOpacity(0.1), height: 1),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoMetric(
                                context,
                                Icons.school_rounded,
                                'الصف الدراسي',
                                (profile?.grade != null &&
                                        profile!.grade!.isNotEmpty)
                                    ? profile.grade!
                                    : 'غير محدد',
                                textColor,
                                subTextColor,
                              ),
                            ),
                            _buildVerticalDivider(textColor),
                            Expanded(
                              child: _buildInfoMetric(
                                context,
                                Icons.cake_rounded,
                                'تاريخ الميلاد',
                                (profile?.birthDate != null &&
                                        profile!.birthDate!.isNotEmpty)
                                    ? _formatHeaderDate(profile!.birthDate!)
                                    : 'غير محدد',
                                textColor,
                                subTextColor,
                              ),
                            ),
                            _buildVerticalDivider(textColor),
                            Expanded(
                              child: _buildInfoMetric(
                                context,
                                Icons.location_on_rounded,
                                'العنوان',
                                (profile?.address != null &&
                                        profile!.address!.isNotEmpty)
                                    ? profile.address!
                                    : 'غير محدد',
                                textColor,
                                subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 12,
                    left: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: textColor?.withOpacity(0.1),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit_rounded,
                            color: textColor,
                            size: 20,
                          ),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _openEditSheet(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ويدجت بناء الصورة الشخصية بدقة عالية وظلال ناعمة
  Widget _buildAvatar(dynamic profile, String initials) {
    final hasAvatar = profile?.avatar != null && profile!.avatar!.isNotEmpty;
    return GestureDetector(
      onTap: () => _showFullScreenImage(context, profile, initials),
      child: Hero(
        tag: 'user_profile_avatar',
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            image: hasAvatar
                ? DecorationImage(
                    image: CachedNetworkImageProvider(profile.avatar!),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: !hasAvatar
                ? LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: !hasAvatar
              ? Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void _showFullScreenImage(
    BuildContext context,
    dynamic profile,
    String initials,
  ) {
    final hasAvatar = profile?.avatar != null && profile!.avatar!.isNotEmpty;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (context, _, __) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Center(
              child: InteractiveViewer(
                child: Hero(
                  tag: 'user_profile_avatar',
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: hasAvatar
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                profile.avatar!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                      gradient: !hasAvatar
                          ? LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.75),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: !hasAvatar
                        ? Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ويدجت عرض بطاقة النقاط الذهبية المطورة
  Widget _buildPointsBadge(ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          provider.isLoadingPoints
              ? const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  '${provider.totalPoints} نقطة',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ],
      ),
    );
  }

  // ويدجت مبتكرة لعرض البيانات بشكل عمودي مصغر داخل الشريط الأفقي
  Widget _buildInfoMetric(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color? textColor,
    Color? subTextColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: subTextColor?.withOpacity(0.5)),
        const SizedBox(height: 6),
        // Text(
        //   "label",
        //   style: context.textTheme.bodySmall?.copyWith(
        //     color: subTextColor?.withOpacity(0.6),
        //     fontSize: 10,
        //   ),
        // ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(Color? textColor) {
    return Container(
      height: 32,
      width: 1,
      color: textColor?.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void _openEditSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'تعديل الملف الشخصي',
      child: const EditProfileSheet(),
    );
  }

  String _formatHeaderDate(String dateString) {
    if (dateString.isEmpty) return 'غير محدد';
    try {
      final parsed = DateTime.parse(dateString);
      return "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
    } catch (e) {
      // في حال حدوث خطأ غير متوقع في الصيغة القادمة من السيرفر، يتم إرجاع النص الأصلى دون تخريب الواجهة
      return dateString.split('T').first;
    }
  }
}
