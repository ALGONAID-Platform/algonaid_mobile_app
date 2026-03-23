# 🎨 Theme

## Overview
Centralizes the visual aesthetic of the Algonaid Platform. This makes sure the UI is uniform and any design alteration happens magically across the entire app by editing a single place.

## Key Files & Functions
- **`colors.dart`**: Every hex code used (primary brand colors, grayscaled background surfaces, and semantic error colors) exists here.
- **`styles.dart`**: Defines text typography, containing generic styles like `headingStyle` and standard `bodyText`, ensuring font consistency everywhere.
- **`theme.dart`**: Aggregates the colors and typography to construct a global `ThemeData` object. This is fed directly into the core `MaterialApp` widget.
- **`app_shadows.dart` & `animation.dart`**: Store standardized shadow objects (box shadows for cards) and generic micro-animations used locally inside widgets.

## Relationships
- Heavily utilized by the **`widgets`** directory and all `presentation` layers of specific features to maintain the brand aesthetic without writing explicit RGB colors.
