import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:massigym_flutter/models/statistics_model.dart';

// schermata che mostra le statistiche del numero di likes per ogni categoria di allenamento e genera un istogramma
// attraverso l'utilizzo del package "charts_flutter"
class LikesPerCategory extends StatefulWidget {
  LikesPerCategory({Key? key}) : super(key: key);

  @override
  _LikesPerCategoryState createState() => _LikesPerCategoryState();
}

class _LikesPerCategoryState extends State<LikesPerCategory> {
  List<charts.Series<StatisticsModel, String>> seriesBarData = [];
  List<StatisticsModel> data = [];

  // metodo che serve ad ottenere i dati per costruire il grafico a partire da un oggetto di tipo StatisticsModel
  generateData(data) {
    seriesBarData.add(charts.Series(
        // asse x del grafico rappresentato dalle categorie
        domainFn: (StatisticsModel statistics, _) =>
            statistics.category.toString(),
        // asse y del grafico rappresentato dal numero di likes
        measureFn: (StatisticsModel statistics, _) => statistics.totalLikes,
        // colore delle barre verticali
        colorFn: (StatisticsModel statistics, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(statistics.color!))),
        id: "Likes",
        data: data,
        labelAccessorFn: (StatisticsModel row, _) => "${row.category}"));
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
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Likes per categoria",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                // realizzazione dell'istogramma
                  child: charts.BarChart(
                seriesBarData,
                animate: true,
                animationDuration: Duration(seconds: 5),
                behaviors: [
                  new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: "Georgia",
                          fontSize: 18))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
