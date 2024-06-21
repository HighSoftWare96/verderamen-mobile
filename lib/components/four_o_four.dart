import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/screens/login.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';

class FourOFour extends StatelessWidget {
  const FourOFour({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyedSubtree(
        key: UniqueKey(),
        child: Expanded(
            child: StoreConnector(
                converter: (Store<AppState> store) => store,
                builder: (context, store) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                          width: 80, image: AssetImage('assets/melanzana.png')),
                      const Text('404',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 65)),
                      const Text(
                        'Nothing to see in here...',
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: FilledButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    theme.secondaryHeaderColor),
                                fixedSize: WidgetStateProperty.all<Size>(
                                  const Size(
                                      200.0, 50.0), // Button width and height
                                ),
                              ),
                              onPressed: () => _logout(store, context),
                              child: const Text('Log out')))
                    ],
                  );
                })));
  }

  _logout(Store<AppState> store, context) {
    store.dispatch(LogoutAction(onSuccess: () => _logoutComplete(context)));
  }

  _logoutComplete(context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}


// black: #212626
// green1: #678C30
// green2: #8FA66D
// brown1: #BF8C60
// brown2: #8C593B