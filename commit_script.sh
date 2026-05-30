#!/bin/bash
set -e

# Group 1: UI Components
git add lib/core/widgets/shared/app_bottom_sheet.dart lib/core/widgets/shared/app_empty_state.dart lib/core/widgets/shared/show_dialog.dart
git commit -m "feat: Refactor and introduce AppBottomSheet and AppEmptyState components" || true

# Group 2: Shimmer Loading
git add lib/core/widgets/loading/continueLearningShimmer.dart lib/core/widgets/loading/courseCardShimmer.dart lib/core/widgets/loading/shimmer_loading.dart lib/features/courses/presentation/widgets/buildShimmerSection.dart
git commit -m "feat: Implement Shimmer Loading States across app modules" || true

# Group 3: Video Settings and Lessons
git add lib/features/lessons/
git commit -m "feat: Introduce Advanced Video Settings and update Lessons feature" || true

# Group 4: Settings and Theme
git add lib/features/settings/ lib/core/theme/ lib/features/profile/presentation/widgets/settings_section.dart
git commit -m "feat: Add Global App Settings page and configurations" || true

# Group 5: Course and Module Grades
git add lib/features/courses/data/models/course_grades_model.dart lib/features/courses/domain/entities/course_grades.dart lib/features/courses/domain/usecases/get_course_grades.dart lib/features/courses/presentation/providers/course_grades_provider.dart lib/features/courses/presentation/widgets/course_grades_widget.dart
git add lib/features/modules/data/models/module_grades_model.dart lib/features/modules/domain/entities/module_grades.dart lib/features/modules/domain/usecases/get_module_grades.dart lib/features/modules/presentation/providers/module_grades_provider.dart lib/features/modules/presentation/widgets/module_grades_widget.dart
git add lib/features/courses/data/datasources/courses_remote_data_source.dart lib/features/courses/data/models/course_model.dart lib/features/courses/data/models/teacher_model.dart lib/features/courses/data/models/user_model.dart lib/features/courses/data/repositories/courses_repository_impl.dart lib/features/courses/domain/repositories/courses_repository.dart
git add lib/features/modules/data/datasources/ lib/features/modules/data/models/module_model.dart lib/features/modules/data/repositories/module_repository_impl.dart lib/features/modules/domain/repositories/module_repository.dart
git commit -m "feat: Implement Course and Module Grades architecture" || true

# Group 6: Profile and Auth Flows
git add lib/features/auth/ lib/core/utils/functions/check_user_auth_token.dart lib/features/onboard/ lib/features/profile/
git commit -m "feat: Enhance User Profile and Onboarding Flows" || true

# Group 7: Excellence Courses and UI
git add lib/features/excellence_courses/ lib/features/courses/ lib/features/modules/
git commit -m "feat: Add Excellence Courses section and update Courses/Modules UI" || true

# Group 8: New Features
git add lib/features/notifications/ lib/features/downloads/ lib/features/search/
git commit -m "feat: Add Notifications, Downloads, and Search features" || true

# Group 9: Exams
git add lib/features/exams/
git commit -m "feat: Update Exams feature and models" || true

# Group 10: Core Architecture
git add android/ pubspec.yaml .metadata lib/core/constants/ lib/core/di/ lib/core/errors/ lib/core/network/ lib/core/routes/ lib/core/utils/providers/ lib/main.dart
git commit -m "fix: Core architecture routing, API updates, and cleanup" || true

# Push
git push origin dashboard
