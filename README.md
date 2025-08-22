ExpenseTracker

Record income & expenses, track your running balance, and convert between currencies — fast, clean, and scalable.

Highlights

Track income, expenses & balance

Built-in currency conversion

Lazy-loading pagination for smooth scrolling

Multi-language support (English / Arabic)

Clean Architecture + BLoC state management

Dependency Injection with GetIt

Architecture Overview

This project follows Clean Architecture, ensuring scalability, testability, and separation of concerns.

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

Layers

Data Layer → Models (DTOs), Data Sources (API, SQLite, SharedPrefs), Repository implementations

Domain Layer → Entities, Repository contracts, Use Cases (business logic)

Presentation Layer → Pages, Widgets, and BLoC (managing events & states)

State Management (BLoC)

The app uses the BLoC pattern for predictable & testable UI:

Event → User interaction (e.g. AddExpense)

Bloc → Handles event, calls use case

Use Case → Runs business logic

Repository → Fetches/stores data

State → UI rebuilds reactively

API & Data Handling

Remote Data Source → HTTP requests via dio

Error Handling → Functional style (Either) for success/failure

Repository → Bridges domain & data layers

Pagination → Local lazy-loading with lazy_load_scrollview

Development

Flutter SDK: 3.32.4

Responsive UI: flutter_screenutil

Localization: easy_localization (English/Arabic)

Dependency Injection: get_it

Database: sqflite

How to Run

Clone the repo:

git clone https://github.com/zeyadtarek1999/Expense-Tracker.git


Install dependencies:

flutter pub get


Run the app:

flutter run




![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.41.22.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.41.22.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.41.58.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.41.58.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.42.04.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.42.04.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.42.16.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.42.16.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.42.22.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.42.22.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.42.30.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.42.30.png)
![Simulator Screenshot - iPhone 15 Pro - 2025-08-22 at 22.42.48.png](../../Documents/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202025-08-22%20at%2022.42.48.png)