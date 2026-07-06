# 📚 Bazar – Books Mobile App

A modern mobile e-commerce application for buying, discovering, and managing books. This project is built using Flutter based on the **Bazar – Books Mobile App (Community)** Figma design and aims to provide a clean, intuitive, and engaging shopping experience for book lovers.

---

## 🚀 Getting Started & Setup Instructions

Follow these instructions to clone, configure, and run the project locally on your machine.

### Prerequisites
*   Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (Stable channel).
*   Ensure Xcode (for iOS) or Android Studio (for Android) is set up with simulators/emulators ready.

### Installation & Initialization
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/SebaWahba/BookApp.git](https://github.com/SebaWahba/BookApp.git)
    cd BookApp
    ```
2.  **Fetch Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Generate Dependency Injection & Configurations:**
    If code generation tools or dependency injection bindings require configuration setup, run:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### Running the Project
*   To launch the application on your connected emulator or device:
    ```bash
    flutter run
    ```
*   To run the project in release mode:
    ```bash
    flutter run --release
    ```

---

## 🗺️ Branching Strategy & Naming Conventions

To maintain code quality and structural stability, the repository follows a strict team branching protocol:

### Main Branches
*   **`main`**: Production-ready branch. Contains fully tested, stable code.
*   **`develop`**: Integration branch. All features must be integrated here via Pull Requests before moving to production.

### Feature Branches & Naming Protocol
All granular tasks must branch out of `develop` and utilize clean prefix paths according to the required milestone sequence:
*   `develop` ──> **`feature/init-architecture`** (Naming & core project directory trees)
*   `develop` ──> **`feature/splash`** (Splash screen implementation)
*   `develop` ──> **`feature/reusable`** (Generic core widgets & design systems)

> ⚠️ **Branch Protection Rules:** Direct commits to `main` and `develop` are strictly prohibited. All code integration must occur through GitHub Pull Requests (PRs) requiring a minimum of 1 peer approval review.

---

## 🔀 Pull Request (PR) Template Specification

Every pull request submitted to the repository must strictly supply the following markdown layout inside its description fields to handle code checklist audits:

### 1. Description
*   Provide a clear summary of the structural, architectural, or functional changes introduced by this Pull Request.
*   Clarify what specific tasks or user stories from the current milestone are addressed here.

### 2. Checklist
- [ ] My code follows the clean coding standards of this project.
- [ ] I have verified that my changes branch out from the correct environment.
- [ ] I have documented any new folder architecture or setup configurations.
- [ ] My changes generate no new warnings or console compilation errors.
- [ ] I have tested this code locally on an emulator or active device.

### 3. Screenshots Section
*   **Mandatory Requirement:** Visual proof or architecture snapshots must be attached demonstrating that your setup functions as expected under runtime constraints.
*   *Format Example:*
    | Feature Layout / Folder Proof | Context Description |
    | --- | --- |
    | *[Drag-and-drop image asset here]* | Description of the corresponding viewport/state |

---

## 🏗️ Clean Architecture Folder Structure

The code layout strictly adheres to Clean Architecture standards, isolating configuration, core business rules, and features into distinct presentation, domain, and data layers.

```text
lib/
├── config/                  # Global Application Configurations
│   ├── locale/             # Localization and translation setup (.gitkeep)
│   ├── routes/             # App routing engine and route path declarations (.gitkeep)
│   └── themes/             # Dynamic dark/light app theme palettes (.gitkeep)
│
├── core/                    # Reusable Shared Architecture Components
│   ├── api/                # Base HTTP clients, interceptors, and endpoints (.gitkeep)
│   ├── error/              # Failure models, exceptions, and error-handling helpers (.gitkeep)
│   ├── network/            # Network connectivity info checks (.gitkeep)
│   ├── usecases/           # Contract blueprints for business rules (.gitkeep)
│   ├── utils/              # Extension methods, constants, and helper logic (.gitkeep)
│   └── widgets/            # Reusable structural or UI design-system components (.gitkeep)
│
├── features/                # Domain-Driven Functional Modules (.gitkeep)
│
├── app.dart                 # Application MaterialApp initialization wrapper
├── bloc_observer.dart       # State management logging observer 
├── injection_container.dart # Dependency Injection locator service configuration
└── main.dart                # Production app starting runtime execution point
