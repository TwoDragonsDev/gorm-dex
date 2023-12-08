import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gorm_wiki/utility/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../db/sql_helper.dart';
import '../widgets/profile_widget.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _shareJsonFile() async {
    Map<String, dynamic> jsonData = await SQLHelper.getAllGormitiListExport();
    String jsonString = jsonEncode(jsonData);

    // Crea un file temporaneo
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/gorm-export.json');
    await tempFile.writeAsString(jsonString);

    await Share.shareFiles([tempFile.path], text: 'Check out this JSON file');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: ProfileWidget(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      iconTheme: IconThemeData(
        color: AppColors.textColor,
      ),
      title: const Text(
        'Profilo',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: AppColors.textColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: AppColors.textColor),
          onPressed: () {
            _shareJsonFile();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.storage,
            color: AppColors.textColor,
          ), // Aggiungi l'icona delle impostazioni qui
          onPressed: () {
            _importJson();
          },
        ),
      ],
    );
  }

  void _importJson() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.single.name;

      if (fileName.endsWith('.json')) {
        try {
          String fileContent =
              await File(result.files.single.path!).readAsString();
          List<dynamic> jsonData = json.decode(fileContent)['data'];

          for (var item in jsonData) {
            String serie = item['serie'];
            String name = item['name'];
            bool ownIt = item['own_it'] == 1;

            bool updated = await SQLHelper.updateGormita(serie, name, ownIt);
            if (updated) {
              print('Updated Gormita: $name in $serie');
            } else {
              print('Failed to update Gormita: $name in $serie');
            }
          }
        } catch (e) {
          print('Error reading JSON file: $e');
        }
      } else {
        print('Selected file is not a JSON file');
      }
    } else {
      // User canceled the file picking
      print('File picking canceled');
    }
  }
}
