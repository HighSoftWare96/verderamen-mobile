import "package:flutter/material.dart";
import "package:flutter_hello_world/screens/login.dart";
import "package:flutter_hello_world/store/middlewares.dart";
import "package:flutter_hello_world/store/reducer.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final store = Store(reducer,
      initialState: AppState.initialState(), middleware: middlewares);

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'Verderamen',
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green,
                  brightness: Brightness.dark
                )),
            themeMode: ThemeMode.dark,
            home: LoginScreen()));
  }
}
