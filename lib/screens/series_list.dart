import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gorm_wiki/utility/colors.dart';

import '../db/sql_helper.dart';
import '../widgets/series_widget.dart';

class SeriesList extends StatefulWidget {
  const SeriesList({super.key});

  @override
  _SeriesListState createState() => _SeriesListState();
}

class _SeriesListState extends State<SeriesList> {
  List<String> seriesList = [];

  @override
  void initState() {
    super.initState();
    _loadSeriesList();
  }

  Future<void> _loadSeriesList() async {
    final List<String> result = await SQLHelper.getDistinctSeries();
    setState(() {
      seriesList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: _buildSeriesList(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.account_circle,
                color: AppColors.textColor), // Icona del profilo
            onPressed: () {
              _navigateToProfile(); // Sostituisci con la tua logica per navigare alla pagina del profilo
            },
          ),
          const SizedBox(
              width: 8), // Spazio tra l'icona del profilo e il titolo
          const Text(
            "Serie Gormiti",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color:
                  AppColors.textColor, // Imposta il colore del testo su bianco
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: AppColors.textColor,
          ),
          onPressed: () {
            _navigateToSearch();
          },
        ),
      ],
    );
  }

  Widget _buildSeriesList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: seriesList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, index) {
        final int startIndex = index * 2;
        final int endIndex = startIndex + 1;

        return Row(
          children: [
            for (int i = startIndex;
                i < seriesList.length && i <= endIndex;
                i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToPeople(seriesList[i], context),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: SeriesWidget(
                      serieName: seriesList[i],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _navigateToPeople(String serieName, BuildContext context) {
    Get.toNamed('/Popoli', arguments: serieName);
  }

  void _navigateToSearch() {
    Get.toNamed('/SearchBar', arguments: "");
  }

  void _navigateToProfile() {
    Get.toNamed('/Profile', arguments: "");
  }
}
