import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';

class AboutTeacherPage extends StatelessWidget {
  const AboutTeacherPage({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/967737548336");
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _launchTelegram(BuildContext context) async {
    final Uri telegramUrl = Uri.parse("https://t.me/natheyuhc");
    try {
      if (await canLaunchUrl(telegramUrl)) {
        await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: const SharedAppBar(
          title: 'نبذة عن الأستاذ',
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teacher Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.primary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: context.primary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: Image.asset(
                  'assets/images/natheer.jpg',
                  width: 180,
                  height: 240,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter, // Focus on the bottom half where the person is
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Name
            Text(
              'المهندس نذير الجنيد',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.primary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle / Specialty
            Text(
              'المدير الأكاديمي للمنصة | مدرس رياضيات',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Contact Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // WhatsApp Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(context),
                    icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'واتساب',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), // WhatsApp Color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Telegram Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchTelegram(context),
                    icon: const Icon(Icons.telegram_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'تيليجرام',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088cc), // Telegram Color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                        elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Biography Section Title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'نبذة تعريفية',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Biography Text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: AppBorder.main_border,
              ),
              child: Text(
                'أنا المهندس نذير الجنيد، طالب في كلية الهندسة بجامعة تعز، تخصص هندسة الأمن السيبراني والشبكات، ومدرس رياضيات بخبرة تمتد لأكثر من اربع سنوات في المجال التعليمي.\n\n'
                'اكتسبت خبرة عملية في تدريس الرياضيات من خلال عملي في مدرسة الفلاح أكملة المسجد، وكذلك في جامعة تعز في السنوات الأولى، بالإضافة إلى بعض المعاهد، كما أمتلك خبرة واسعة في التدريس الإلكتروني عبر منصة Zoom لطلاب الثانوية والجامعة باستخدام أساليب تعليمية احترافية تضمن التفاعل وتحقيق أفضل النتائج للطلاب.\n\n'
                'أقدم دروسًا خصوصية للطلاب حضوريًا وعبر الإنترنت لكل المراحل، وأتخصص في تدريس الرياضيات لطلاب المرحلة الثانوية والجامعية، إلى جانب إعداد وتأهيل الطلاب لاجتياز شهادة CSCA الصينية من خلال شرح منهجي وتدريب مكثف على المهارات المطلوبة.\n\n'
                'ولا يقتصر دوري على شرح المادة العلمية فحسب، بل أحرص أيضًا على توجيه الطلاب إلى أفضل أساليب التعلم، وتنمية مهارات التفكير الرياضي، وبناء خطة دراسية فعّالة تساعدهم على فهم الرياضيات بعمق وتحقيق التميز الأكاديمي.\n\n'
                'أؤمن بأن التعليم رسالة، وأن النجاح يتحقق عندما يُقدَّم العلم بأسلوب واضح، ومنهجي، ومبني على الفهم الحقيقي، وهو ما أسعى إلى تحقيقه من خلال منصة الجنيد التعليمية لتكون مرجعًا موثوقًا وداعمًا لكل طالب يسعى إلى التفوق والنجاح.',
                style: context.textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 15,
                  color: context.colorScheme.onBackground.withOpacity(0.8),
                ),
                textAlign: TextAlign.right, // Better alignment for Arabic
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),)
    );
  }
}
