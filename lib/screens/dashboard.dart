import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.green,
        ),
        body: StoreConnector(
            converter: (Store<AppState> store) => store,
            builder: (context, store) {
              if (store.state.telemetries == null) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thunderstorm,
                      size: 40,
                    ),
                    Text(
                      'No telemetries...',
                      style: TextStyle(height: 6),
                    ),
                  ],
                ));
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
              final double tank_level = (telemetries?['telemetries']?['tank']
                  ?['stats']?['percentage'] as double);

              return LayoutBuilder(builder: (context, contraints) {
                return ListView(
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: contraints.maxHeight),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 50),
                                  color: isValveOpen
                                      ? Colors.amber
                                      : (lastValveOpen != null
                                          ? Colors.green
                                          : Colors.grey),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isValveOpen)
                                        const Text(
                                          'Watering right now...',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black87),
                                        )
                                      else if (lastValveOpen != null)
                                        const Text(
                                          'Last watering: true',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87),
                                        )
                                      else
                                        const Text('No watering data...')
                                    ],
                                  )),
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
                                                const Icon(Icons.thermostat),
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
                                                      color: Colors.black54),
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
                                                      color: Colors.black54),
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
            }));
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