import 'package:verderamen_mobile/store/actions.dart';

class AppState {
  final bool _isLoadingAuth;
  final bool _isAuthenticated;
  final String _endpoint;
  final String _username;
  final String _password;
  final Map? _telemetries;

  bool get isLoadingAuth => _isLoadingAuth;
  bool get isAuthenticated => _isAuthenticated;
  String get endpoint => _endpoint;
  String get username => _username;
  String get password => _password;
  Map? get telemetries => _telemetries;

  AppState(
      {required isAuthenticated,
      required endpoint,
      required username,
      required password,
      telemetries,
      isLoadingAuth = false})
      : _isAuthenticated = isAuthenticated,
        _endpoint = endpoint,
        _username = username,
        _password = password,
        _telemetries = telemetries,
        _isLoadingAuth = isLoadingAuth;

  AppState.initialState()
      : _isAuthenticated = false,
        _endpoint = 'https://civil-sawfly-lately.ngrok-free.app',
        _username = '\$\$admin',
        _password = '',
        _telemetries = null,
        _isLoadingAuth = false;

  AppState.copyWith(AppState state,
      {isAuthenticated, endpoint, username, password, isLoadingAuth, telemetries})
      : _isAuthenticated = isAuthenticated ?? state._isAuthenticated,
        _endpoint = endpoint ?? state.endpoint,
        _username = username ?? state.username,
        _password = password ?? state.password,
        _telemetries = telemetries ?? state.telemetries,
        _isLoadingAuth = isLoadingAuth ?? state._isLoadingAuth;
}

AppState reducer(AppState state, dynamic action) {
  if (action is AuthenticateUpdateAction) {
    return AppState.copyWith(state,
        isAuthenticated: false,
        endpoint: action.endpoint ?? state.endpoint,
        username: action.username ?? state.username,
        password: action.password ?? state.password);
  } else if (action is AuthenticateAction) {
    return AppState.copyWith(state, isLoadingAuth: true);
  } else if (action is AuthenticateActionSuccess) {
    return AppState.copyWith(state,
        isAuthenticated: true, isLoadingAuth: false, telemetries: action.telemetries);
  } else if (action is AuthenticateActionError) {
    return AppState.copyWith(state,
        isAuthenticated: false, isLoadingAuth: false);
  }

  return state;
}
