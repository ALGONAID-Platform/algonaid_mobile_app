# ⚙️ Use Cases (Base)

## Overview
This folder provides the abstract contracts forming the foundation of Domain Operations (Use Cases) according to the Clean Architecture philosophy set for the Algonaid Platform.

## Key Files & Functions
- **`use_case.dart`**: Contains an abstract generic class that forces every standard Use Case within the application's domain layer to strictly implement a `call(parameters)` method. Crucially, it must return an `Either<Failure, Type>`, cleanly capturing any backend exceptions.
- **`no_param_use_case.dart`**: Identical to above, except built specifically for Use Cases that require zero initial input properties (for instance, an operation pulling all generic courses).

## Relationships
- This completely dictates how the **Domain Layer** integrates with the **Presentation Layer** (`Providers`). Providers fire this `call` method, pass expected structures in, and either receive a success object or a formatted `Failure`.
