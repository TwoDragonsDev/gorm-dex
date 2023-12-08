import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckListCard extends StatelessWidget {
  final String name;
  final String popolo;
  final String serie;
  final String availability;
  final bool isEdicola;
  final String imagePath;
  final Color textColor;
  final RxBool ownIt; // Utilizziamo RxBool per una variabile osservabile
  final int id;

  const CheckListCard({
    Key? key,
    required this.name,
    required this.popolo,
    required this.serie,
    required this.availability,
    required this.isEdicola,
    required this.imagePath,
    required this.textColor,
    required this.ownIt,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: _buildCardShape(),
      shadowColor: Colors.black,
      elevation: 4,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(
            height: 5,
            color: Colors.black,
          ),
          _buildImage(),
        ],
      ),
    );
  }

  ShapeBorder _buildCardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        width: 1,
        color: ownIt.value
            ? const Color.fromARGB(255, 0, 255, 42)
            : const Color.fromARGB(255, 255, 0, 0),
      ),
    );
  }

  Widget _buildImage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Allinea al centro orizzontalmente
      children: [
        const Divider(
          height: 5,
          color: Colors.black,
        ),
        _buildGormitiImage(),
        _buildNameText(),
      ],
    );
  }

  Widget _buildGormitiImage() {
    return Align(
      alignment:
          Alignment.center, // Allinea al centro orizzontalmente e verticalmente
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            imagePath,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }

  Widget _buildNameText() {
    return Center(
      child: SizedBox(
        height: 30.0, // Imposta l'altezza del Container su due righe
        child: Align(
          //alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 5.0), // Imposta il margine a sinistra
            child: Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
