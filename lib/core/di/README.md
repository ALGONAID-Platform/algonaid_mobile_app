# 💉 Dependency Injection (DI)

## Overview
The Dependency Injection (DI) folder sets up global services required across the app using the `GetIt` package constraint. It operates like a factory that produces classes only exactly when required, optimizing RAM utilization.

## Key Files & Functions
- **`service_locator.dart`**: The master initialization script. Inside this file, all core utilities (like the central Dio network object), data sources, functional repositories, and finally business Use Cases are "registered".

## Relationships
- In Clean Architecture, when a Provider (Controller) needs the "LoginUseCase", it does not create the UseCase directly (`new LoginUseCase()`). Instead, it asks the Service Locator (`sl()`) to provide it.
- This layer orchestrates how feature layers (Data -> Domain -> Logic) are stacked vertically together at runtime.
