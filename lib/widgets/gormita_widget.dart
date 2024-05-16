import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final RxBool isFavorite; // Utilizziamo RxBool per una variabile osservabile
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
    required this.image,
    required this.isFavorite, // Aggiunto percorso dell'immagine
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          color: Colors.black,
          shape: _buildCardShape(),
          shadowColor: Colors.black,
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              const Divider(
                height: 5,
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
              GestureDetector(
                  onTap: () {
                    _navigateToDetail(id);
                  },
                  child: _buildNameText()),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPopoloText(),
                  const SizedBox(width: 10),
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
        width: 100,
        height: 100,
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
        fontSize: 27,
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
          fontSize: 11,
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
            fontSize: 11,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildOwnCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            _navigateToSearch(name.toLowerCase());
          },
          child: const Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                bool isOk =
                    await SQLHelper().ownChangerGormita(id, !ownIt.value);
                if (isOk) {
                  ownIt.value = !ownIt.value;
                }
              },
              child: Icon(
                ownIt.value
                    ? Icons.expand_circle_down_outlined
                    : Icons.add_circle,
                color: ownIt.value ? Colors.green : Colors.grey,
                size: 35.0,
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool isOk =
                    await SQLHelper().favoriteGormita(id, !isFavorite.value);
                if (isOk) {
                  isFavorite.value = !isFavorite.value;
                }
              },
              child: Icon(
                isFavorite.value ? Icons.star : Icons.star_border,
                color: isFavorite.value ? Colors.yellow : Colors.grey,
                size: 35.0,
              ),
            )
          ],
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
