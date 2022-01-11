class StatisticsModel {
  int? totalWorkouts;
  int? totalLikes;
  String? category;
  String? color;

  StatisticsModel(
      {this.totalLikes, this.totalWorkouts, this.category, this.color});

  factory StatisticsModel.fromMap(map) {
    return StatisticsModel(
        totalWorkouts: map["totalWorkouts"],
        totalLikes: map["totalLikes"],
        category: map["category"],
        color: map["color"]);
  }
}
