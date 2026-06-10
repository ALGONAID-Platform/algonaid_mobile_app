import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid_mobile_app/features/search/presentation/providers/search_courses_provider.dart';
import 'package:algonaid_mobile_app/features/search/presentation/widgets/search_courses_tab.dart';
import 'package:algonaid_mobile_app/features/search/presentation/widgets/search_lessons_tab.dart';
import 'package:algonaid_mobile_app/features/search/presentation/widgets/search_modules_tab.dart';
import 'package:algonaid_mobile_app/features/search/presentation/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: context.background,
            appBar: AppBar(
              toolbarHeight: 80,
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SearchTextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<SearchCoursesProvider>().searchCourses(query);
                    setState(() {}); // Trigger rebuild to show/hide suffix icon
                  },
                  onClear: () {
                    _searchController.clear();
                    context.read<SearchCoursesProvider>().clearSearch();
                    setState(() {}); // Trigger rebuild to hide suffix icon
                  },
                ),
              ),
              bottom: TabBar(
                labelColor: context.primary,
                unselectedLabelColor: context.colorScheme.onSurface.withOpacity(0.5),
                indicatorColor: context.primary,
                indicatorWeight: 3,
                labelStyle: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                unselectedLabelStyle: context.textTheme.titleSmall,
                tabs: const [
                  Tab(text: 'الكورسات'),
                  Tab(text: 'الوحدات'),
                  Tab(text: 'الدروس'),
                ],
              ),
            ),
            body: Consumer<SearchCoursesProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        provider.error!,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (provider.currentQuery.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.search_rounded,
                    title: 'البحث',
                    subtitle: 'أدخل كلمة البحث للبدء',
                  );
                }

                if (provider.courses.isEmpty && provider.modules.isEmpty && provider.lessons.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'لا توجد نتائج',
                    subtitle: 'لا توجد نتائج مطابقة لبحثك',
                  );
                }

                return TabBarView(
                  children: [
                    SearchCoursesTab(courses: provider.courses),
                    SearchModulesTab(modules: provider.modules),
                    SearchLessonsTab(lessons: provider.lessons),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
