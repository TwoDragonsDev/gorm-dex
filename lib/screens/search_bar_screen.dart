import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/sql_helper.dart';
import '../model/gormita.dart';
import '../widgets/gormita_widget.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  RxList<Gormita> gormitiList = <Gormita>[].obs;
  // String testing = Get.arguments
  late final String firstFilterName;
  final TextEditingController _searchController = TextEditingController();
  List<Gormita> filteredGormitiList = <Gormita>[].obs;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _loadGormitiList(); // Attendere il completamento di _loadGormitiList
    firstFilterName = Get.arguments as String;

    if (firstFilterName.isNotEmpty) {
      // Se firstFilterName non è vuoto, imposta il testo nella search bar
      _searchController.text = firstFilterName;
      await _loadGormitiList();
      filteredGormitiList.assignAll(gormitiList.where((gormita) {
        return gormita.name.toLowerCase().contains(firstFilterName);
      }).toList());
    } else {
      filteredGormitiList.assignAll(gormitiList);
    }
    _searchController.addListener(_filterGormiti);
  }

  Future<void> _loadGormitiList() async {
    List<Gormita> gormiti = await SQLHelper.getAllGormitiList();
    gormitiList.assignAll(gormiti.obs);
  }

  void _filterGormiti() async {
    var searchText = _searchController.text.toLowerCase();

    if (searchText.isEmpty && firstFilterName.isEmpty) {
      filteredGormitiList = gormitiList;
    } else {
      if (firstFilterName.isNotEmpty) {
        searchText = firstFilterName;
      }
      await _loadGormitiList();
      var filteredList = gormitiList.where((gormita) {
        return gormita.name.toLowerCase().contains(searchText);
      }).toList();

      setState(() {
        filteredGormitiList = filteredList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchFocusNode.requestFocus();

    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(context),
          body: _buildBody(),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Ricerca Gormiti",
        style: TextStyle(
          color: Colors.white, // Imposta il colore del testo della barra
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.white, // Imposta il colore del testo di ricerca
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: filteredGormitiList.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GormiCard(
                  name: filteredGormitiList[index].name,
                  popolo: filteredGormitiList[index].popolo,
                  serie: filteredGormitiList[index].serie,
                  availability: filteredGormitiList[index].availability,
                  isEdicola: filteredGormitiList[index].isEdicola,
                  ownIt: filteredGormitiList[index].ownIt,
                  id: filteredGormitiList[index].id,
                  image: filteredGormitiList[index].image,
                  textColor: Colors.white,
                  isFavorite: filteredGormitiList[index].isFavorite,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
