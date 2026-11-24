# Nigas

Nigas is an offline-first task tracker built with Flutter for vocational high school (SMK) students in Indonesia. It organizes coursework across vocational majors (RPL, TKJ, DKV) and general subjects, stores all data locally in SQLite, and fires scheduled deadline reminders without requiring user accounts or network access.

## Prerequisites

Before running the application, ensure the following toolchains are installed:

- Flutter SDK version 3.24.0 or higher
- Dart SDK version 3.5.0 or higher
- Android SDK with target API 34 and minimum API 21 (for Android builds)
- Java Development Kit (JDK 11 or 17)
- Google Chrome (if targeting Flutter Web with WASM SQLite support)

Verify your environment with:

```bash
flutter doctor
```

## Setup and Installation

1. Clone the repository and navigate into the project directory:

```bash
git clone https://github.com/username/nigas.git
cd "Project awal apliaksi Nigas"
```

2. Fetch Flutter packages:

```bash
flutter pub get
```

3. Generate Drift database bindings:

The repository includes pre-generated Drift files (`lib/core/db/app_database.g.dart`). If you modify database tables or queries in `lib/core/db/app_database.dart`, regenerate code using `build_runner`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Launch the application:

For an Android device or emulator:

```bash
flutter run -d android
```

For web development (serves `sqlite3.wasm` and `drift_worker.js` locally):

```bash
flutter run -d chrome
```

## Architecture and Stack

Nigas follows a feature-driven folder structure with clear separation between core infrastructure and domain features.

```text
lib/
├── core/
│   ├── constants/       # AppColors, AppStrings, styling constants
│   ├── db/              # Drift database definition, migrations, and providers
│   ├── navigation/      # GoRouter route declarations
│   ├── theme/           # NeoBrutalTokens, AppTheme (light and dark mode)
│   └── widgets/         # Shared UI primitives (buttons, text fields, chips)
├── features/
│   ├── tasks/           # Task models, repositories, task form, and home dashboard
│   ├── subjects/        # SMK category definitions and custom subject dialogs
│   ├── settings/        # AppSettings repository, theme toggle, and notification preferences
│   ├── reminders/       # NotificationService and reminder calculation logic
│   └── onboarding/      # Initial major selection screen
└── main.dart            # Application entrypoint and initialization
```

Key dependencies:
- State Management: `flutter_riverpod` (v2.6.1)
- Persistence: `drift` (v2.24.2) with `drift_flutter` and `sqlite3_flutter_libs`
- Routing: `go_router` (v14.8.1)
- Notifications: `flutter_local_notifications` (v18.0.1) and `flutter_timezone` (v3.0.1)
- Typography: Local assets for Space Grotesk and Space Mono fonts

## Core Workflows and Usage

### Task and Subtask Tracking
Tasks require a title, a linked subject, and a due date. Users can optionally attach notes and multiple checklist subtasks. As subtasks are completed, an inline progress indicator updates dynamically. When all subtasks are finished, the app prompts the user to mark the parent task as complete.

### Major and Subject Templates
Preset subjects populate automatically on first launch based on the Indonesian SMK curriculum:
- RPL (Software Engineering): PAD, PWEB, PPB, UI/UX, APS
- TKJ (Computer Network Engineering): ASJ, KEJAR, KPJ, DMIKRO, TJKN, PPJ
- DKV (Visual Communication Design): Fotografi, Videografi, KPD, DP, Desain Cetak, AMG
- General: PAI, PKK, PPKn, Bahasa Indonesia, Bahasa Inggris, Sejarah, Matematika, PJOK, Bahasa Jepang, BTQ, BP/BK

Users can add custom subjects, assign color indices from the palette, edit existing labels, or delete unused subjects. If a subject still has associated tasks, the deletion dialog requires reassigning those tasks to another subject to maintain referential integrity.

### Status and Query Filtering
The home dashboard supports status filtering (`todo`, `in_progress`, `done`) alongside live search across task titles, subject names, and notes. Tasks are grouped by deadline into five operational buckets:
- Overdue (past deadline)
- Today (due before 23:59:59 today)
- Tomorrow (due strictly tomorrow)
- This Week (due within the remaining days of the current week)
- Later (future deadlines)

## Configuration and Persistence

Nigas does not use an external `.env` file or remote backend. All configuration values and application states are stored locally in the SQLite database file (`nigas_db`).

### Schema Overview

The database uses Drift with foreign keys enforced (`PRAGMA foreign_keys = ON`):

- `subjects`: Stores subject names, category codes (`rpl`, `tkj`, `dkv`, `general`), color indices, and preset flags.
- `tasks`: Stores task titles, optional notes, `subjectId` (foreign key to `subjects.id` with `RESTRICT`), due timestamp, status string (`todo`, `in_progress`, `done`), and completion timestamp.
- `subtasks`: Stores step-by-step checklist items linked to `tasks.id` with `CASCADE` on delete.
- `app_settings_table`: Key-value store for application settings.

### Configurable Preferences

Stored key-value keys in `app_settings_table`:
- `theme_mode`: `light`, `dark`, or `system`
- `notifications_enabled`: `true` or `false`
- `reminder_d1_hour` and `reminder_d1_minute`: Custom time for D-1 notification (default: 18:00 WIB)
- `reminder_d0_hour` and `reminder_d0_minute`: Custom time for D-0 notification (default: 07:00 WIB)
- `has_completed_onboarding`: Tracks initial welcome flow completion

Data maintenance operations (cleaning completed tasks and restoring factory presets) can be triggered directly from the Settings screen.

## Testing and Verification

Run the test suite covering domain calculators, database repositories, form validation, and widget interactions:

```bash
flutter test
```

Perform static analysis to verify lint rules and code health:

```bash
flutter analyze
```

## Production Build

To build an optimized release APK for Android:

```bash
flutter build apk --release
```

The compiled binary will be placed at:

```text
build/app/outputs/flutter-apk/app-release.apk
```
