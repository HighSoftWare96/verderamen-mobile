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
            theme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF74BF04), // Blu scuro
              scaffoldBackgroundColor:
                  const Color(0xFF121212), // Tipico sfondo dark mode
              colorScheme: const ColorScheme.dark().copyWith(
                primary: const Color(0xFF74BF04), // Blu scuro
                secondary: const Color(0xFF0388A6), // Verde chiaro
                surface: const Color(0xFF37474F), // Colore delle superfici
                error: const Color(0xFFF24405), // Arancione scuro
                onPrimary:
                    Colors.white, // Colore del testo sopra il colore primario
                onSecondary:
                    Colors.black, // Colore del testo sopra il colore secondario
                onSurface: Colors.white, // Colore del testo sopra le superfici
                onError:
                    Colors.black, // Colore del testo sopra il colore di errore
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white70),
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Color(0xFFF27405), // Arancione chiaro
                textTheme: ButtonTextTheme.primary,
              ),
              appBarTheme: const AppBarTheme(
                color: Color(0xFF0388A6), // Blu scuro
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFF27405), // Arancione chiaro
              ),
            ),
            home: LoginScreen()));
  }
}
