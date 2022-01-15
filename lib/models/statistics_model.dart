
// model delle statistiche
class StatisticsModel {
  int? totalWorkouts;
  int? totalLikes;
  String? category;
  String? color;

  StatisticsModel(
      {this.totalLikes, this.totalWorkouts, this.category, this.color});

  // ottiene i dati della statistica dal db e li inserisce all'interno di un oggetto di tipo StatisticsModel
  factory StatisticsModel.fromMap(map) {
    return StatisticsModel(
        totalWorkouts: map["totalWorkouts"],
        totalLikes: map["totalLikes"],
        category: map["category"],
        color: map["color"]);
  }
}
