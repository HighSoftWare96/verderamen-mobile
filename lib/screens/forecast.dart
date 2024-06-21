import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/components/four_o_four.dart';
import 'package:verderamen_mobile/components/transparent-btn.dart';
import 'package:verderamen_mobile/screens/login.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:verderamen_mobile/utils/hooks.dart';

class Forecast extends StatefulWidget {
  const Forecast({super.key});

  @override
  createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  @override
  void initState() {
    onFirstBuild((_) {
      StoreProvider.of<AppState>(context).dispatch(StartPollingAction());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final h1 = theme.textTheme.headlineLarge;

    return Scaffold(
        body: SafeArea(
            top: false,
            child: LayoutBuilder(builder: (context, contraints) {
              return StoreConnector(
                  converter: (Store<AppState> store) => store,
                  builder: (context, store) {
                    final telemetries = store.state.telemetries;
                    final bool willRain = telemetries?['telemetries']
                        ?['weather']?['stats']?['will_rain'];

                    return Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.black45.withOpacity(.6),
                                    BlendMode.darken),
                                child: Image(
                                    image: AssetImage(willRain
                                        ? 'assets/rainy.jpg'
                                        : 'assets/sunny.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            if (store.state.telemetries == null) {
                              return const FourOFour();
                            }

                            return ListView(
                              reverse: true,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: contraints.maxHeight -
                                          MediaQuery.of(context)
                                              .viewPadding
                                              .top),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50, left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TransparentButton(
                                                          onPressed: _goBack,
                                                          icon: Icons
                                                              .chevron_left,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white38),
                                                        ),
                                                        Text(
                                                          'Forecast',
                                                          style: TextStyle(
                                                              color: theme
                                                                  .primaryColor,
                                                              height: .8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  h1?.fontSize),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                            ],
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            );
                          })
                        ]);
                  });
            })));
  }

  _logout(Store<AppState> store) {
    store.dispatch(LogoutAction(onSuccess: _logoutComplete));
  }

  _logoutComplete() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  _goBack() {
    Navigator.of(context).pop();
  }
}

/**
 * Palette
 * #05668D
 * #427AA1
 * #4CAF50
 * #EBF2FA
 * #D3F3EE
 */