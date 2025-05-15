
# Flutter Web CRUD App with Back4App (Parse Server)

## 🔧 Setup

1. Create a free Back4App account: https://www.back4app.com
2. Create a new app and note:
   - **Application ID**
   - **Client Key**
   - **Server URL**: usually `https://parseapi.back4app.com`
3. Replace the placeholders in `main.dart`:
   ```dart
   const keyAppId = 'YOUR_APP_ID_HERE';
   const keyClientKey = 'YOUR_CLIENT_KEY_HERE';
   const keyParseServerUrl = 'https://parseapi.back4app.com';
   ```

## ▶️ Run

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

This version uses `parse_server_sdk` (web-compatible) instead of `parse_server_sdk_flutter`.

## Features

- ✅ Login / Signup
- ✅ Add / Delete items
- ✅ All data stored in Back4App (Parse Server)
