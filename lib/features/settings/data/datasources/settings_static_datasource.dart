import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/features/settings/domain/entities/developer_info.dart';
import 'package:algonaid/features/settings/domain/entities/platform_feature.dart';
import 'package:algonaid/features/settings/domain/entities/policy_item.dart';
import 'package:flutter/material.dart';

abstract class SettingsStaticDataSource {
  List<PlatformFeature> getPlatformFeatures();
  List<DeveloperInfo> getDevelopers();
  List<PolicyItem> getPolicies();
}

class SettingsStaticDataSourceImpl implements SettingsStaticDataSource {
  const SettingsStaticDataSourceImpl();

  @override
  List<PlatformFeature> getPlatformFeatures() {
    return const [
      PlatformFeature(
        icon: Icons.video_library_rounded,
        title: 'شروحات مرئية تفصيلية ومرنة',
      ),
      PlatformFeature(
        icon: Icons.quiz_rounded,
        title: 'اختبارات تفاعلية تقيم مستواك فورياً',
      ),
      PlatformFeature(
        icon: Icons.file_download_outlined,
        title: 'إمكانية تحميل الفيديوهات للمشاهدة بدون إنترنت',
      ),
      PlatformFeature(
        icon: Icons.show_chart_rounded,
        title: 'إحصائيات متقدمة لمراقبة تقدمك الأكاديمي',
      ),
      PlatformFeature(
        icon: Icons.workspace_premium_rounded,
        title: 'أوسمة وتكريمات تشجيعية للطلاب الأوائل',
      ),
    ];
  }

  @override
  List<DeveloperInfo> getDevelopers() {
    return const [
      DeveloperInfo(
        name: 'بشار الحميري',
        githubUrl: 'https://github.com/BashargalalAlhimyari',
        linkedinUrl: 'https://www.linkedin.com/in/bashar-galal-alhimyari-1204603a9?utm_source=share_via&utm_content=profile&utm_medium=member_android',
        imagePath: 'assets/images/bashar.png',
        avatarIcon: Icons.bolt_rounded,
        themeColor: AppColors.primary,
      ),
      DeveloperInfo(
        name: 'أيمن المليكي',
        githubUrl: 'https://github.com/Aiman20-eng',
        linkedinUrl: 'https://www.linkedin.com/in/aiman-almoliki?utm_source=share_via&utm_content=profile&utm_medium=member_android',
        imagePath: 'assets/images/ayman.png',
        avatarIcon: Icons.storage_rounded,
        themeColor: Colors.purple,
      ),
      DeveloperInfo(
        name: 'خالد الشيباني',
        githubUrl: 'https://github.com/Khaled-alshaibani',
        linkedinUrl: 'https://www.linkedin.com/in/khaled-al-shaibani-5607a8370?utm_source=share_via&utm_content=profile&utm_medium=member_android',
        imagePath: 'assets/images/khaled.png',
        avatarIcon: Icons.palette_rounded,
        themeColor: AppColors.amber,
      ),
      DeveloperInfo(
        name: 'حمزة عبد المطلب',
        githubUrl: 'https://github.com/HamzahTech553',
        linkedinUrl: 'https://linkedin.com/in/hamza-muttalib',
        imagePath: 'assets/images/hamza.png',
        avatarIcon: Icons.code_rounded,
        themeColor: Colors.teal,
      ),
      DeveloperInfo(
        name: 'عبد الله عبد الرحمن',
        githubUrl: 'https://github.com/Abdullah-saleh-s',
        linkedinUrl: 'https://www.linkedin.com/in/abdullah-saleh-00056b326',
        imagePath: 'assets/images/abdullah.png',
        avatarIcon: Icons.verified_user_rounded,
        themeColor: AppColors.green,
      ),
      DeveloperInfo(
        name: 'عبد الوهاب محمد',
        githubUrl: 'https://github.com',
        linkedinUrl: 'https://linkedin.com',
        imagePath: 'assets/images/abdulwahab.png',
        avatarIcon: Icons.devices_rounded,
        themeColor: Colors.blueAccent,
      ),
    ];
  }

  @override
  List<PolicyItem> getPolicies() {
    return const [
      PolicyItem(
        title: '1. شروط الاستخدام',
        content:
            'مرحباً بك في منصة Algonaid التعليمية. باستخدامك لتطبيقنا، فإنك توافق على هذه الشروط والأحكام. تهدف المنصة إلى تقديم محتوى تعليمي هادف ويُمنع استخدامها لأي أغراض تجارية أو غير قانونية دون إذن مسبق.',
      ),
      PolicyItem(
        title: '2. حقوق الملكية الفكرية',
        content:
            'جميع الحقوق المتعلقة بالمحتوى التعليمي (الفيديوهات، المستندات، الاختبارات) هي ملكية حصرية لمنصة Algonaid ومقدمي الدورات. يُمنع منعاً باتاً نسخ، توزيع، أو إعادة نشر أي محتوى متوفر في التطبيق دون الحصول على تصريح كتابي.',
      ),
      PolicyItem(
        title: '3. سياسة الخصوصية وحماية البيانات',
        content:
            'نحن نأخذ خصوصيتك على محمل الجد. نقوم بجمع بعض البيانات الأساسية (مثل الاسم والبريد الإلكتروني ومسار التعلم) لغرض تحسين تجربتك التعليمية. لا يتم بيع أو مشاركة بياناتك مع أطراف خارجية لأغراض تسويقية.',
      ),
      PolicyItem(
        title: '4. الاشتراكات والدفع',
        content:
            'في حال وجود دورات مدفوعة، يتم توضيح رسوم الدورة بشكل صريح قبل الشراء. عمليات الشراء نهائية ولا يتم استرداد الأموال إلا في الحالات الاستثنائية التي تقررها إدارة المنصة بعد مراجعة الطلب.',
      ),
      PolicyItem(
        title: '5. سياسة التنزيل والاستخدام دون اتصال',
        content:
            'تتيح المنصة ميزة تنزيل الفيديوهات والملفات للوصول إليها بدون إنترنت كخدمة إضافية. هذه الملفات مخصصة للاستخدام الشخصي داخل التطبيق فقط ومحمية ولا يجوز نقلها لأجهزة أخرى.',
      ),
      PolicyItem(
        title: '6. التعديل على السياسات',
        content:
            'تحتفظ إدارة Algonaid بالحق في تعديل هذه السياسات في أي وقت. سيتم إشعار المستخدمين بأي تغييرات جوهرية تطرأ على سياسات الخصوصية أو شروط الاستخدام.',
      ),
    ];
  }
}
