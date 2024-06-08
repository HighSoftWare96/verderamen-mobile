import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
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
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: StoreConnector(
                converter: (Store<AppState> store) => store,
                builder: (context, store) {
                  if (store.state.telemetries == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                            width: 80,
                            image: AssetImage('assets/melanzana.png')),
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
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          theme.secondaryHeaderColor),
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size(
                                        200.0, 50.0), // Button width and height
                                  ),
                                ),
                                onPressed: () => _logout(store),
                                child: const Text('Log out')))
                      ],
                    );
                  }

                  final telemetries = store.state.telemetries;
                  final isValveOpen = telemetries?['telemetries']?['valve']
                          ?['stats']?['is_open'] ==
                      true;
                  final DateTime? lastValveOpen = telemetries?['telemetries']
                              ?['valve']?['stats']?['last_opened'] !=
                          null
                      ? DateTime.parse(telemetries?['telemetries']?['valve']
                          ?['stats']?['last_opened'])
                      : null;
                  final bool willRain = telemetries?['telemetries']?['weather']
                      ?['stats']?['will_rain'];
                  final double tank_level = (telemetries?['telemetries']
                      ?['tank']?['stats']?['percentage'] as double);

                  return LayoutBuilder(builder: (context, contraints) {
                    return ListView(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/dashboard.jpg'))),
                          constraints:
                              BoxConstraints(maxHeight: contraints.maxHeight),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).viewPadding.top +
                                          20,
                                  horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to',
                                    style: TextStyle(
                                        height: 1.7,
                                        fontWeight: FontWeight.bold,
                                        fontSize: h1!.fontSize! + 2),
                                  ),
                                  Text(
                                    'verderamen',
                                    style: TextStyle(
                                        color: theme.primaryColor,
                                        height: .8,
                                        fontWeight: FontWeight.bold,
                                        fontSize: h1?.fontSize),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: isValveOpen
                                              ? const Color(0xFF74BF04)
                                              : (lastValveOpen != null
                                                  ? Colors.green
                                                  : Colors.grey)),
                                      constraints:
                                          const BoxConstraints(minHeight: 100),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25,
                                              bottom: 25,
                                              left: 20,
                                              right: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                  width: 80,
                                                  image: isValveOpen
                                                      ? const AssetImage(
                                                          'assets/pomodoro.png')
                                                      : const AssetImage(
                                                          'assets/pomodoro-off.png')),
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
                                      Expanded(
                                          child: Container(
                                        height: 200,
                                        color: const Color(0xff05668D),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Column(children: [
                                              Icon(
                                                Icons.memory,
                                                size: 80,
                                              ),
                                              Text(
                                                'Hardware',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.thermostat),
                                                    Text(
                                                        '${(store.state.telemetries?['os']['cpu_temp_celsius'] as double?)?.toStringAsFixed(1)} °C')
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.percent),
                                                    Text(
                                                        '${(store.state.telemetries?['os']['cpu_used'] as double?)?.toStringAsFixed(1)} %')
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: 200,
                                        color: const Color(0xff427AA1),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Column(children: [
                                              Icon(
                                                Icons.water_drop,
                                                size: 80,
                                              ),
                                              Text(
                                                'Watering',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.waterfall_chart),
                                                    Text(
                                                        '${(telemetries?['telemetries']?['final_score'] as double?)?.toStringAsFixed(2) ?? 'N/A'} %')
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        height: 200,
                                        color: willRain
                                            ? Colors.orange
                                            : const Color(0xffD3F3EE),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(children: [
                                              if (willRain)
                                                const Icon(
                                                  Icons.thunderstorm,
                                                  color: Colors.black45,
                                                  size: 80,
                                                )
                                              else
                                                const Icon(
                                                  Icons.sunny,
                                                  size: 80,
                                                  color: Colors.black45,
                                                ),
                                              const Text(
                                                'Forecast',
                                                style: TextStyle(
                                                    height: 2,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.water,
                                                        color: Colors.black45),
                                                    Text(
                                                      '${store.state.telemetries?['telemetries']?['weather']?['stats']?['next_24_precip_mm']} mm',
                                                      style: const TextStyle(
                                                          height: 2,
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.thermostat,
                                                        color: Colors.black45),
                                                    Text(
                                                      '${store.state.telemetries?['telemetries']?['weather']?['stats']?['next_24_temp_mean']} °C',
                                                      style: const TextStyle(
                                                          height: 2,
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: 200,
                                        color: tank_level > 10
                                            ? const Color(0xffD3F3EE)
                                            : Colors.orange,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Column(children: [
                                              Icon(
                                                Icons.takeout_dining,
                                                color: Colors.black54,
                                                size: 80,
                                              ),
                                              Text(
                                                'Tank',
                                                style: TextStyle(
                                                    height: 2,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.water,
                                                      color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '${(tank_level)?.toStringAsFixed(1) ?? 'N/A'} %',
                                                        style: const TextStyle(
                                                          color: Colors.black54,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  )
                                ],
                              )),
                        )
                      ],
                    );
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
}

/**
 * Palette
 * #05668D
 * #427AA1
 * #4CAF50
 * #EBF2FA
 * #D3F3EE
 */