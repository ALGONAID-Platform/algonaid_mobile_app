# 🛤️ Routes

## Overview
This folder is the "Traffic Controller" of the application. It entirely manages the navigation and how the app moves between different visual screens using the **GoRouter** package.

## Key Files & Functions
- **`appRouters.dart`**: The central configuration that maps visual strings (like `/login` or `/home`) to directly build their corresponding visual Flutter Screens.
- **`paths_routes.dart`**: Stores all the route names logically as constants (e.g., `static const loginRoute = '/login';`). This guarantees the team avoids typing errors.
- **`authGuard.dart`**: Acts as a middleware or a security checkpoint. If a user tries to access the "Courses" screen but doesn't have a valid active login session, this guard automatically intercepts and redirects them back to the login screen.
- **`navigatorKey.dart`**: A global navigation key providing global access to GoRouter programmatically, meaning navigation actions can happen even when a generic context object isn't available.

## Relationships
- Binds all independent Feature UI screens (`lib/features/.../presentation/screens`) together into a single navigable graph.
