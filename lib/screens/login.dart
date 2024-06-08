import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/layouts/bottom_cover.dart';
import 'package:verderamen_mobile/screens/dashboard.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:verderamen_mobile/utils/hooks.dart';
import 'package:verderamen_mobile/utils/logger.dart';
import 'package:verderamen_mobile/utils/storage.dart';

String? validatorRequired(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo richiesto';
  }
  return null;
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State {
  TextEditingController endpointController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    endpointController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(endpoint: endpointController.text));
    });
    usernameController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(username: usernameController.text));
    });
    passwordController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(password: passwordController.text));
    });

    _tryInitialLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = StoreProvider.of<AppState>(context).state;
    endpointController.text = state.endpoint;
    usernameController.text = state.username;
    passwordController.text = state.password;
  }

  @override
  void dispose() {
    endpointController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final h1 = theme.textTheme.headlineLarge;

    return BottomCoverLayout(
        backgroundImage: 'assets/login-background.jpg',
        topBuilder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: MediaQuery.of(context).viewPadding.top +
                  constraints.maxHeight * (.2),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Image(
                width: 90,
                height: 100,
                image: AssetImage('assets/verderamen.png'),
              ),
              Text(
                'Get started!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: h1?.color,
                    fontSize: h1?.fontSize),
              ),
              Text(
                'Verderamen',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColor,
                    fontSize: 20),
              ),
            ]),
          );
        },
        bodyBuilder: (context, constraints) {
          return StoreConnector(
              converter: (Store<AppState> store) => store,
              builder: (context, store) {
                if (store.state.isLoadingAuth) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text('Loading...'))
                          ],
                        ),
                      ));
                }

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: endpointController,
                                  decoration: const InputDecoration(
                                    labelText: 'Server endpoint',
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: validatorRequired,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: validatorRequired,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: validatorRequired,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minWidth: 300),
                                    child: FilledButton(
                                        style: ButtonStyle(
                                          fixedSize:
                                              WidgetStateProperty.all<Size>(
                                            const Size(200.0,
                                                50.0), // Button width and height
                                          ),
                                        ),
                                        onPressed: () =>
                                            _submitForm(store, context),
                                        child: const Text('Invia')))
                              ],
                            ),
                          ),
                        ]));
              });
        });
  }

  _submitForm(Store<AppState> store, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      store.dispatch(
          AuthenticateAction(onError: _onError, onSuccess: _onSuccess));
    }
  }

  _tryInitialLogin() {
    onFirstBuild((_) {
      try {
        // try initial login with stored credentials
        Future.wait([
          getSecureKey('endpoint'),
          getSecureKey('username'),
          getSecureKey('password')
        ]).then((results) {
          final [endpoint, username, password] = results;
          StoreProvider.of<AppState>(context).dispatch(AuthenticateUpdateAction(
              endpoint: endpoint, username: username, password: password));
          StoreProvider.of<AppState>(context).dispatch(AuthenticateAction(
              onSuccess: (Map telemetries) =>
                  _onSuccess(telemetries, silent: true),
              onError: (_) {}));
        });
      } catch (e) {
        logger.e(e);
      }
    });
  }

  _onSuccess(Map telemetries, {silent = false}) {
    if (!silent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login OK!'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  _onError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
            'API Error!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent),
    );
  }
}
