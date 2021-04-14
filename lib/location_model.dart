class Loc {
  int id;
  double lat;
  double lon;
  String name;
  String note;

  Loc({this.lat, this.lon, this.name, this.note});

  categoryLocation() {
    var mapping = Map<String, dynamic>();
    mapping["id"] = id;
    mapping["lat"] = lat;
    mapping["lon"] = lon;
    mapping["name"] = name;
    mapping["note"] = note;

    return mapping;
  }
}
