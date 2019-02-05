class Nation {
  String id;
  String name;
  String flag;
  List<Tank> tanks;

  Nation.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["ndbId"];
    name = json["name"];
    flag = json["flag"];

    List tanksField = json["tanks"] as List;
    tanks = tanksField?.map((entry) => Tank.fromJson(entry))?.toList();
  }
}

class Period {
  String id;
  String name;
  int start;
  int end;
  List<Tank> tanks;

  Period.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["ndbId"];
    name = json["name"];
    start = json["id"];
    end = json["end"];

    List tanksField = json["tanks"] as List;
    tanks = tanksField?.map((entry) => Tank.fromJson(entry))?.toList();
  }
}

class Tank {
  String id;
  String name;
  String description;
  List<String> photos;
  Nation nation;
  Period period;

  Tank.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json["ndbId"];
    name = json["name"];
    description = json["description"];

    List photosField = json["photos"] as List;
    photos = photosField?.map((entry) => entry as String)?.toList();

    nation = Nation.fromJson(json["nation"]);

    period = Period.fromJson(json["period"]);
  }
}

class AllNationsResponse {
  List<Nation> nations;
  AllNationsResponse.fromJson(Map<String, dynamic> json) {
    List nationsField = json["nations"] as List;
    nations = nationsField?.map((entry) => Nation.fromJson(entry))?.toList();
  }
}

class TankByIdResponse {
  Tank tank;
  TankByIdResponse.fromJson(Map<String, dynamic> json) {
    tank = Tank.fromJson(json["tank"]);
  }
}
