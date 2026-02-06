class Gormita {
  final int id;
  final String name;
  final String availability;
  final String image;
  final String popolo;
  final String serie;
  final bool ownIt;
  final bool isEdicola;
  final bool isFavorite;

  const Gormita({
    required this.id,
    required this.name,
    required this.availability,
    required this.isEdicola,
    required this.image,
    required this.popolo,
    required this.serie,
    required this.ownIt,
    required this.isFavorite,
  });

  Gormita.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        availability = result["availability"],
        isEdicola = result["isEdicola"] == 1,
        image = result["image"],
        popolo = result["popolo"],
        serie = result["serie"],
        ownIt = result["own_it"] == 1,
        isFavorite = result["favorite"] == 1;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'availability': availability,
      'isEdicola': isEdicola,
      'image': image,
      'popolo': popolo,
      'serie': serie,
      'ownIt': ownIt,
      'isFavorite': isFavorite,
    };
  }

  Gormita copyWith({
    int? id,
    String? name,
    String? availability,
    String? image,
    String? popolo,
    String? serie,
    bool? ownIt,
    bool? isEdicola,
    bool? isFavorite,
  }) {
    return Gormita(
      id: id ?? this.id,
      name: name ?? this.name,
      availability: availability ?? this.availability,
      image: image ?? this.image,
      popolo: popolo ?? this.popolo,
      serie: serie ?? this.serie,
      ownIt: ownIt ?? this.ownIt,
      isEdicola: isEdicola ?? this.isEdicola,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
