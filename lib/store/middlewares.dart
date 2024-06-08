import 'dart:async';

import 'package:verderamen_mobile/api/verderamen.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/utils/logger.dart';
import 'package:verderamen_mobile/utils/storage.dart';

Timer? pollingTimer;

void middleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is AuthenticateAction) {
    getTelemetries(
            endpoint: store.state.endpoint,
            username: store.state.username,
            password: store.state.password)
        .then((telemetries) {
      logger.i(telemetries);
      if (action.onSuccess != null) {
        action.onSuccess!(telemetries);
      }
      if (!action.polling) {
        saveCredentialsForNextUse(
            endpoint: store.state.endpoint,
            username: store.state.username,
            password: store.state.password);
      }
      store.dispatch(AuthenticateActionSuccess(telemetries));
    }).catchError((Object e) {
      logger.e(e);
      if (action.onError != null) {
        action.onError!(e);
      }
      store.dispatch(AuthenticateActionError(e.toString()));
    });
  } else if (action is StartPollingAction) {
    poll(store);
  } else if (action is StopPollingAction && pollingTimer != null) {
    pollingTimer?.cancel();
  } else if (action is LogoutAction) {
    pollingTimer?.cancel();
    clearCredentials().then((_) {
      if (action.onSuccess != null) {
        action.onSuccess!();
      }
      store.dispatch(LogoutCompleteAction());
    });
  }

  next(action);
}

Future saveCredentialsForNextUse(
    {required String endpoint,
    required String username,
    required String password}) async {
  await setSecureKey('endpoint', endpoint);
  await setSecureKey('username', username);
  await setSecureKey('password', password);
}

Future clearCredentials() async {
  await unsetSecureKey('endpoint');
  await unsetSecureKey('username');
  await unsetSecureKey('password');
  await cleanup();
}

void poll(Store<AppState> store) {
  pollingTimer = Timer(const Duration(seconds: 6), () {
    store.dispatch(AuthenticateAction(polling: true));
    pollingTimer = null;
    poll(store);
  });
}
