import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class AllCoursesListSection extends StatelessWidget {
  final List<CourseEntity> allCourses;

  const AllCoursesListSection({super.key, required this.allCourses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(
            'كل الكورسات',
            style: Styles.style18(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        // إذا كانت القائمة فارغة، نظهر الصندوق الجمالي
        if (allCourses.isEmpty)
          _buildAllEnrolledCard(context)
        else
          // إذا كانت تحتوي على كورسات، نظهر القائمة الأفقية
          SizedBox(
            height: 330,
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(right: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: allCourses.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(left: 16),
                  child: CourseCard(course: allCourses[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAllEnrolledCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // ألوان هادئة (خلفية زرقاء فاتحة جداً أو رمادي فاتح)
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 40),
          const SizedBox(height: 16),
          Text(
            "لقد قمت بالتسجيل في كل الكورسات!",
            textAlign: TextAlign.center,
            style: Styles.style16(context).copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "أنت الآن في رحلة تعلم شاملة. في حال توفر عروض أو دورات جديدة، ستظهر لك هنا مباشرة.",
            textAlign: TextAlign.center,
            style: Styles.style14(
              context,
            ).copyWith(color: Colors.blueGrey[600], height: 1.5),
          ),
        ],
      ),
    );
  }
}
