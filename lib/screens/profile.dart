import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/sql_helper.dart';
import '../features/series/presentation/state/gormiti_provider.dart';
import '../widgets/profile_widget.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  Future<void> _shareJsonFile() async {
    Map<String, dynamic> jsonData = await SQLHelper.getAllGormitiListExport();
    String jsonString = jsonEncode(jsonData);

    // Crea un file temporaneo
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/gorm-export.json');
    await tempFile.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(tempFile.path)],
        text: 'Check out this JSON file',
      ),
    );
  }

  Future<void> _importJson(BuildContext context) async {
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
              debugPrint('Updated Gormita: $name in $serie');
            } else {
              debugPrint('Failed to update Gormita: $name in $serie');
            }
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Import completato!')),
            );
          }
        } catch (e) {
          debugPrint('Error reading JSON file: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore import: $e')),
            );
          }
        }
      } else {
        debugPrint('Selected file is not a JSON file');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Seleziona un file JSON')),
          );
        }
      }
    } else {
      debugPrint('File picking canceled');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final statsAsync = ref.watch(gormitiStatsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        title: Text(
          'Profilo',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.onSurface),
            onPressed: _shareJsonFile,
          ),
          IconButton(
            icon: Icon(Icons.storage, color: colorScheme.onSurface),
            onPressed: () => _importJson(context),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => ProfileWidget(stats: stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Errore: $error',
              style: TextStyle(color: colorScheme.error)),
        ),
      ),
    );
  }
}
