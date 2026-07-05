# BookApp
# 📚 Bazar - Books Mobile App

A modern mobile e-commerce application for buying, discovering, and managing books. This project is built based on the **Bazar - Books Mobile App (Community)** Figma design and aims to provide a clean, intuitive, and engaging shopping experience for book lovers.

## 🎨 Design Reference

**Figma Design**
https://www.figma.com/design/Pxpnq99X09fjpDnqmhbQJ9/Bazar---Books-Mobile-App--Community-

The application should follow the provided Figma design as closely as possible while maintaining clean, reusable, and scalable code.

---

# Project Overview

The application allows users to:

- Browse books by category
- Search for books
- View detailed book information
- Add books to cart
- Purchase books
- Manage favorites
- Track orders
- Manage their profile

The goal is to build a production-ready mobile application using modern development practices and a scalable architecture.

---

# Tech Stack

> Update this section if the technology changes.

- Mobile Framework: Flutter
- Language: Dart
- State Management: Provider / Riverpod / Bloc (TBD)
- Backend: TBD (Dart)
- Database: TBD (firebase)
- Authentication: TBD (Google cloud console)
- API: REST API
- Version Control: Git & GitHub
- Design: Figma

---

# Repository Structure (TBD)

```
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── authentication/
│   ├── home/
│   ├── books/
│   ├── cart/
│   ├── wishlist/
│   ├── checkout/
│   ├── orders/
│   └── profile/
│
├── models/
│
├── routes/
│
├── main.dart
│
assets/
│
├── images/
├── icons/
├── fonts/
└── animations/
```

---

# Getting Started

## 1. Clone the repository

```bash
git clone <repository-url>
```

## 2. Open the project

```bash
cd project-name
```

## 3. Install dependencies

```bash
flutter pub get
```

## 4. Run the application

```bash
flutter run
```

For a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

---

# Git Branching Strategy

The project follows a simplified Git Flow.

## Main Branches

### main

- Production-ready code only
- Always stable
- Protected branch

### develop

- Integration branch
- All completed features are merged here before reaching `main`

---

## Feature Branches

Every new feature should be created from `develop`.

Naming convention:

```
feature/<feature-name>
```

Examples:

```
feature/splash-screen
feature/onboarding
feature/login
feature/home-page
feature/book-details
feature/cart
feature/profile
```

---

## Bug Fixes

```
bugfix/<bug-name>
```

Example:

```
bugfix/cart-total
bugfix/login-validation
```

---

## Hotfixes

Used only for urgent production fixes.

```
hotfix/<issue-name>
```

Example:

```
hotfix/payment-crash
```

---

# Development Workflow

1. Pull the latest `develop` branch.
2. Create a new feature branch.
3. Implement the feature.
4. Commit changes using meaningful commit messages.
5. Push the feature branch.
6. Open a Pull Request to `develop`.
7. Request a review.
8. Merge after approval.

---

# Commit Message Convention

Use short and meaningful commit messages.

Examples:

```
feat: add splash screen

feat: implement onboarding carousel

fix: resolve navigation issue

refactor: improve reusable button component

style: update typography

docs: update README
```

---

# Project Architecture

The project follows a feature-first architecture.

Each feature contains its own:

- UI
- Models
- Services
- Widgets
- Business Logic

Shared functionality should be placed inside the `core` folder.

Reusable components include:

- Buttons
- Text Fields
- App Bars
- Cards
- Book Tiles
- Loading Indicators
- Dialogs

This structure improves scalability, maintainability, and code reuse.

---

# Current Sprint

## Repository Setup

- [ ] Create GitHub repository
- [ ] Configure README
- [ ] Configure project architecture
- [ ] Create `main` branch
- [ ] Create `develop` branch
- [ ] Add `.gitignore`
- [ ] Configure assets folder
- [ ] Create reusable components folder

---

## UI Implementation

- [ ] Splash Screen
- [ ] Onboarding Carousel
- [ ] Reusable Components
- [ ] Theme Configuration
- [ ] Navigation Setup

---

# Pull Request Checklist

Before submitting a Pull Request, ensure the following:

- [ ] Code builds successfully
- [ ] No analyzer errors
- [ ] No unnecessary debug prints
- [ ] Follows project architecture
- [ ] Uses reusable widgets where applicable
- [ ] Matches the Figma design
- [ ] Tested on emulator/device
- [ ] Screenshots attached
- [ ] README updated (if needed)

---

# Pull Request Template

## Description

Briefly describe the implemented feature or fix.

---

## Type of Change

- [ ] Feature
- [ ] Bug Fix
- [ ] Refactor
- [ ] Documentation
- [ ] Performance Improvement

---

## Changes Made

-
-
-

---

## Screenshots

| Before | After |
|---------|-------|
| Add Screenshot | Add Screenshot |

---

## Testing

- [ ] Tested on Android
- [ ] Tested on iOS (if applicable)
- [ ] No runtime issues

---

# Coding Guidelines

- Follow Dart formatting conventions.
- Keep widgets small and reusable.
- Avoid duplicated code.
- Prefer composition over inheritance.
- Separate UI from business logic.
- Write meaningful variable and method names.
- Organize imports automatically before committing.

---

# Future Features

- User Authentication
- Google Sign-In
- Book Reviews
- Ratings
- Wishlist
- Order Tracking
- Push Notifications
- Dark Mode
- Offline Reading Preview
- Book Recommendations
- Recently Viewed Books
- Payment Gateway Integration

