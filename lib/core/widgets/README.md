# 🧱 Widgets

## Overview
House of atomic, highly reusable User Interface components. Any widget designed to be used across multiple entirely separate features belongs here, to ensure developers do not redundantly recreate graphical components.

## Key Folders & Functions
- **`buttons/`**: Standardized Primary, Secondary, and Text actionable buttons formatted exclusively to match the platform's custom aesthetic.
- **`dialogs/`**: Reusable generic alert boxes (e.g., error alert, standard success confirmation). 
- **`loading/`**: Custom spinning indicators and skeleton Shimmer effects, heavily utilized during network loading delays.
- **`shared/`**: Generalized elements, such as customized `TextFormField` inputs styled correctly for the student authentication and search menus.

## Relationships
- Widgets heavily import the **`theme`** folder properties (`colors` and `styles`) locally. 
- These widgets are then purely consumed independently by all feature `presentation` screens globally.
