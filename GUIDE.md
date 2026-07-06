# Detailed Step-by-Step Guide: Flutter To-Do App

Welcome! This document is designed specifically for students or beginners who have **never used Flutter before**. By reading this guide, you will learn the core concepts of Flutter, Dart, MVC architecture, GetX state management, and SQLite (Sqflite) local database storage. 

If you are presenting this project to your teacher, this guide will help you understand every single line of code so you can confidently answer any questions they ask!

---

## Table of Contents
1. [Introduction to Flutter & Dart](#1-introduction-to-flutter--dart)
2. [What is MVC Architecture?](#2-what-is-mvc-architecture)
3. [Understanding State Management (GetX)](#3-understanding-state-management-getx)
4. [Understanding Local Storage (SQLite / Sqflite)](#4-understanding-local-storage-sqlite--sqflite)
5. [Project Folder Structure](#5-project-folder-structure)
6. [Detailed Explanation of Each File](#6-detailed-explanation-of-each-file)
7. [Step-by-Step Tutorial to Recreate This App](#7-step-by-step-tutorial-to-recreate-this-app)
8. [Common Teacher Viva/Presentation Questions](#8-common-teacher-vivapresentation-questions)

---

## 1. Introduction to Flutter & Dart

### What is Flutter?
Flutter is a software development kit (SDK) created by Google. It allows you to build beautiful, natively compiled applications for mobile (Android, iOS), web, and desktop from a **single codebase**. 
* **Widget-based:** In Flutter, everything is a widget. The screen, a button, a text box, or even the padding around a button are all widgets.

### What is Dart?
Dart is the programming language used by Flutter. It is clean, modern, and has object-oriented features similar to Java, C#, and JavaScript.
* **Main entry point:** Every Dart program starts execution inside a function named `main()`.

---

## 2. What is MVC Architecture?

MVC stands for **Model-View-Controller**. It is a software design pattern that divides the app into three interconnected parts to separate how data is handled, how it is presented, and how it is updated.

```
       ┌────────────────────────┐
       │         VIEW           │ (Screen layouts, Buttons, Text fields)
       └─────┬────────────▲─────┘
             │            │
  1. User tap│            │ 3. Update UI
  or input   │            │ (via Obx/GetX)
             ▼            │
       ┌──────────────────┴─────┐
       │      CONTROLLER        │ (Business logic, calls DB, updates state)
       └─────┬────────────▲─────┘
             │            │
  2. Modify  │            │ 2. Fetch Data
  data       │            │
             ▼            │
       ┌──────────────────┴─────┐
       │         MODEL          │ (Defines what a "Task" looks like)
       └────────────────────────┘
```

* **Model (M):** Defines the structure of the data. For example, `TodoModel` defines that a task has a `title`, `description`, `dateTime`, `isCompleted` flag, etc.
* **View (V):** The User Interface (UI). It is what the user sees on the screen (e.g., buttons, lists, text inputs). It should **not** contain calculations or database queries directly.
* **Controller (C):** The brain of the application. It acts as a bridge between the View and the Model. It handles user inputs (like button clicks), modifies the database, updates the screen state, and controls navigation.

---

## 3. Understanding State Management (GetX)

### What is "State"?
State is any data that can change in your app, such as a list of tasks, whether a checkbox is ticked, or what page the onboarding slider is currently on.

### Why do we use GetX?
GetX is a lightweight and powerful state management library for Flutter. It makes it extremely easy to:
1. **Rebuild the UI automatically** when data changes (State Management).
2. **Navigate between screens** without passing `BuildContext` (Route Management).
3. **Share code instances** across different screens (Dependency Injection).

### Key GetX Concepts Used in This App:
* **`.obs` (Observable variables):** By adding `.obs` to a variable, we make it "reactive." This means GetX will constantly watch it for changes.
  * *Example:* `var currentPage = 0.obs;`
* **`Obx` (Observer widget):** In the View, if we wrap a widget with `Obx(() => ... )`, the widget will automatically redraw itself whenever any observable variable inside it changes. No more calling `setState(() {})`!
* **`Get.put()`:** Installs/registers a controller class in memory so it can be accessed from other screens.
* **`Get.find()`:** Finds a controller that was previously loaded into memory using `Get.put()`.
* **`Get.to(() => NextPage())`:** Opens a new screen.
* **`Get.off(() => NextPage())`:** Opens a new screen and destroys the current screen (so the user cannot click the back button to return to the splash/onboarding screen).
* **`Get.back()`:** Closes the current screen or dialog (equivalent to `Navigator.pop`).

---

## 4. Understanding Local Storage (SQLite / Sqflite)

### What is SQLite?
SQLite is a lightweight, relational SQL database engine. Unlike servers like MySQL or PostgreSQL, SQLite stores the entire database in a single file located **directly on the user's mobile device**.

### How does `sqflite` work in Flutter?
We use the `sqflite` plugin to write raw SQL queries, insert items, update rows, and delete tasks.

### Key Database Concepts in this App:
* **Singleton Pattern:** Our database helper class uses `DatabaseHelper._init()` to ensure that only **one connection instance** to the database file is active at a time. This prevents file corruption.
* **Map Serialization:** SQLite doesn't understand Dart objects. It only understands rows of data (represented as a `Map<String, dynamic>` where keys are columns and values are database types).
  * `toMap()` converts a `TodoModel` object into a Map before writing to the database.
  * `fromMap()` reads a Map row from the database and converts it back into a `TodoModel` object.

---

## 5. Project Folder Structure

A well-organized project structure makes code easy to navigate and scale:

```
lib/
├── controllers/
│   ├── onboarding_controller.dart  # Manages Onboarding views & pages
│   ├── splash_controller.dart      # Manages splash timer & route checking
│   └── todo_controller.dart        # Manages all Task database actions & filters
├── models/
│   └── todo_model.dart             # Defines the "TodoModel" structure
├── services/
│   └── db_helper.dart              # SQLite Database helper (Singleton CRUD)
├── utils/
│   └── theme.dart                  # Colors, custom light/dark theme definitions
├── views/
│   ├── home/
│   │   ├── widgets/                # Reusable dashboard widgets
│   │   │   ├── category_filter_list.dart # Horizontal categories tabs
│   │   │   ├── progress_card.dart  # Stats circular indicator card
│   │   │   └── task_card.dart      # Dismissible task card
│   │   └── home_view.dart          # Main dashboard, listing, stats & categories
│   ├── onboarding/
│   │   └── onboarding_view.dart    # 3-slide visual introductory slider
│   ├── splash/
│   │   └── splash_view.dart        # Launch logo screen
│   └── todo/
│       └── todo_detail_view.dart   # Create/Edit/Delete task form view
└── main.dart                       # App initial configuration & startup
```

---

## 6. Detailed Explanation of Each File

### 1. `pubspec.yaml`
This file is the configuration file for the Flutter project. It is written in YAML.
* It declares the name, description, and environment of the app.
* It imports external plugins under the `dependencies:` block:
  * `get`: for state management and navigation.
  * `sqflite`: for SQLite database actions.
  * `path`: to find safe directories on Android/iOS to save the database file.

### 2. `lib/main.dart`
The root file of the application.
* `WidgetsFlutterBinding.ensureInitialized()`: Crucial line because SQLite needs to access platform-specific code (native storage) before the UI starts loading.
* `await DatabaseHelper.instance.database`: Initializes our SQLite database right at startup.
* `GetMaterialApp`: The GetX version of `MaterialApp`. We set the application title, default theme configuration, disable the debug banner, and point the `home:` parameter to `SplashView()`.

### 3. `lib/models/todo_model.dart`
This defines what a task object is.
* Properties: `id` (primary key generated by database), `title`, `description`, `dateTime`, `isCompleted` (boolean), `priority` ('Low', 'Medium', 'High'), `category` ('Work', 'Personal', etc.).
* `toMap()`: SQLite doesn't support booleans directly, so we map `true` to `1` and `false` to `0`. It converts the Dart object into a JSON-like format.
* `fromMap()`: A factory constructor that takes a database row map and converts it into a `TodoModel` instance.
* `copyWith()`: A helper method that copies an existing object while replacing selected fields. Useful for modifying a single field (like changing `isCompleted` from false to true) without retyping all parameters.

### 4. `lib/services/db_helper.dart`
The local database engine.
* `onCreate`: Creates two tables when the database is created for the first time:
  1. `tasks`: holds all task items.
  2. `settings`: a key-value store. We use this to save `has_seen_onboarding` as `'true'` so the user is never shown the onboarding slides twice.
* CRUD Methods:
  * `insertTask()`: Inserts a new row into the table.
  * `readAllTasks()`: Queries all tasks from SQLite.
  * `updateTask()`: Updates values of a task matching its ID.
  * `deleteTask()`: Deletes a task by ID.

### 5. `lib/utils/theme.dart`
Defines the visual appearance of the application.
* Contains theme parameters like `primaryColor`, `scaffoldBackgroundColor`, and input fields styling.
* Configures separate Dark Theme and Light Theme definitions. We set Dark Theme as default because it looks highly modern and premium.
* Exposes helper methods `getCategoryColor(category)` and `getCategoryIcon(category)` to match each task category with its dedicated colors and icons across all views.

### 6. `lib/controllers/splash_controller.dart`
* Extends `GetxController`.
* Uses `onInit()` (which fires automatically when splash is created) to wait for 3 seconds using `Future.delayed()`.
* Calls the SQLite Database to check if the setting key `'has_seen_onboarding'` is `'true'`.
* Navigates to `HomeView` or `OnboardingView` accordingly using `Get.off()`.

### 7. `lib/controllers/onboarding_controller.dart`
* Controls the PageView on the onboarding screen.
* Maintains a reactive integer variable `currentPage = 0.obs;` using GetX.
* `completeOnboarding()` saves the seen flag to the database and redirects the user to the `HomeView`.

### 8. `lib/controllers/todo_controller.dart`
The main logic controller of the application.
* `tasks = <TodoModel>[].obs`: A reactive list of all tasks. Any widget reading this inside an `Obx` will automatically redraw itself whenever items are added or removed.
* `selectedCategory`, `searchQuery`, `sortBy`: Observable variables representing user choices in filters, sorting and searching.
* `filteredTasks`: A computed getter that returns the list of tasks after applying category filtering, keyword searching, and sorting (by date, priority, or status) in real time.
* `completionRatio`: Computed on-the-fly to draw the progress percentage indicator in the UI.

### 9. `lib/views/splash/splash_view.dart`
* Draws a beautiful screen with a multi-color gradient background.
* Displays our logo (a custom checkmark inside circular shadows), the app title, and a loading indicator at the bottom.
* It initializes the `SplashController` using `Get.put(SplashController())` to kickstart the navigation logic.

### 10. `lib/views/onboarding/onboarding_view.dart`
* Renders a layout showing a "Skip" button, a `PageView` slider, dot indicators, and a dynamic button that says "Next" or "Get Started".
* Instead of using external image files (which can fail to download or slow down the build), it renders gorgeous, smooth, programmatic illustrations using gradient containers and Material icons.

### 11. `lib/views/home/home_view.dart` & `widgets/`
The dashboard screen. It is modularized into reusable custom components:
* **`widgets/progress_card.dart`**: A colorful card displaying task statistics and a circular progress indicator.
* **`widgets/category_filter_list.dart`**: Horizontal scrolling tabs allowing the user to filter tasks by category.
* **`widgets/task_card.dart`**: A custom list widget styled with priority vertical indicator strips, toggle checkboxes, category tags, and wrapped in a `Dismissible` widget to delete tasks on swipe.
* **Search Bar**: A text field inside the main home view that updates the controller query variable dynamically.

### 12. `lib/views/todo/todo_detail_view.dart`
The form screen.
* Checks if `task` was passed in the constructor. If it was, pre-fills the text inputs and shows a delete button in the App Bar (Edit Mode). If not, shows an empty form (Create Mode).
* Lets the user pick low/medium/high priority using customizable tap cards.
* Contains custom date/time pickers which prompt the native date and time dial overlays of Android or iOS.
* Validates that the title input is not empty before triggering database writes.

### 13. `lib/views/main_navigation_view.dart` & `main_navigation_controller.dart`
The Bottom Navigation Bar wrapper layout.
* Tracks the active tab index reactively using `MainNavigationController` and custom `currentIndex.obs`.
* Displays the selected page using `IndexedStack` to keep pages loaded in memory for fast layout transitions.
* Houses 3 main sections: Dashboard, Search, and About/Developer info.

### 14. `lib/views/search/search_view.dart`
The dedicated search screen.
* Integrates text filtering search fields.
* Implements advanced visual checkboxes and filters to query tasks by Priority levels (Low/Medium/High) and Completion Statuses (Completed/Pending).

### 15. `lib/views/about/about_view.dart`
The application overview layout.
* Displays developer details and assignments.
* Integrates visual explanation boxes showing the MVC, GetX, and Sqflite architectures to help show your teacher what stack has been built.

---

## 7. Step-by-Step Tutorial to Recreate This App

If you want to build this exact project from scratch, follow these instructions:

### Step 1: Initialize Flutter Project
Run this command in your terminal:
```bash
flutter create basictodoapp
```

### Step 2: Add Dependencies
Open `pubspec.yaml` and add `get`, `sqflite`, and `path` under `dependencies:`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.6.6
  sqflite: ^2.3.0
  path: ^1.8.3
```
Run `flutter pub get` in your terminal to download these libraries.

### Step 3: Set up Folder Architecture
Create the folders inside `lib/` directory:
* `controllers`
* `models`
* `services`
* `utils`
* `views` (with subfolders: `splash`, `onboarding`, `home`, `todo`)

### Step 4: Write Code Files
Create the files in the respective directories as detailed in section 5, copy the codes from this project, and import them appropriately.

### Step 5: Test the Application
Connect a device or emulator and run:
```bash
flutter run
```

---

## 8. Common Teacher Viva/Presentation Questions

Here are some questions your teacher might ask when you demonstrate this project, along with the correct answers:

#### Q1: What architecture did you use in this application, and why?
**Answer:** I used the **MVC (Model-View-Controller)** architecture. It separates the data logic (Model) and the user interface (View) by placing all calculation and database handling in a central brain (Controller). This makes the codebase clean, readable, and easy to maintain.

#### Q2: What is the purpose of GetX in your project?
**Answer:** GetX is used for **State Management** and **Navigation/Routing**. 
* **State:** It uses reactive programming (observable variables with `.obs` and the `Obx` widget) to automatically update the screen whenever data changes, without calling `setState()`.
* **Routing:** It allows navigation using `Get.to()` and `Get.off()` without needing `BuildContext`.

#### Q3: What is the difference between `Get.to()` and `Get.off()`?
**Answer:** 
* `Get.to()` opens a new screen and keeps the previous screen alive in the navigation stack (the user can press back to return).
* `Get.off()` opens a new screen and closes/destroys the current screen (meaning it is popped off the stack, so the user cannot navigate back). We use `Get.off()` when transitioning away from the Splash and Onboarding screens.

#### Q4: Where are the tasks stored, and how does it persist after restarting the app?
**Answer:** Tasks are stored in a local **SQLite database** on the device using the `sqflite` package. The `DatabaseHelper` class manages the initialization, table creation, and runs SQL operations (Insert, Query, Update, Delete) to load the tasks from the persistent storage whenever the app boots.

#### Q5: How do you prevent showing the Onboarding screen every time the app opens?
**Answer:** When the user completes or skips the onboarding screen, we write a key-value record in our SQLite `settings` table: `has_seen_onboarding = 'true'`. When the app launches, the `SplashController` reads this value from the database. If it is `'true'`, it routes straight to the `MainNavigationView`, skipping the onboarding entirely.

#### Q6: Why did you use `WidgetsFlutterBinding.ensureInitialized()` in `main()`?
**Answer:** In Flutter, the framework needs to interact with native platform features (like reading local database files via SQLite). By calling `ensureInitialized()`, we ensure that this communication channel is fully ready before the Flutter UI starts rendering.
