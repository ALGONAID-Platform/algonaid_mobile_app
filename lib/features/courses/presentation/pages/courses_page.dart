import 'package:flutter/material.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/explore_course_card.dart';
class CoursesPage extends StatelessWidget {
  CoursesPage({super.key});

  final List courses = [
    {
      'image': 'images/math.jpg',
      'title': 'الاشتقاق - تفاضل وتكامل',
      'description': 'تعلم أساسيات التفاضل والتكامل مع تطبيقات عملية...',
      'subjectTag': 'الرياضيات',
      'timeRemaining': '10 دقائق متبقية',
      'coursesCount':12,
    },
    {
      'image': 'images/physics.jpg',
      'title': 'فيزياء الكم',
      'description': 'مقدمة في عالم الذرة والجزيئات...',
      'subjectTag': 'الفيزياء',
      'timeRemaining': '25 دقيقة متبقية',
      'coursesCount':12,
    },
    {
      'image': 'images/physics.jpg',
      'title': 'الدورة الرابعة',
      'description': 'الدورة الرابعة',
      'subjectTag': 'الدورة الرابعة',
      'timeRemaining': 'الدورة الرابعة',
      'coursesCount':12,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage("assets/images/user_profile.png"),
            ),
            title: const Text(
              "أحمد الجنيد",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("طالب", style: TextStyle(fontSize: 12)),
            trailing: IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {},
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.menu_open, color: Colors.green[700]),
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text("الإعدادات")),
                const PopupMenuItem(child: Text("عن التطبيق")),
              ],
            ),
          ],
        ),
      
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "أهلا بك في صفحة الدورات 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "تابع دروسك من حيث توقفت",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
      
              ContinueLearningCard(courseData: courses[0]),
      
              const SizedBox(height: 30),
      
              const Text(
                "اكتشف جميع الدورات",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
      
              ListView.builder(
                itemCount: courses.length - 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var currentCourse = courses[index + 1];
      
                  return ExploreCourseCard(item: currentCourse);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
