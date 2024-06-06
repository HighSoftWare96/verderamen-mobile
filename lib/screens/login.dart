import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/screens/dashboard.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
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
  OverlayEntry? _overlay;
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verderamen',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.green,
        ),
        body: StoreConnector(
            converter: (Store<AppState> store) => store,
            builder: (context, store) {
              return Overlay(
                initialEntries: [
                  OverlayEntry(builder: (context) {
                    return LayoutBuilder(
                        builder: (context, constraints) => ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Image(
                                              height: 200,
                                              image: AssetImage(
                                                  'assets/verderamen.png')),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            controller: endpointController,
                                            decoration: const InputDecoration(
                                              labelText: 'Server endpoint',
                                              border: OutlineInputBorder(),
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
                                              border: OutlineInputBorder(),
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
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: validatorRequired,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FilledButton(
                                              onPressed: () =>
                                                  _submitForm(store, context),
                                              child: const Text('Invia'))
                                        ],
                                      ),
                                    ),
                                  )
                                ]));
                  })
                ],
              );
            }));
  }

  _submitForm(Store<AppState> store, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _showLoadingOverlay(context);
      store.dispatch(
          AuthenticateAction(onError: _onError, onSuccess: _onSuccess));
    }
  }

  _tryInitialLogin() {
    try {
      _showLoadingOverlay(context);
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
                _onSuccess(telemetries, silent: true)));
      });
    } catch (e) {
      logger.e(e);
    }
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

    _hideLoadingOverlay(context);
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
    _hideLoadingOverlay(context);
  }

  _showLoadingOverlay(BuildContext context) {
    if (_overlay != null) {
      return;
    }

    _overlay = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: 0,
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            color: Colors.green.withAlpha(90),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text('Caricamento in corso...'))
              ],
            ),
          ));
    });
    Overlay.of(context).insert(_overlay!);
  }

  _hideLoadingOverlay(BuildContext context) {
    if (_overlay == null) {
      return;
    }

    _overlay!.remove();
    _overlay = null;
  }
}
