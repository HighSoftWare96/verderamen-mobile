class AuthenticateUpdateAction {
  String? endpoint;
  String? username;
  String? password;

  AuthenticateUpdateAction({this.endpoint, this.username, this.password});
}

class AuthenticateAction {
  bool polling = false;
  void Function(Object e)? onError;
  void Function(Map telemetries)? onSuccess;

  AuthenticateAction({
    this.polling = false,
    this.onError,
    this.onSuccess
  });
}

class AuthenticateActionSuccess {
  Map telemetries;
  AuthenticateActionSuccess(this.telemetries);
}

class _ErrorAction {
  String? message;

  _ErrorAction(this.message);
}

class AuthenticateActionError extends _ErrorAction {
  AuthenticateActionError(super.message);
}

class StartPollingAction {}

class StopPollingAction {}

class LogoutAction {}

class LogoutCompleteAction {}