import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bpm_mobile/models/notification.dart';
import 'package:bpm_mobile/models/order.dart';
import 'package:bpm_mobile/models/report_by_months.dart';
import 'package:bpm_mobile/screens/update_order_screen.dart';
import 'package:bpm_mobile/services/dashboard_service.dart';
import 'package:bpm_mobile/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:bpm_mobile/services/services.dart';
import 'package:fl_chart/fl_chart.dart'
    show PieChart, PieChartData, PieChartSectionData;

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:bpm_mobile/services/awesome_notification_service.dart';
import 'package:bpm_mobile/util/utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  late io.Socket socket;

  void connect() {
    socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => print('onConnect'));
    socket.on('new-notification', (data) async {
      final notification = NotificationModel.fromJson(data);
      setState(() {
        counter++;
      });
      await createNotificationOnEvent(
        notification.title,
        "#${notification.order.sequential}",
      );
    });
    socket.on('new-order', (data) {
      // print(data);
      // final order = Order.fromJson(data);
      // print(order);
    });
    socket.on('status-updated', (data) {
      final order = Order.fromJson(data);
      print(order);
    });
    socket.on('disconnection', (_) => print('disconnect'));
    print("connected: ${socket.connected}");
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then(
                        (_) => Navigator.pop(context),
                      ),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    AwesomeNotifications().createdStream.listen(
      (notification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification Created on ${notification.channelKey}',
            ),
          ),
        );
      },
    );

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const UpdateOrderScreen(),
        ),
        (route) => route.isFirst,
      );
    });
    connect();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final dashboardService = Provider.of<DashboardService>(context);
    // if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, 'notifications');
                },
              ),
              counter != 0
                  ? Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.login_outlined,
            ),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: authService.readToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return const Text('');
          final data = jsonDecode(snapshot.data!);
          if (data['rol'] == 'admin') {}
          return _buildAdminBody(context, dashboardService);
        },
      ),
    );
  }

  _buildOtherRolBody(BuildContext context) {}

  _buildAdminBody(BuildContext context, DashboardService dashboardService) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildStats(dashboardService),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildTitledContainer(
              "Ventas",
              child: FutureBuilder(
                future: dashboardService.getTotalsByMonth(),
                builder: (_, AsyncSnapshot<List<ReportByMonth>> snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData) {
                    return AspectRatio(
                      aspectRatio: 1.3,
                      child: Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: DonutPieChart.withSampleData(data!),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: linear.map((e) {
                              return Column(
                                children: [
                                  Indicator(
                                    color: e.color,
                                    text: e.month,
                                    isSquare: true,
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
        _buildActivities(context),
      ],
    );
  }

  SliverPadding _buildStats(DashboardService dashboardService) {
    const TextStyle stats = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.white,
    );
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: dashboardService.getTotalSuppliers(),
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    int? counter = snapshot.data;
                    if (snapshot.hasData) {
                      if (counter != null) {
                        return Text(
                          "+$counter",
                          style: stats,
                        );
                      }
                      return const Text(
                        "+0",
                        style: stats,
                      );
                    }
                    return const Text(
                      "+0",
                      style: stats,
                    );
                  },
                ),
                const SizedBox(height: 5.0),
                Text("Proveedores".toUpperCase())
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.pink,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: dashboardService.getTotalCustomers(),
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    int? counter = snapshot.data;
                    if (snapshot.hasData) {
                      if (counter != null) {
                        return Text(
                          "+$counter",
                          style: stats,
                        );
                      }
                      return const Text(
                        "+0",
                        style: stats,
                      );
                    }
                    return const Text(
                      "+0",
                      style: stats,
                    );
                  },
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Clientes".toUpperCase(),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: dashboardService.getTotalOrders(),
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    int? counter = snapshot.data;
                    if (snapshot.hasData) {
                      if (counter != null) {
                        return Text(
                          "+$counter",
                          style: stats,
                        );
                      }
                      return const Text(
                        "+0",
                        style: stats,
                      );
                    }
                    return const Text(
                      "+0",
                      style: stats,
                    );
                  },
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Pedidos".toUpperCase(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Actividades",
          height: 150,
          child: Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: activities
                  .map(
                    (activity) => Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).buttonColor,
                          child: activity.icon != null
                              ? Icon(
                                  activity.icon,
                                  size: 18.0,
                                )
                              : null,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          activity.title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTitledContainer(
    String title, {
    Widget? child,
    double? height,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }
}

class IndicatorData {
  Color color;
  String month;

  IndicatorData({
    required this.month,
    required this.color,
  });
}

List<IndicatorData> linear = [];

class DonutPieChart extends StatelessWidget {
  final List<PieChartSectionData> seriesList;

  DonutPieChart(
    this.seriesList,
  );

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData(List<ReportByMonth> report) {
    return DonutPieChart(
      _createSampleData(report),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40.0,
        sectionsSpace: 10.0,
        sections: seriesList,
      ),
      swapAnimationDuration: const Duration(milliseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }

  /// Create one series with sample hard coded data.
  static List<PieChartSectionData> _createSampleData(
    List<ReportByMonth> report,
  ) {
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.purple.shade400,
    ];
    linear = [];
    Random random = Random();
    final data = report.map((e) {
      final rng = random.nextInt(3);
      final color = colors[rng];
      linear.add(
        IndicatorData(
          month: month(e.month),
          color: color,
        ),
      );
      return PieChartSectionData(
        value: double.parse(e.total),
        title: e.total,
        color: color,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1,
      );
    }).toList();
    return data;
  }
}

/// Sample linear data type.
class LinearSales {
  final String month;
  final int sales;

  LinearSales(this.month, this.sales);
}

class Activity {
  final String? title;
  final IconData? icon;
  final VoidCallback onpress;
  Activity({
    this.title,
    this.icon,
    required this.onpress,
  });
}

final List<Activity> activities = [
  Activity(title: "Pedidos", icon: FontAwesomeIcons.listOl, onpress: () {}),
  Activity(title: "Productos", icon: FontAwesomeIcons.boxOpen, onpress: () {}),
  Activity(
      title: "Recorridos", icon: FontAwesomeIcons.truckMoving, onpress: () {}),
];
