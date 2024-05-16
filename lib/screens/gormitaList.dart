import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gorm_wiki/utility/colors.dart';

import '../db/sql_helper.dart';
import '../model/gormita.dart';
import '../widgets/gormita_widget.dart';

class PopoliList extends StatefulWidget {
  const PopoliList({Key? key}) : super(key: key);

  @override
  _PopoliListState createState() => _PopoliListState();
}

class _PopoliListState extends State<PopoliList> {
  List<String> popoliList = [];
  RxList<Gormita> gormitiList = <Gormita>[].obs;
  late final String serieName;
  bool _showButtons = false;
  List<bool> _selectedPopoli = [];

  final List<String> _selectedPopoliString = [];

  @override
  void initState() {
    super.initState();
    serieName = Get.arguments as String;
    _loadPopoliList(serieName);
    _loadGormitiList(serieName);
  }

  Future<void> _loadPopoliList(String serieName) async {
    final List<String> result = await SQLHelper.getPopoliListBySerie(serieName);
    setState(() {
      popoliList = result;
      // Inizializza la lista _selectedPopoli con valori falsi per ogni popolo.
      _selectedPopoli = List.generate(result.length, (index) => false);
    });
  }

  Future<void> _reloadGormitiList(
      String serieName, List<String> selectedPopoliString) async {
    final List<Gormita> result = await SQLHelper.filterGormitiListBySerie(
        serieName, selectedPopoliString);
    setState(() {
      gormitiList.assignAll(result);
    });
  }

  Future<void> _loadGormitiList(String serieName) async {
    final List<Gormita> result =
        await SQLHelper.getGormitiListBySerie(serieName);
    setState(() {
      gormitiList.assignAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(context),
          body: Stack(
            children: [
              _buildBody(),
            ],
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      title: Center(
        child: Text(
          serieName,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: AppColors.textColor,
          ),
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.textColor),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              _navigateToPeople(serieName, context);
            },
            child: const Icon(
              Icons.wysiwyg, // Icona della tabella
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              setState(() {
                _showButtons = !_showButtons;
              });
            },
          ),
        ),
      ],
    );
  }

  void _navigateToPeople(String serieName, BuildContext context) {
    Get.toNamed('/CheckList', arguments: serieName);
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (_showButtons) ...[
          GridView.count(
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height /
                    6.0), // Altezza massima desiderata

            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(popoliList.length, (index) {
              return _buildButton(index);
            }),
          ),
          const SizedBox(height: 16.0),
        ],
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: gormitiList.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GormiCard(
                  name: gormitiList[index].name,
                  popolo: gormitiList[index].popolo,
                  serie: gormitiList[index].serie,
                  availability: gormitiList[index].availability,
                  isEdicola: gormitiList[index].isEdicola,
                  ownIt: gormitiList[index].ownIt,
                  id: gormitiList[index].id,
                  image: gormitiList[index].image,
                  textColor: Colors.white,
                  isFavorite: gormitiList[index].isFavorite,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int buttonIndex) {
          // Cambia lo stato selezionato del popolo.
          setState(() {
            _selectedPopoli[index] = !_selectedPopoli[index];
          });
          if (_selectedPopoli[index]) {
            _selectedPopoliString.add(popoliList[index]);
          } else {
            _selectedPopoliString.remove(popoliList[index]);
          }
          if (_selectedPopoliString.isNotEmpty) {
            _reloadGormitiList(serieName, _selectedPopoliString);
          }
          if (!_selectedPopoliString.isNotEmpty) {
            _loadGormitiList(serieName);
          }
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: const Color.fromARGB(255, 136, 137, 136),
        borderColor: const Color.fromARGB(255, 136, 137, 136), // Bordo grigio
        selectedColor: Colors.white, // Testo bianco quando selezionato
        fillColor: _selectedPopoli[index]
            ? const Color.fromARGB(255, 136, 137, 136)
            : Colors.transparent, // Sfondo grigio quando selezionato
        color: _selectedPopoli[index]
            ? Colors.white
            : Colors.black, // Testo bianco se selezionato, altrimenti nero
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: [_selectedPopoli[index]],
        children: [
          Text(
            popoliList[index],
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
