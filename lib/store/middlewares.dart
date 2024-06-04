import 'package:verderamen_mobile/store/reducer.dart';
import 'package:redux/redux.dart';

List<dynamic Function(Store<AppState>, dynamic, dynamic)> middlewares = [];