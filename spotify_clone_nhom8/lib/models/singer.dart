class Singer {
  Singer({
    required this.id,
    required this.name,
    required this.genre,
  });

  final int? id;
  final String? name;
  final String? genre;

  factory Singer.fromJson(Map<String, dynamic> json) {
    return Singer(
      id: json["id"],
      name: json["name"],
      genre: json["genre"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "genre": genre,
      };
}
