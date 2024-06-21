import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:verderamen_mobile/components/four_o_four.dart';
import 'package:verderamen_mobile/components/mini_card.dart';
import 'package:verderamen_mobile/components/transparent-btn.dart';
import 'package:verderamen_mobile/screens/forecast.dart';
import 'package:verderamen_mobile/screens/login.dart';
import 'package:verderamen_mobile/store/actions.dart';
import 'package:verderamen_mobile/store/reducer.dart';
import 'package:verderamen_mobile/utils/hooks.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
              return Stack(alignment: AlignmentDirectional.topStart, children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black45.withOpacity(.6), BlendMode.darken),
                      child: const Image(
                          image: AssetImage('assets/dashboard.jpg'),
                          fit: BoxFit.cover)),
                ),
                StoreConnector(
                    converter: (Store<AppState> store) => store,
                    builder: (context, store) {
                      if (store.state.telemetries == null) {
                        return const FourOFour();
                      }

                      final telemetries = store.state.telemetries;
                      final isValveOpen = telemetries?['telemetries']?['valve']
                              ?['stats']?['is_open'] ==
                          true;
                      final DateTime? lastValveOpen =
                          telemetries?['telemetries']?['valve']?['stats']
                                      ?['last_opened'] !=
                                  null
                              ? DateTime.parse(telemetries?['telemetries']
                                  ?['valve']?['stats']?['last_opened'])
                              : null;
                      final bool willRain = telemetries?['telemetries']
                          ?['weather']?['stats']?['will_rain'];
                      final double tank_level = (telemetries?['telemetries']
                          ?['tank']?['stats']?['percentage'] as double);

                      return ListView(
                        reverse: true,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxHeight: contraints.maxHeight -
                                    MediaQuery.of(context).viewPadding.top),
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
                                              Text(
                                                'Welcome to',
                                                style: TextStyle(
                                                    height: 1.7,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        h1!.fontSize! + 2),
                                              ),
                                              Text(
                                                'verderamen',
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    height: .8,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: h1?.fontSize),
                                              ),
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TransparentButton(
                                                  icon: Icons.refresh,
                                                  padding: EdgeInsets.only(right: 20),
                                                  onPressed: () {
                                                    store.dispatch(
                                                        AuthenticateAction());
                                                  },
                                                ),
                                                TransparentButton(
                                                  icon: Icons.logout,
                                                  onPressed: () {
                                                    store.dispatch(LogoutAction(
                                                        onSuccess:
                                                            _logoutComplete));
                                                  },
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 150,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: isValveOpen
                                                ? const Color(0xFF678C30)
                                                : (lastValveOpen != null
                                                    ? const Color(0xFF678C30)
                                                    : const Color(0xFF8FA66D))),
                                        constraints: const BoxConstraints(
                                            minHeight: 100),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25,
                                                bottom: 25,
                                                left: 20,
                                                right: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (isValveOpen)
                                                  const Image(
                                                      width: 80,
                                                      image: AssetImage(
                                                          'assets/pomodoro.png')),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text('Status'),
                                                      Text(
                                                        !isValveOpen
                                                            ? (lastValveOpen !=
                                                                    null
                                                                ? 'Last watering: true'
                                                                : 'No watering data')
                                                            : 'Watering right now...',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20),
                                                      )
                                                    ])
                                              ],
                                            ))),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        MiniCard(
                                            height: 200,
                                            iconAsset: 'assets/hw.png',
                                            mainText:
                                                '${(store.state.telemetries?['os']['cpu_temp_celsius'] as double?)?.toStringAsFixed(1)} °C',
                                            backgroundColor:
                                                const Color(0xff678C30),
                                            secondaryTexts: [
                                              'CPU: ${(store.state.telemetries?['os']['cpu_used'] as double?)?.toStringAsFixed(1)} %',
                                              'MEM: ${(store.state.telemetries?['os']['mem_used'] as double?)?.toStringAsFixed(1)} %',
                                            ],
                                            title: 'Hardware'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MiniCard(
                                            height: 200,
                                            iconAsset: 'assets/water.png',
                                            mainText:
                                                '${(telemetries?['telemetries']?['final_score'] as double?)?.toStringAsFixed(2) ?? 'N/A'} %',
                                            backgroundColor:
                                                const Color(0xff1A535C),
                                            title: 'Watering'),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        MiniCard(
                                            height: 200,
                                            iconAsset: 'assets/tank.png',
                                            mainText:
                                                '${(tank_level)?.toStringAsFixed(1) ?? 'N/A'} %',
                                            backgroundColor:
                                                const Color(0xff243E36),
                                            title: 'Tank'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MiniCard(
                                            height: 200,
                                            onPressed: _gotoForecast,
                                            iconAsset: 'assets/forecast.png',
                                            mainText:
                                                willRain ? 'Rainy!' : 'No rain',
                                            backgroundColor: willRain
                                                ? const Color(0xffBF8C60)
                                                : const Color(0xff8C593B),
                                            secondaryTexts: [
                                              '${store.state.telemetries?['telemetries']?['weather']?['stats']?['next_24_precip_mm']} mm',
                                              '${store.state.telemetries?['telemetries']?['weather']?['stats']?['next_24_temp_mean']} °C',
                                            ],
                                            title: 'Forecast'),
                                      ],
                                    )
                                  ],
                                )),
                          )
                        ],
                      );
                    })
              ]);
            })));
  }

  _logout(Store<AppState> store) {
    store.dispatch(LogoutAction(onSuccess: _logoutComplete));
  }

  _logoutComplete() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  _gotoForecast() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Forecast()));
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