import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/shared_app_bar.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const SharedAppBar(
          title: 'السياسات والأحكام',
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSection(
              context,
              title: '1. شروط الاستخدام',
              content: 'مرحباً بك في منصة Algonaid التعليمية. باستخدامك لتطبيقنا، فإنك توافق على هذه الشروط والأحكام. تهدف المنصة إلى تقديم محتوى تعليمي هادف ويُمنع استخدامها لأي أغراض تجارية أو غير قانونية دون إذن مسبق.',
            ),
            _buildSection(
              context,
              title: '2. حقوق الملكية الفكرية',
              content: 'جميع الحقوق المتعلقة بالمحتوى التعليمي (الفيديوهات، المستندات، الاختبارات) هي ملكية حصرية لمنصة Algonaid ومقدمي الدورات. يُمنع منعاً باتاً نسخ، توزيع، أو إعادة نشر أي محتوى متوفر في التطبيق دون الحصول على تصريح كتابي.',
            ),
            _buildSection(
              context,
              title: '3. سياسة الخصوصية وحماية البيانات',
              content: 'نحن نأخذ خصوصيتك على محمل الجد. نقوم بجمع بعض البيانات الأساسية (مثل الاسم والبريد الإلكتروني ومسار التعلم) لغرض تحسين تجربتك التعليمية. لا يتم بيع أو مشاركة بياناتك مع أطراف خارجية لأغراض تسويقية.',
            ),
            _buildSection(
              context,
              title: '4. الاشتراكات والدفع',
              content: 'في حال وجود دورات مدفوعة، يتم توضيح رسوم الدورة بشكل صريح قبل الشراء. عمليات الشراء نهائية ولا يتم استرداد الأموال إلا في الحالات الاستثنائية التي تقررها إدارة المنصة بعد مراجعة الطلب.',
            ),
            _buildSection(
              context,
              title: '5. سياسة التنزيل والاستخدام دون اتصال',
              content: 'تتيح المنصة ميزة تنزيل الفيديوهات والملفات للوصول إليها بدون إنترنت كخدمة إضافية. هذه الملفات مخصصة للاستخدام الشخصي داخل التطبيق فقط ومحمية ولا يجوز نقلها لأجهزة أخرى.',
            ),
            _buildSection(
              context,
              title: '6. التعديل على السياسات',
              content: 'تحتفظ إدارة Algonaid بالحق في تعديل هذه السياسات في أي وقت. سيتم إشعار المستخدمين بأي تغييرات جوهرية تطرأ على سياسات الخصوصية أو شروط الاستخدام.',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.gavel_rounded, size: 32, color: context.primary),
                  const SizedBox(height: 12),
                  Text(
                    'تمثل هذه الوثيقة اتفاقية قانونية ملزمة بين المستخدم ومنصة Algonaid. إذا كانت لديك أي استفسارات، يرجى التواصل مع الدعم الفني.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: context.onBackground.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: context.onBackground.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
