class AuthenticateUpdateAction {
  String? endpoint;
  String? username;
  String? password;

  AuthenticateUpdateAction({this.endpoint, this.username, this.password});
}

class AuthenticateAction {
}

class AuthenticateActionSuccess {
  AuthenticateActionSuccess();
}

class _ErrorAction {
  String? message;

  _ErrorAction(this.message);
}

class AuthenticateActionError extends _ErrorAction {
  AuthenticateActionError(super.message);
}

