# 🛠️ Utils

## Overview
The utilities folder contains generic toolsets, validations, and helper functions that actively simplify operations without containing specialized feature logic.

## Key Folders & Functions
- **`hive/` & `cache/`**: Sets up wrapper implementations specifically aimed at simplifying offline NoSQL storage (Hive). Used directly for actions saving primitive logic data locally, such as student Session Tokens and User Profiles.
- **`validations/`**: Contains generic String extensions and validator functions checking text formatting (e.g., validating the structure of an email, checking password lengths, or verifying phone numbers). Used by `Form` elements.
- **`functions/`**: Standard pure calculation algorithms and custom Dart Type Extensions. 

## Relationships
- **`validations/`** connects tightly to generic text inputs in the `presentation` layer.
- **`hive`** is connected inside `service_locator.dart` (DI) and primarily operates within feature `data/sources` to establish offline caching systems.
