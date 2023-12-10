import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/sql_helper.dart';

class GormiCard extends StatelessWidget {
  final String name;
  final String popolo;
  final String serie;
  final String availability;
  final bool isEdicola;
  final Color textColor;
  final RxBool ownIt; // Utilizziamo RxBool per una variabile osservabile
  final int id;
  final String image; // Aggiunto percorso dell'immagine

  const GormiCard({
    Key? key,
    required this.name,
    required this.popolo,
    required this.serie,
    required this.availability,
    required this.isEdicola,
    required this.textColor,
    required this.ownIt,
    required this.id,
    required this.image, // Aggiunto percorso dell'immagine
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          color: Colors.black,
          shape: _buildCardShape(),
          shadowColor: Colors.black,
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              const Divider(
                height: 2,
                color: Colors.black,
              ),
              _buildImage(),
            ],
          ),
        ));
  }

  ShapeBorder _buildCardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(
        width: 3,
        color: Color.fromARGB(255, 43, 43, 43),
      ),
    );
  }

  void _navigateToDetail(int id) {
    Get.toNamed('/Detail', arguments: id);
  }

  Widget _buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () {
              _navigateToDetail(id);
            },
            child: _buildGormitiImage(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameText(),
              const SizedBox(height: 5),
              Row(
                children: [
                  _buildPopoloText(),
                  const SizedBox(width: 5),
                  _buildSerieText()
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: Align(
            alignment: Alignment.topRight,
            child: _buildOwnCheck(),
          ),
        ),
      ],
    );
  }

  Widget _buildGormitiImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          image,
          height: 200,
          width: 200,
        ), // Utilizza la proprietà img come percorso dell'immagine
      ),
    );
  }

  Widget _buildNameText() {
    return Text(
      name,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildPopoloText() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        popolo,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSerieText() {
    return InkWell(
      onTap: () {
        _navigateToPeople(serie);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.lightGreen[200],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          serie,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildOwnCheck() {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            _navigateToSearch(name.toLowerCase());
          },
          child: const Icon(
            Icons.search,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            bool isOk = await SQLHelper().ownChangerGormita(id, !ownIt.value);
            if (isOk) {
              ownIt.value = !ownIt.value;
            }
          },
          child: Icon(
            ownIt.value ? Icons.star : Icons.star_border,
            color: ownIt.value ? Colors.yellow : Colors.grey,
            size: 15,
          ),
        ),
      ],
    );
  }

  void _navigateToPeople(String serieName) {
    Get.toNamed('/Popoli', arguments: serieName);
  }

  void _navigateToSearch(String name) {
    Get.toNamed('/SearchBar', arguments: name);
  }
}
