import 'package:flutter_hello_world/store/reducer.dart';
import 'package:redux/redux.dart';

List<dynamic Function(Store<AppState>, dynamic, dynamic)> middlewares = [];