import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/features/onboard/domain/entity/onboarding_entity.dart';

class OnboardingData {
  static List<OnboardingEntity> get items => [
    // 1. التركيز على التبسيط (حل مشكلة التعقيد)
    OnboardingEntity(
      title: "وداعاً لتعقيد الرياضيات",
      description:
          "حوّل المعادلات الصعبة إلى مفاهيم بسيطة من خلال شروحات مبتكرة مصممة لتناسب جميع المستويات الدراسية.",
      image_url: SVG.onboarding2,
    ),

    // 2. البديل المقترح (التركيز على جودة المحتوى والشمولية)
    OnboardingEntity(
      title: "محتوى تعليمي شامل",
      description:
          "استمتع بمشاهدة الدروس  تصفح الملخصات الذكية، واختبر مستواك عبر بنك أسئلة متجدد وشامل.",
      image_url: SVG.onboarding3,
    ),

    // 3. التركيز على التنظيم (بدلاً من التشتت)
    OnboardingEntity(
      title: "مسارات دراسية منظمة",
      description:
          "رتب جدولك الدراسي بذكاء وتابع تقدمك في المنهج خطوة بخطوة دون عناء البحث أو التشتت بين المصادر.",
      image_url: SVG.onboarding4,
    ),

    // 4. الانطلاق (دعوة للعمل)
    OnboardingEntity(
      title: "رحلتك نحو التفوق تبدأ الآن",
      description:
          "انضم إلى منصة الجنيد التعليمية وابدأ رحلة التميز الأكاديمي بأدوات تعليمية متطورة مصممة خصيصاً لنجاحك.",
      image_url: SVG.onboarding1,
    ),
  ];
}
