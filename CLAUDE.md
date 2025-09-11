# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RentHouse is a Flutter-based property management application designed for real estate managers to handle properties, tenants, leases, and billing. The app supports both mobile and desktop platforms with an adaptive UI design.

## Development Commands

### Essential Flutter Commands
```bash
cd renthouse

# Install dependencies
flutter pub get

# Generate code (required after model changes)
flutter packages pub run build_runner build

# Watch mode for continuous code generation
flutter packages pub run build_runner watch

# Run the app (Windows/Desktop)
flutter run -d windows

# Analyze code for linting issues
flutter analyze

# Run tests
flutter test

# Build for production
flutter build windows
flutter build apk
flutter build web
```

### Code Generation
This project uses extensive code generation. Always run build_runner after:
- Adding/modifying Freezed data models
- Adding/modifying Riverpod providers with annotations
- Adding/modifying JSON serialization models
- Adding/modifying Drift database tables

## Architecture

### Clean Architecture Structure
```
lib/
├── app/                    # App configuration, theme, routing
├── core/                   # Shared utilities and infrastructure
│   ├── auth/              # Authentication logic
│   ├── database/          # Drift database setup
│   ├── network/           # HTTP client configuration
│   └── rbac/              # Role-based access control
└── features/              # Feature-based modules
    ├── auth/              # Login and authentication UI
    ├── billing/           # Billing and bill templates
    ├── dashboard/         # Main dashboard
    ├── lease/             # Lease management
    ├── property/          # Property and unit management
    └── tenant/            # Tenant management
```

### Key Technologies
- **State Management**: Riverpod with code generation
- **Data Models**: Freezed for immutable data classes
- **Database**: Drift (SQLite) for local persistence
- **Routing**: go_router for navigation
- **JSON**: json_serializable for API models
- **HTTP**: Dio for network requests
- **UI**: Material 3 design system

### Data Flow
1. **Presentation Layer**: Screens and widgets using Riverpod providers
2. **Application Layer**: Controllers managing business logic
3. **Data Layer**: Repositories handling data persistence
4. **Domain Layer**: Entities and business models

### Generated Files
Never edit `.g.dart`, `.freezed.dart` files directly - they are auto-generated.

## Development Patterns

### Adding New Features
1. Create domain models with Freezed annotations
2. Add database tables in `app_database.dart`
3. Create repository for data access
4. Build controller with Riverpod annotations
5. Implement presentation screens
6. Add routes to `router.dart`
7. Run `build_runner build`

### Database Changes
- Modify tables in `core/database/app_database.dart`
- Drift handles migrations automatically
- Run build_runner to generate DAO methods

### State Management
- Use `@riverpod` annotation for providers
- Controllers should extend `_$ControllerName`
- Keep state immutable with Freezed models

## Current Status

### Completed Features (Phase 1)
- Authentication with basic login
- Property and Unit CRUD operations
- Tenant management
- Lease management with status tracking
- Billing system with templates
- Dashboard with key metrics
- Adaptive UI for desktop/mobile
- Local SQLite database integration

### Next Priorities
1. Backend API integration
2. Role-based access control implementation
3. Payment processing
4. Work order management
5. File upload functionality
6. Advanced reporting features

## Important Notes

- Always work within the `renthouse/` directory
- Code generation is mandatory after model changes
- Follow the existing feature-based architecture
- Use Material 3 design patterns for UI consistency
- Implement responsive design for multi-platform support