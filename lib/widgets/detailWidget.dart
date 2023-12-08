import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../db/sql_helper.dart';
import '../model/gormita.dart';

class DetailWidget extends StatelessWidget {
  final int id;
  final String? name;
  final String? popolo;
  final String? serie;
  final String? availability;
  final bool? isEdicola;
  final Color? textColor;
  final RxBool? ownIt;
  final String? image;

  const DetailWidget({
    Key? key,
    required this.id,
    this.name,
    this.popolo,
    this.serie,
    this.availability,
    this.isEdicola,
    this.textColor,
    this.ownIt,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Gormita>(
      future: SQLHelper.getGormitaById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Errore: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('Nessun dato disponibile'),
          );
        } else {
          final gormita = snapshot.data!;
          return Container(
            color: Colors.black, // Set the background color here
            child: buildGormitaCard(gormita),
          );
        }
      },
    );
  }

  Widget buildGormitaCard(Gormita gormita) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black,
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTitle(gormita.name),
              const SizedBox(height: 18),
              _buildGormitiImage(gormita.image),
              _buildInfoSection(gormita),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGormitiImage(image) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 20), // Increase the vertical margin as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey, // Set the border color here
          width: 2, // Set the border width here
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // Adjust the border radius
        child: Container(
          width: double.infinity,
          height: 300,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              image,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Gormita gormita) {
    return Container(
      margin: EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Colore del bordo
          width: 1.0, // Larghezza del bordo
        ),
        borderRadius:
            BorderRadius.all(Radius.circular(8.0)), // Bordo arrotondato
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem("Popolo", gormita.popolo, Colors.blue),
          _buildInfoItem("Serie", gormita.serie, Colors.green),
          _buildInfoItem(
            "Posseduto",
            gormita.ownIt.value == true ? "Sì" : "No",
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            value ?? "N/A",
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
