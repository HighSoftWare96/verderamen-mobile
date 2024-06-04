import 'package:flutter/material.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
    super.initState();
    endpointController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(endpoint: endpointController.text));
    });
    usernameController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(endpoint: usernameController.text));
    });
    passwordController.addListener(() {
      StoreProvider.of<AppState>(context).dispatch(
          AuthenticateUpdateAction(endpoint: passwordController.text));
    });
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
              return LayoutBuilder(
                  builder: (ctx, constraints) => ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(
                                        height: 200,
                                        image: AssetImage(
                                            'assets/verderamen.png')),
                                    const SizedBox(height: 20,),
                                    TextFormField(
                                      controller: endpointController,
                                      decoration: const InputDecoration(
                                        labelText: 'Server endpoint',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: validatorRequired,
                                    ),
                                    const SizedBox(height: 20,),
                                    TextFormField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: validatorRequired,
                                    ),
                                    const SizedBox(height: 20,),
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
                                    const SizedBox(height: 20,),
                                    FilledButton(
                                        onPressed: submitForm,
                                        child: const Text('Invia'))
                                  ],
                                ),
                              ),
                            )
                          ]));
            }));
  }

  submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login...')),
      );
    }
  }
}
