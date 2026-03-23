# 📌 Constants

## Overview
Stores static, hardcoded configurations, texts, and endpoint paths. This folder acts as a central registry to avoid hardcoded "magic strings" globally within application layouts.

## Key Files & Functions
- **`api_config.dart` / `endpoints.dart`**: Stores the backend Base URLs and precise API mapping endpoints (e.g., `/auth/login`).
- **`app_strings.dart`**: A raw collection of all textual strings visible to the end student. By localizing texts here, future multi-language adaptation (like translating to English or retaining Arabic) becomes vastly simpler.
- **`assets.dart`**: Defines strict constants referencing graphical paths (e.g., `assets/images/logo.png`) preventing simple typo-crashes.
- **`app_constants.dart`**: Assorted hardcoded values, like global padding sizes, HTTP timeout durations, or grid limits.

## Relationships
- Almost every layer interfaces with this folder. The `network` folder inherently digests `endpoints`, while the `presentation` layer consumes `assets` and `app_strings`.
