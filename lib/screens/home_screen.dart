import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:bpm_mobile/screens/screens.dart';

import 'package:bpm_mobile/services/services.dart';
import 'package:fl_chart/fl_chart.dart'
    show PieChart, PieChartData, PieChartSectionData;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    const counter = 1;
    // if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
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
            icon: const Icon(Icons.login_outlined),
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
            print(data);
            return _buildBody(context);
          }),
    );
  }

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildStats(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTitledContainer(
              "Ventas",
              child: SizedBox(
                height: 200,
                child: DonutPieChart.withSampleData(),
              ),
            ),
          ),
        ),
        _buildActivities(context),
      ],
    );
  }

  SliverPadding _buildStats() {
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
                const Text(
                  "+1",
                  style: stats,
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
                const Text(
                  "+1",
                  style: stats,
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
                const Text(
                  "+2",
                  style: stats,
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

  Container _buildTitledContainer(String title,
      {Widget? child, double? height}) {
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }
}

class DonutPieChart extends StatelessWidget {
  final List<PieChartSectionData> seriesList;

  const DonutPieChart(this.seriesList);

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData() {
    return DonutPieChart(
      _createSampleData(),
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
  static List<PieChartSectionData> _createSampleData() {
    final data = [
      PieChartSectionData(
        value: 100,
        title: "July",
        color: Colors.red.shade400,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1,
      ),
      PieChartSectionData(
        title: "August",
        value: 75,
        color: Colors.blue.shade400,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1,
      ),
      PieChartSectionData(
        title: "September",
        value: 25,
        color: Colors.green.shade400,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1,
      ),
      PieChartSectionData(
        title: "October",
        value: 50,
        color: Colors.purple.shade400,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1,
      ),
    ];

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
  Activity({this.title, this.icon});
}

final List<Activity> activities = [
  Activity(title: "Pedidos", icon: FontAwesomeIcons.listOl),
  Activity(title: "Productos", icon: FontAwesomeIcons.solidBell),
  Activity(title: "Recorridos", icon: FontAwesomeIcons.truckMoving),
];
