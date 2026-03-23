# 🧩 Common

## Overview
The common folder contains shared, feature-independent technical elements, specifically enumerations and type definitions. It is critical for streamlining Dart code syntax throughout the project.

## Key Folders & Functions
- **`enums/`**: Contains simple enumeration states used globally across screens, specifically API loading status enumerations (e.g., `Initial`, `Loading`, `Success`, `Error`). 
- **`type_def/`**: Contains custom Dart Type Definitions (aliases) to shorten highly complex types. For instance, `Either<Failure, T>` might be redefined to avoid constantly retyping the lengthy functional definitions imported heavily from the Dartz package.

## Relationships
- The **`type_def`** directory is deeply tied into the entire Clean Architecture pipeline (**Domain**, **Data**, and **Presentation** layer functions constantly declare these shortened aliases).
