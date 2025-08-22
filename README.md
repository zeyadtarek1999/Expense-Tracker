<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>ExpenseTracker README</title>
<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f9fafb;
    color: #333;
    line-height: 1.6;
    margin: 0;
    padding: 20px;
  }
  h1 {
    color: #1f2937;
    font-size: 2.8rem;
    margin-bottom: 0.5rem;
  }
  h2 {
    color: #111827;
    border-bottom: 2px solid #3b82f6;
    padding-bottom: 0.3rem;
    margin-top: 2rem;
  }
  h3 {
    color: #2563eb;
    margin-top: 1.5rem;
  }
  ul {
    margin-top: 0.5rem;
    margin-left: 1.2rem;
  }
  ul li {
    margin-bottom: 0.6rem;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1rem;
  }
  th, td {
    border: 1px solid #d1d5db;
    padding: 10px 15px;
    text-align: left;
  }
  th {
    background-color: #3b82f6;
    color: white;
  }
  code {
    background: #e5e7eb;
    padding: 0.2rem 0.4rem;
    border-radius: 4px;
    font-family: 'Courier New', Courier, monospace;
  }
  pre {
    background: #1e293b;
    color: #f8fafc;
    padding: 1rem;
    border-radius: 6px;
    overflow-x: auto;
    margin-top: 1rem;
  }
  /* Layout container */
  .container {
    max-width: 900px;
    margin: auto;
  }
  .highlight {
    color: #2563eb;
    font-weight: 600;
  }
</style>
</head>
<body>
<div class="container">
  <h1>ExpenseTracker</h1>
  <p><strong>Record income & expenses, track your running balance, and convert between currencies — fast, clean, and scalable.</strong></p>

  <section>
    <h2>Highlights</h2>
    <ul>
      <li>Track income, expenses & balance effortlessly</li>
      <li>Built-in currency conversion</li>
      <li>Lazy-loading pagination for smooth scrolling</li>
      <li>Multi-language support (English / Arabic)</li>
      <li>Clean Architecture + BLoC for state management</li>
      <li>Dependency Injection with GetIt</li>
    </ul>
  </section>

  <section>
    <h2>Architecture Overview</h2>
    <p>This project follows <span class="highlight">Clean Architecture</span> principles, ensuring scalability, testability, and clear separation of concerns.</p>

    <h3>Layers</h3>
    <ul>
      <li><strong>Presentation (Flutter UI):</strong>
        <ul>
          <li>BLoC (Events, States, Logic)</li>
        </ul>
      </li>
      <li><strong>Domain (Pure Dart):</strong>
        <ul>
          <li>Entities</li>
          <li>UseCases</li>
          <li>Repositories (abstract)</li>
        </ul>
      </li>
      <li><strong>Data (Implementation):</strong>
        <ul>
          <li>Models (DTOs)</li>
          <li>Data Sources (Local / Remote)</li>
          <li>Repository Implementations</li>
        </ul>
      </li>
    </ul>
  </section>

  <section>
    <h2>Layers Detailed</h2>
    <table>
      <thead>
        <tr>
          <th>Layer</th>
          <th>Components</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Data Layer</td>
          <td>Models (DTOs), Data Sources (API, SQLite, SharedPrefs), Repository implementations</td>
        </tr>
        <tr>
          <td>Domain Layer</td>
          <td>Entities, Repository contracts, Use Cases (business logic)</td>
        </tr>
        <tr>
          <td>Presentation Layer</td>
          <td>Pages, Widgets, and BLoC (managing events & states)</td>
        </tr>
      </tbody>
    </table>
  </section>

  <section>
    <h2>⚙️ State Management (BLoC)</h2>
    <p>The app uses the <strong>BLoC pattern</strong> for predictable & testable UI workflows:</p>
    <ul>
      <li><strong>Event:</strong> User interaction (e.g., AddExpense)</li>
      <li><strong>Bloc:</strong> Handles event, calls use case</li>
      <li><strong>Use Case:</strong> Contains business logic</li>
      <li><strong>Repository:</strong> Fetches or stores data</li>
      <li><strong>State:</strong> UI rebuilds reactively</li>
    </ul>
  </section>

  <section>
    <h2>API & Data Handling</h2>
    <ul>
      <li>Remote Data Source uses HTTP requests via <code>dio</code></li>
      <li>Functional-style error handling with <code>Either</code> for success/failure</li>
      <li>Repository bridges domain and data layers</li>
      <li>Local lazy-loading pagination through <code>lazy_load_scrollview</code> package</li>
    </ul>
  </section>

  <section>
    <h2>🛠 Development Environment</h2>
    <ul>
      <li><strong>Flutter SDK:</strong> 3.32.4</li>
      <li>Responsive UI: <code>flutter_screenutil</code></li>
      <li>Localization: <code>easy_localization</code> (English/Arabic)</li>
      <li>Dependency Injection: <code>get_it</code></li>
      <li>Database: <code>sqflite</code></li>
    </ul>
  </section>

  <section>
    <h2>🚀 How to Run</h2>
    <pre><code>git clone https://github.com/zeyadtarek1999/Expense-Tracker.git
cd Expense-Tracker
flutter pub get
flutter pub run easy_localization:generate -S assets/languages -f keys -o locale_keys.g.dart
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
</code></pre>
  </section>
</div>
</body>
</html>

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