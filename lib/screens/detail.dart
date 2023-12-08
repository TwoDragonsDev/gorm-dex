import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/detailWidget.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late final int id;
  final RxBool isLoading = true.obs; // Create an observable boolean variable

  @override
  void initState() {
    super.initState();
    id = Get.arguments as int;
    // Simulate some asynchronous loading
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false; // Set isLoading to false when the data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: DetailWidget(id: id),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Colors.white), // Aggiungi l'icona della freccia indietro
        onPressed: () {
          Navigator.of(context)
              .pop(); // Torna indietro quando viene premuta la freccia indietro
        },
      ),
    );
  }
}
