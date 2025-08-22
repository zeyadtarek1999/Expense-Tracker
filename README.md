<h1 align="center">ExpenseTracker</h1>

<p align="center">
  Record <b>income & expenses</b>, track your <b>running balance</b>, and <b>convert between currencies</b> — fast, clean, and scalable.
</p>

---

##  Highlights
-  Track income, expenses & balance effortlessly
-  Built-in currency conversion
-  Lazy-loading pagination for smooth scrolling
-  Multi-language support (English / Arabic)
-  Clean Architecture + BLoC for state management
-  Dependency Injection with GetIt

---

##  Architecture Overview

This project follows **Clean Architecture** principles for scalability, testability, and clear separation of concerns.

Presentation (Flutter UI)
└─ BLoC (Events, States, Logic)

Domain (Pure Dart)
├─ Entities
├─ UseCases
└─ Repositories (abstract)

Data (Implementation)
├─ Models (DTOs)
├─ Data Sources (Local / Remote)
└─ Repository Implementations



### 🔹 Layers Detailed

| Layer              | Components                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Data Layer**     | Models (DTOs), Data Sources (API, SQLite, SharedPrefs), Repository impls    |
| **Domain Layer**   | Entities, Repository contracts, Use Cases (business logic)                  |
| **Presentation**   | Pages, Widgets, and **BLoC** (managing events & states)                     |

---

## 🔄 State Management (BLoC)

Predictable & testable UI workflows:

1. **Event** → User interaction (e.g., `AddExpense`)
2. **Bloc** → Handles event, invokes use case
3. **Use Case** → Runs business logic
4. **Repository** → Fetches / stores data
5. **State** → UI rebuilds reactively

---

## 🌐 API & Data Handling

- **Remote Data Source** — HTTP requests via `dio`
- **Error Handling** — Functional style with `Either` (success / failure)
- **Repository** — Bridges domain and data layers
- **Pagination** — Local lazy-loading using `lazy_load_scrollview` for smooth infinite scroll

---

## ⚙️ Development Environment

- **Flutter SDK:** 3.32.4
- **Responsive UI:** `flutter_screenutil`
- **Localization:** `easy_localization` (English / Arabic)
- **Dependency Injection:** `get_it`
- **Database:** `sqflite`

---

## ▶️ How to Run

```bash
# Clone the repo
git clone https://github.com/zeyadtarek1999/Expense-Tracker.git

# Navigate into the project directory
cd Expense-Tracker

# Install dependencies
flutter pub get

# Generate localization keys
flutter pub run easy_localization:generate -S assets/languages -f keys -o locale_keys.g.dart

# (Optional) Generate assets / code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run


📸 Screenshots
<img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_41_22.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_41_58.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_04.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_16.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_22.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_30.png" width="300" /> <img src="https://user-images.githubusercontent.com/yourusername/screenshots/Simulator_Screenshot_iPhone_15_Pro_2025_08_22_22_42_48.png" width="300" /> ``
