import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:massigym_flutter/models/statistics_model.dart';

class WorkoutsPerCategory extends StatefulWidget {
  WorkoutsPerCategory({Key? key}) : super(key: key);

  @override
  _WorkoutsPerCategoryState createState() => _WorkoutsPerCategoryState();
}

class _WorkoutsPerCategoryState extends State<WorkoutsPerCategory> {
  List<charts.Series<StatisticsModel, String>> seriesBarData = [];
  List<StatisticsModel> data = [];

  generateData(data) {
    seriesBarData.add(charts.Series(
        domainFn: (StatisticsModel statistics, _) =>
            statistics.category.toString(),
        measureFn: (StatisticsModel statistics, _) => statistics.totalWorkouts,
        colorFn: (StatisticsModel statistics, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(statistics.color!))),
        id: "Workouts",
        data: data,
        labelAccessorFn: (StatisticsModel row, _) => "${row.totalWorkouts}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody(context)),
    );
  }

  Widget buildBody(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("statistics").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            List<StatisticsModel> statistic = snapshot.data!.docs
                .map((e) => StatisticsModel.fromMap(e.data()))
                .toList();
            return buildChart(context, statistic);
          }
        });
  }

  Widget buildChart(BuildContext context, List<StatisticsModel> statistic) {
    data = statistic;
    generateData(data);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Workouts per categoria",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: charts.PieChart(
                  seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 5),
                  behaviors: [
                    new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 1,
                        cellPadding:
                            new EdgeInsets.only(right: 4, bottom: 4, top: 4),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: "Georgia",
                            fontSize: 18)),
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
                      ]),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
