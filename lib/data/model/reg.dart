class Reg {
  final String title;
  final String description;
  final String manager;
  final String id;

  Reg({this.title, this.description, this.id, this.manager});

  Reg.fromMap(Map<String, dynamic> data, String id)
      : title = data["title"],
        description = data['description'],
        manager = data["manager"],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "manager": manager,
    };
  }
}
