import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:massigym_flutter/models/statistics_model.dart';

// schermata che mostra le statistiche del numero di workouts per ogni categoria di allenamento e genera un grafico a torta
// attraverso l'utilizzo del package "charts_flutter"
class WorkoutsPerCategory extends StatefulWidget {
  WorkoutsPerCategory({Key? key}) : super(key: key);

  @override
  _WorkoutsPerCategoryState createState() => _WorkoutsPerCategoryState();
}

class _WorkoutsPerCategoryState extends State<WorkoutsPerCategory> {
  List<charts.Series<StatisticsModel, String>> seriesBarData = [];
  List<StatisticsModel> data = [];

  // metodo che serve ad ottenere i dati per costruire il grafico a partire da un oggetto di tipo StatisticsModel
  generateData(data) {
    seriesBarData.add(charts.Series(
        // categoria da analizzare
        domainFn: (StatisticsModel statistics, _) =>
            statistics.category.toString(),
        // numero di workout per ciascuna categoria
        measureFn: (StatisticsModel statistics, _) => statistics.totalWorkouts,
        // colore della sezione circolare
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
                  // realizzazione del grafico a torta
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
                  // proprietà della circonferenza
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                          // numero di workout rappresentati all'interno di ciascuno spicchio
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
