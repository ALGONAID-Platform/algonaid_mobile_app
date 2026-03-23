# ⚠️ Errors

## Overview
This folder standardizes how errors and exceptions are handled and reported across every layer of the platform.

## Key Files & Functions
- **`exception.dart`**: Defines hard app exceptions, representing internal or API failures (e.g., `ServerException`, `CacheException`). These are typically thrown by the Data layer (API or Local Storage).
- **`failure.dart`**: Defines expected "Failures" (e.g., `ServerFailure`, `NetworkFailure`). These act as safe, typed models that the Domain Layer returns to the Presentation layer instead of randomly crashing the app.

## Relationships
- **Data Layer & Network (`lib/core/network`)** throw `Exceptions`.
- **Repositories** catch these `Exceptions` and convert them into `Failures` (from this folder) using the `Either<Failure, Data>` object.
