# ByteSymphony Client Manager

A professional Flutter application for managing clients and invoices with JWT authentication.

## 📱 Features

- **Secure Authentication**: JWT-based login with token persistence
- **Client Management**: Create, read, update, and delete clients
- **Advanced Search**: Search clients with pagination and sorting
- **Invoice Tracking**: View and filter invoices by client and status
- **Offline Support**: Secure token storage and automatic retry
- **Professional UI**: Corporate design with smooth animations
- **Error Handling**: Comprehensive error states with user-friendly messages

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with clean separation:

```
├── Data Layer (Models, Repositories, Services)
├── Presentation Layer (ViewModels, Screens, Widgets)
└── Core (Constants, Network, Theme, Utils)
```

### State Management
- **Riverpod 2.x**: Modern, compile-safe state management

### Key Libraries
- **Dio**: HTTP client with interceptors for token management
- **flutter_secure_storage**: Secure JWT token storage
- **go_router**: Declarative routing with navigation guards
- **Google Fonts**: Professional typography

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd bytesymphony_client_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (if needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Build APK (Release)**
   ```bash
   flutter build apk --release
   ```

## 🔐 Configuration

### Base URL Configuration

The base URL is configured in `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'https://www.bytesymphony.dev/TestAPI';
}
```

To change the base URL, modify this constant and rebuild the app.

### Demo Credentials
- **Email**: admin@demo.dev
- **Password**: Admin@123

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # API endpoints, app constants
│   ├── network/            # Dio client, interceptors
│   ├── theme/              # App theme, colors, text styles
│   └── utils/              # Validators, extensions, utilities
├── data/                   # Data layer
│   ├── models/             # Data models (JSON serializable)
│   ├── repositories/       # Repository pattern implementation
│   └── services/           # API service, storage service
├── presentation/           # Presentation layer
│   ├── providers/          # Riverpod providers
│   ├── viewmodels/         # Business logic
│   ├── screens/            # UI screens
│   └── widgets/            # Reusable widgets
└── routes/                 # Navigation configuration
```

## 🎨 Design Decisions

### MVVM Pattern
- **Model**: Pure data classes with JSON serialization
- **View**: Stateless/Stateful widgets that observe ViewModels
- **ViewModel**: Business logic and state management
- **Repository**: Abstraction layer for data sources

### Error Handling
- Centralized error handling in Dio interceptor
- User-friendly error messages
- Automatic token refresh on 401 errors
- Network connectivity checks

### State Management Strategy
- **Riverpod Providers**: For dependency injection
- **StateNotifier**: For complex state management in ViewModels
- **FutureProvider**: For async data fetching
- **StreamProvider**: For real-time updates (if needed)

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `GET /api/me` - Get user details

### Clients
- `GET /api/clients` - List clients (with search, pagination, sorting)
- `GET /api/clients/{id}` - Get client details
- `POST /api/clients` - Create new client
- `PUT /api/clients/{id}` - Update client
- `DELETE /api/clients/{id}` - Delete client

### Invoices
- `GET /api/invoices` - List invoices (with filters)
- `POST /api/invoices` - Create invoice
- `PUT /api/invoices/{id}` - Update invoice

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 🛠️ Build APK

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## 📝 Development Notes

### Code Generation
This project uses code generation for:
- JSON serialization (`json_serializable`)
- Riverpod providers (`riverpod_generator`)
- API client (`retrofit_generator`)

Run generation:
```bash
flutter pub run build_runner watch
```

### Git Workflow
- Feature branches for new features
- Descriptive commit messages
- Regular commits showing development progress

## 🐛 Known Issues & Future Enhancements

### Future Enhancements
- [ ] Dark mode support
- [ ] Invoice PDF generation
- [ ] Advanced filtering options
- [ ] Export data functionality
- [ ] Offline mode with local database
- [ ] Biometric authentication

## 📄 License

This project is developed for ByteSymphony Business Solutions LLP machine test.

## 👤 Developer

Developed by [Your Name]
- Flutter Developer with 3+ years of experience
- Expertise in MVVM architecture, Riverpod, and clean code principles

## 🙏 Acknowledgments

- ByteSymphony Business Solutions LLP for the opportunity
- Flutter and Dart communities for excellent documentation

---

**Note**: This is a technical assessment project demonstrating Flutter development skills, MVVM architecture, and professional coding practices.