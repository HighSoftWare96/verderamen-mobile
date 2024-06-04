import 'package:logger/logger.dart';
import 'package:verderamen_mobile/api/verderamen.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:redux/redux.dart';

void middleware(Store<AppState> store, action, NextDispatcher next) {
  var logger = Logger(level: Level.debug);
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
      store.dispatch(AuthenticateActionSuccess(telemetries));
    }).catchError((Object e) {
      logger.e(e);
      if (action.onError != null) {
        action.onError!(e);
      }
      store.dispatch(AuthenticateActionError(e.toString()));
    });
  }

  next(action);
}
