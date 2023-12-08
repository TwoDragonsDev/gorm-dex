import 'package:flutter/material.dart';

import '../db/sql_helper.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  List totalList = [];

  Future<void> _loadTotalList() async {
    final result = await SQLHelper.getOwnSerieCount2Test();
    setState(() {
      totalList = result;
      print(totalList);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTotalList();
  }

  @override
  Widget build(BuildContext context) {
    print('This is a message printed to the console from ProfileWidget');
    return Container(
      padding: EdgeInsets.only(top: 16.0), // Aggiungi del margine sopra
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Imposta il numero di card per riga a 1
          childAspectRatio:
              5, // Imposta il rapporto larghezza/altezza desiderato
        ),
        itemCount: totalList.length,
        itemBuilder: (context, index) {
          var item = totalList[index];
          return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey), // Imposta il bordo grigio
            ),
            color: Colors.black, // Imposta lo sfondo nero
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: CircleAvatar(
                backgroundColor:
                    Colors.black, // Colore di sfondo del CircleAvatar
                radius:
                    35.0, // Aumenta il raggio per rendere il cerchio più grande
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2.0),
                  ),
                  child: Center(
                    child: Text(
                      '${item['count']} / ${item['totalCount']}',
                      style: TextStyle(
                        color: Colors.white, // Colore del testo bianco
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                '${item['serie']}',
                style: TextStyle(
                  color: Colors.white, // Colore del testo bianco
                  fontWeight: FontWeight.bold, // Testo in grassetto
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
