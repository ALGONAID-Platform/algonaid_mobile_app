<div align="center">

#  Algonaid Educational Platform
**Frontend Application (Flutter)**
<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/State_Management-Provider-%2300BCD4.svg?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Dio-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Get__It-FFD700?style=for-the-badge&logo=dart&logoColor=black" />
  <img src="https://img.shields.io/badge/Backend-NestJS-red?style=for-the-badge&logo=nestjs" />
  <img src="https://img.shields.io/badge/Architecture-Clean_Architecture-%234B0082.svg?style=for-the-badge" />
</p>
*This project is built using the Agile software development methodology and is organized and developed by a dedicated technical team*

</div>

##  Overview
This repository contains the Frontend source code for the "Algonaid Educational Platform". The application is built using the **Flutter** framework to provide a smooth user experience (UX) and high performance across multiple devices. The project is strictly structured using **Clean Architecture**, relies on **Provider** for state management, and connects directly to a **NestJS** backend server.

---

##  Architecture (Clean Architecture)
We use **Clean Architecture** to ensure that the application is scalable, maintainable, and testable. The architecture divides the project into independent layers, separating the business rules from the user interface and external data sources.
```
lib/
├── core/
│   ├── common/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── usecases/
│   ├── utils/
│   └── widgets/
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── courses/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── modules/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── lessons/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── cubit/
│           ├── pages/
│           └── widgets/
│
├── init/
│
├── injection_container.dart
│
└── main.dart

```
## 🛠️ Tech Stack & Dependencies

This project leverages a modern set of libraries and tools to ensure high performance, scalability, and strict adherence to **Clean Architecture** principles.

### 📦 Packages
| Category | Library | Usage in Al-Gonaid Platform |
| :--- | :--- | :--- |
| **Framework** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) | Cross-platform development for Mobile and Web. |
| **Language** | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white) | Core programming language for the frontend. |
| **State Management** | ![Provider](https://img.shields.io/badge/Provider-00BCD4?style=flat-square&logo=flutter) | Managing application state and logic separation. |
| **Networking** | ![Dio](https://img.shields.io/badge/Dio-0175C2?style=flat-square&logo=dart) | Handling HTTP requests and Interceptors for the NestJS API. |
| **Service Locator** | ![GetIt](https://img.shields.io/badge/Get__It-FFD700?style=flat-square&logo=dart&logoColor=black) | Dependency Injection (DI) for repositories and services. |
| **Navigation** | ![GoRouter](https://img.shields.io/badge/GoRouter-02569B?style=flat-square&logo=flutter) | Declarative routing and deep linking support. |
| **Local Storage** | ![Hive](https://img.shields.io/badge/Hive-FF6D00?style=flat-square&logo=dart) | Fast NoSQL database for caching and offline lessons. |
| **Functional Programming** | ![Dartz](https://img.shields.io/badge/Dartz-4B0082?style=flat-square&logo=dart) | Error handling using `Either` (Failure/Success) pattern. |

### 🎨 UI & Enhanced User Experience
| Library | Role & Purpose |
| :--- | :--- |
| **Syncfusion PDFViewer** | High-performance rendering for mathematics lessons and documents. |
| **Cached Network Image** | Optimized loading and disk caching for web-hosted images. |
| **Shimmer** | Providing modern skeleton loading states during data fetching. |

---

##  State Management (Provider)
The application relies strictly on **Provider** as the primary state management solution. This ensures a clean separation of the User Interface (UI) from the business logic.

- **ChangeNotifier:** We use classes extending `ChangeNotifier` to hold the application state. When the logic processes user actions (like requesting data from the server), it updates its variables and calls `notifyListeners()`.
- **UI Reactivity:** The UI layer listens to these Providers using tools like `Consumer` or `context.watch()`. When `notifyListeners()` is triggered, only the specific parts of the UI that depend on that state are updated, keeping the performance highly optimized.

---

##  Backend Integration
The frontend is fully integrated with a custom backend built on **NestJS**. We use robust network libraries in Flutter (specifically **Dio**) to ensure fast, stable, and reliable API requests.

- **Clients & Interceptors:** The HTTP Client is configured to automatically inject authentication Tokens into the headers of every request.
- **Error Handling:** Network errors (such as 401 Unauthorized or 500 Internal Server Error) are caught centrally and converted into clear, user-friendly error messages using Dartz.
ex: ``` Future<Either<Failure, UserEntity>> login(String email, String password); ```
- **Endpoints:** All defined API endpoints are perfectly aligned with the NestJS server routes to ensure full integration for data exchange and displaying lessons.

---

##  Models & Data Parsing
When receiving a JSON Response from our precise **NestJS** servers, this data needs to be converted into usable Objects within the Flutter (Dart) environment.

- **Parsing (JSON to Objects):** We use Factory Constructors (like `fromJson()`) inside our Model classes to read the incoming JSON structure (which is a `Map<String, dynamic>`) and assign each field's value to its corresponding variable in the Dart class.
- **Serialization:** To send data payloads back to the backend (like sending login credentials), we use the `toJson()` method. This converts the Dart Objects back into JSON format so it can be effectively sent in the body of an HTTP Request.
- **Data Safety:** The models ensure the application does not crash if a specific field is missing from the server by utilizing safe null handling (Null Safety) and assigning default values.

---

##  Technical Features
The application currently includes a set of core features required to manage an educational platform effectively:

-  **Authentication System (Login):** Includes a login screen and user authentication to secure access, with the ability to safely save the user session Token locally.
-  **Lessons Display:** A clean view to browse the list of available lessons, allowing the user to seamlessly access the educational content of the platform.
-  As development continues through the Agile process, all targeted features are being actively integrated to ensure the best possible application build.

---

##  Getting Started & Execution

To successfully run the project on your local environment without any technical issues, please follow these steps:

### 1. Prerequisites
Ensure you have the following installed:
* **Flutter SDK:** Latest stable version.
* **Java Development Kit (JDK):** Version 17 or 11.
* **Android Studio / VS Code:** With Flutter & Dart plugins.
* **Emulator/Device:** An active Android Emulator, iOS Simulator, or a physical device with USB debugging enabled.

### 2. Environment Setup
Before running the app, make sure it can communicate with your **NestJS Backend**:
1. Open `lib/core/constants/api_config.dart` (or your specific config file).
2. Update the `BASE_URL` to match your server's IP address:
   * **Android Emulator:** Use `http://10.0.2.2:3000`
   * **Physical Device:** Use your computer's local IP (e.g., `http://192.168.1.x:3000`)
   * **Web:** Use `http://localhost:3000`

### 3. Installation & Build
Run the following commands in your terminal:

```bash
# 1. Fetch all dependencies
flutter pub get

# 2. Generate necessary code (Models/BLoCs)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Clean the project (Optional - recommended for first-time setup)
flutter clean
flutter pub get
```

##  Development Team
- **Bashar Al-himyary** (بشار الحميري)
- **Ayman Al-Malaiki** (أیمن الملايكي)
- **Abdullah Abdulrahman** (عبد الله عبد الرحمن)
- **Khalid Al-Shaibani** (خالد الشيباني)
- **Hamza Abdulmuttalib** (حمزة عبد المطلب)

*This documentation was prepared to ensure high code quality, sustainability, and to make it easy for new members to join the Algonaid Educational Platform technical team.*
