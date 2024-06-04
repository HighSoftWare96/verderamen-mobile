import 'package:verderamen_mobile/store/actions.dart';

class AppState {
  final bool _isAuthenticated;
  final String _endpoint;
  final String _username;
  final String _password;

  bool get isAuthenticated => _isAuthenticated;
  String get endpoint => _endpoint;
  String get username => _username;
  String get password => _password;

  AppState(
      {required isAuthenticated,
      required endpoint,
      required username,
      required password})
      : _isAuthenticated = isAuthenticated,
        _endpoint = endpoint,
        _username = username,
        _password = password;

  AppState.initialState()
      : _isAuthenticated = false,
        _endpoint = 'https://civil-sawfly-lately.ngrok-free.app:5000',
        _username = '\$\$admin',
        _password = '';
}

AppState reducer(AppState state, dynamic action) {
  if (action is AuthenticateUpdateAction) {
    return AppState(
        isAuthenticated: false,
        endpoint: action.endpoint ?? state.endpoint,
        username: action.username ?? state.username,
        password: action.password ?? state.password);
  } else if (action is AuthenticateActionSuccess) {
    return AppState(
        isAuthenticated: true,
        endpoint: state.endpoint,
        username: state.username,
        password: state.password);
  } else if (action is AuthenticateActionError) {
    return AppState.initialState();
  }

  return state;
}
