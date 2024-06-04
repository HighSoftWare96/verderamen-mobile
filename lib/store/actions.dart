class AuthenticateUpdateAction {
  String? endpoint;
  String? username;
  String? password;

  AuthenticateUpdateAction({this.endpoint, this.username, this.password});
}

class AuthenticateAction {
  void Function(Object e)? onError;
  void Function(Map telemetries)? onSuccess;

  AuthenticateAction({
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

