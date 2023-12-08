import 'package:get/get.dart';

class Gormita {
  final int id;
  final String name;
  final String availability;
  final String image;
  final String popolo;
  final String serie;
  final RxBool ownIt;
  final bool isEdicola;


  const Gormita({
    required this.id,
    required this.name,
    required this.availability,
    required this.isEdicola,
    required this.image,
    required this.popolo,
    required this.serie,
    required this.ownIt,
  });

  Gormita.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        availability = result["availability"],
        isEdicola = result["isEdicola"] == 1,
        image = result["image"],
        popolo = result["popolo"],
        serie = result["serie"],
        ownIt = (result["own_it"] == 1).obs; // Converti da INTEGER a bool
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
    };
  }
}
