/// Base URL of the backend API.
///
/// Override at build time: flutter run --dart-define=API_BASE_URL=https://...
/// The default works for the iOS simulator talking to uvicorn on this Mac.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000/api/v1',
);