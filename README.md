ExpenseTracker
Record income & expenses, track your running balance, and convert between currencies — fast, clean, and scalable.

 Highlights
Track income, expenses & balance effortlessly

Built-in currency conversion

Lazy-loading pagination for smooth scrolling

Multi-language support (English / Arabic)

Clean Architecture + BLoC for state management

Dependency Injection with GetIt

 Architecture Overview
This project follows Clean Architecture principles, ensuring scalability, testability, and clear separation of concerns.

Layers
Presentation (Flutter UI)

BLoC (Events, States, Logic)

Domain (Pure Dart)

Entities

UseCases

Repositories (abstract)

Data (Implementation)

Models (DTOs)

Data Sources (Local / Remote)

Repository Implementations

 Layers Detailed
Layer	Components
Data Layer	Models (DTOs), Data Sources (API, SQLite, SharedPrefs), Repository implementations
Domain Layer	Entities, Repository contracts, Use Cases (business logic)
Presentation Layer	Pages, Widgets, and BLoC (managing events & states)
⚙️ State Management (BLoC)
The app uses the BLoC pattern for predictable & testable UI workflows:

Event: User interaction (e.g., AddExpense)

Bloc: Handles event, calls use case

Use Case: Contains business logic

Repository: Fetches or stores data

State: UI rebuilds reactively

 API & Data Handling
Remote Data Source uses HTTP requests via dio

Functional-style error handling with Either for success/failure

Repository bridges domain and data layers

Local lazy-loading pagination through lazy_load_scrollview package

 Development Environment
Flutter SDK: 3.32.4

Responsive UI: flutter_screenutil

Localization: easy_localization (English/Arabic)

Dependency Injection: get_it

Database: sqflite

 How to Run
bash
# Clone the repo
git clone https://github.com/zeyadtarek1999/Expense-Tracker.git

# Navigate into the project directory
cd Expense-Tracker

# Install dependencies
flutter pub get

# Generate localization keys
flutter pub run easy_localization:generate -S assets/languages -f keys -o locale_keys.g.dart

# Generate assets and fonts (if applicable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
Make sure to configure your API keys or environment variables as required.

 Screenshots
<img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_41_22.png" alt="Screenshot 1" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_41_58.png" alt="Screenshot 2" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_04.png" alt="Screenshot 3" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_16.png" alt="Screenshot 4" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_22.png" alt="Screenshot 5" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_30.png" alt="Screenshot 6" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_48.png" alt="Screenshot 7" width="300" />