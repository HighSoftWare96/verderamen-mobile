import "package:flutter/material.dart";
import "package:verderamen_mobile/utils/alice.dart";
import "package:verderamen_mobile/screens/login.dart";
import "package:verderamen_mobile/store/middlewares.dart";
import "package:verderamen_mobile/store/reducer.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final store = Store(reducer,
      initialState: AppState.initialState(), middleware: [middleware]);

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            navigatorKey: alice.getNavigatorKey(),
            title: 'Verderamen',
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.green, brightness: Brightness.dark)),
            themeMode: ThemeMode.dark,
            home: LoginScreen()));
  }
}
