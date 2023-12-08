import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/sql_helper.dart';
import '../model/gormita.dart';
import '../utility/colors.dart';
import '../widgets/check_list_widget.dart';

class CheckList extends StatefulWidget {
  const CheckList({Key? key}) : super(key: key);

  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  List<String> popoliList = [];
  List<Gormita> gormitiList = [];
  late String serieName;
  List<bool> selectedPopoli = [];

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments != null && arguments is String) {
      serieName = arguments;
      _loadPopoliList(serieName);
      _loadGormitiList(serieName);
    } else {
      // Gestisci il caso in cui gli argomenti non siano validi.
    }
  }

  Future<void> _loadPopoliList(String serieName) async {
    final List<String> result = await SQLHelper.getPopoliListBySerie(serieName);
    setState(() {
      popoliList = result;
      // Inizializza la lista _selectedPopoli con valori falsi per ogni popolo.
      selectedPopoli = List.generate(result.length, (index) => false);
    });
  }

  Future<void> _reloadGormitiList(
      String serieName, List<String> selectedPopoliString) async {
    final List<Gormita> result = await SQLHelper.filterGormitiListBySerie(
        serieName, selectedPopoliString);
    setState(() {
      gormitiList = result;
    });
  }

  Future<void> _loadGormitiList(String serieName) async {
    final List<Gormita> result =
        await SQLHelper.getGormitiListBySerie(serieName);
    setState(() {
      gormitiList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Checklist for $serieName',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: AppColors.textColor,
        ),
      ), // Display the series name
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (gormitiList.length / 2).ceil(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, index) {
        final int startIndex = index * 5;
        final int endIndex = startIndex + 4;

        return Row(
          children: [
            for (int i = startIndex;
                i < gormitiList.length && i <= endIndex;
                i++)
              Expanded(
                child: CheckListCard(
                  name: gormitiList[i].name,
                  popolo: gormitiList[i].popolo,
                  serie: gormitiList[i].serie,
                  availability: gormitiList[i].availability,
                  isEdicola: gormitiList[i].isEdicola,
                  ownIt: gormitiList[i].ownIt,
                  id: gormitiList[i].id,
                  imagePath: gormitiList[i].image,
                  textColor: Colors.white,
                ),
              ),
          ],
        );
      },
    );
  }
}
