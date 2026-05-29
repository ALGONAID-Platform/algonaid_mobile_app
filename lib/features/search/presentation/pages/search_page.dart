import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/search/presentation/providers/search_courses_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

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
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن كورس، وحدة، أو درس...',
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: context.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.cancel_rounded, color: context.colorScheme.onSurface.withOpacity(0.5), size: 20),
                              onPressed: () {
                                _searchController.clear();
                                context.read<SearchCoursesProvider>().clearSearch();
                                setState(() {}); // Trigger rebuild to hide suffix icon
                              },
                            )
                          : null,
                    ),
                    onChanged: (query) {
                      context.read<SearchCoursesProvider>().searchCourses(query);
                      setState(() {}); // Trigger rebuild to show/hide suffix icon
                    },
                  ),
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
                // 1. تبويب الكورسات
                provider.courses.isEmpty 
                  ? _buildEmptyState(context, 'لا توجد كورسات مطابقة')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.courses.length,
                      itemBuilder: (context, index) {
                        final course = provider.courses[index];
                        return SizedBox(
                          height: 330,
                          child: CourseCard(course: course),
                        );
                      },
                    ),
                // 2. تبويب الوحدات
                provider.modules.isEmpty 
                  ? _buildEmptyState(context, 'لا توجد وحدات مطابقة')
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.modules.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final module = provider.modules[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.folder_rounded, color: context.primary),
                          ),
                          title: Text(module.title, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.onSurface.withOpacity(0.5)),
                          onTap: () {
                            context.push('${Routes.lessonsList}/${module.id}');
                          },
                        );
                      },
                    ),
                // 3. تبويب الدروس
                provider.lessons.isEmpty 
                  ? _buildEmptyState(context, 'لا توجد دروس مطابقة')
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.lessons.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final lesson = provider.lessons[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.play_circle_fill, color: context.primary),
                          ),
                          title: Text(lesson.title, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.onSurface.withOpacity(0.5)),
                          onTap: () {
                            context.push('${Routes.lessonDetails}/${lesson.id}');
                          },
                        );
                      },
                    ),
              ],
            );
          },
        ),
      ),
     ),
    ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return AppEmptyState(
      icon: Icons.search_off_rounded,
      title: 'لا توجد نتائج',
      subtitle: message,
    );
  }
}
