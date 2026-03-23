# 🌐 Network

## Overview
This folder handles all HTTP communication between the application and the **NestJS backend**. It acts as the backbone for data synchronization and API consumption.

## Key Files & Functions
- **`initial_dio.dart`**: Configures the generic Dio HTTP client. It defines the base connection rules, sets timeouts, and injects authentication tokens (Interceptors) into outgoing request headers.
- **`api_service.dart`**: The central repository for simple, generic CRUD API operations (e.g., standard GET, POST methods).
- **`execute_request.dart`**: A highly safely-typed wrapper function. Its purpose is to execute any API call natively, catch any exceptions (e.g., parsing issues, broken connections), and pass them systematically to the error pipeline to be handled gracefully.
- **`dio_error_handler.dart`**: Translates low-level HTTP status codes (like 401 Unauthorized or 404 Not Found) into human-readable messages that the user interface can display.
- **`check_internet.dart`**: A simple utility to verify the device's internet continuity before attempting an outgoing request.

## Relationships
- Relies heavily on the **`errors`** folder to map internal `Exceptions` to UI-friendly `Failures`.
- It is initialized and injected application-wide via the **`di`** (Dependency Injection) folder.
