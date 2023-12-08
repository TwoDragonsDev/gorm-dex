import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../model/gormita.dart';

class SQLHelper {
  static Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'gormiti.db');

    // Verifica se il database esiste già
    bool dbExists = await databaseExists(dbPath);

    if (!dbExists) {
      // Copia il database dalla directory 'assets' alla directory di database dell'applicazione
      ByteData data = await rootBundle.load("lib/assets/gormiti.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes);
    }

    return openDatabase(dbPath, version: 1);
  }

  // Get all serie name
  static Future<List<String>> getDistinctSeries() async {
    final Database database = await initializedDB();
    List<String> res = [];
    final List<Map<String, dynamic>> records = await database
        .rawQuery('SELECT DISTINCT serie FROM gormiti  ORDER BY year');

    for (var record in records) {
      res.add(('${record['serie']}'));
    }
    await database.close();

    return res;
  }

  // Get popoli by serie name
  static Future<List<String>> getPopoliListBySerie(String serieName) async {
    final Database database = await initializedDB();
    List<String> res = [];
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT DISTINCT popolo FROM gormiti WHERE serie = ?',
      [serieName],
    );

    for (var record in records) {
      res.add(('${record['popolo']}'));
    }
    await database.close();

    return res;
  }

  // Get gormiti  by serie name
  static Future<List<Gormita>> getGormitiListBySerie(String serieName) async {
    final Database database = await initializedDB();
    List<Gormita> res = [];
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM gormiti WHERE serie = ? ORDER BY popolo',
      [serieName],
    );

    for (var record in records) {
      final gormita = Gormita.fromMap(record);
      res.add(gormita);
    }

    await database.close();
    return res;
  }

  static Future<List<Gormita>> filterGormitiListBySerie(
      String serieName, List<String> selected) async {
    final Database database = await initializedDB();
    List<Gormita> res = [];
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM gormiti WHERE serie = ? AND popolo IN (${List.filled(selected.length, '?').join(', ')})',
      [serieName, ...selected],
    );

    for (var record in records) {
      final gormita = Gormita.fromMap(record);
      res.add(gormita);
    }

    await database.close();
    return res;
  }

  Future<bool> ownChangerGormita(int id, bool ownIt) async {
    try {
      final Database database = await initializedDB();
      await database.rawQuery(
        'UPDATE gormiti SET own_it = ? WHERE id = ?',
        [ownIt ? 1 : 0, id],
      );

      return true;
    } catch (e) {
      return false;
    }
  }

// Get all gormiti
  static Future<List<Gormita>> getAllGormitiList() async {
    final Database database = await initializedDB();
    List<Gormita> res = [];
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM gormiti ',
    );

    for (var record in records) {
      final gormita = Gormita.fromMap(record);
      res.add(gormita);
    }

    await database.close();
    return res;
  }

// Get a Gormita by ID
  static Future<Gormita> getGormitaById(int id) async {
    final Database database = await initializedDB();
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM gormiti WHERE id = ?',
      [id],
    );

    if (records.isNotEmpty) {
      final gormita = Gormita.fromMap(records[0]);
      await database.close();
      return gormita;
    } else {
      await database.close();
      throw Exception('Gormita with ID $id not found');
    }
  }

  // serie + ownit count
  static Future<List<Map<String, dynamic>>> getOwnSerieCount() async {
    final Database database = await initializedDB();
    List<Map<String, dynamic>> res = [];

    final List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT serie, COUNT(own_it) as ownCount FROM gormiti WHERE own_it = 1 GROUP BY serie ORDER BY year');

    for (var record in records) {
      String serie = record['serie'];
      int ownCount = record['ownCount'];

      res.add({"serie": serie, "count": ownCount});
    }

    await database.close();
    return res;
  }

  // serie + ownit count + total count of gormiti per serie (solo quelli con own_it a true)
  static Future<List<Map<String, dynamic>>> getOwnSerieCount2Test() async {
    final Database database = await initializedDB();
    List<Map<String, dynamic>> res = [];

    final List<Map<String, dynamic>> records = await database.rawQuery('''
    SELECT 
      serie, 
      COUNT(*) as totalCount, 
      (SELECT COUNT(*) FROM gormiti WHERE serie = main.serie and own_it = 1 ) as ownCount
    FROM gormiti as main 
    GROUP BY serie 
    ORDER BY year
  ''');

    for (var record in records) {
      String serie = record['serie'];
      int ownCount = record['ownCount'];
      int totalCount = record['totalCount'];

      res.add({"serie": serie, "count": ownCount, "totalCount": totalCount});
    }

    await database.close();
    return res;
  }

  static Future<Map<String, dynamic>> getAllGormitiListExport() async {
    final Database database = await initializedDB();
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT serie, name, own_it FROM gormiti WHERE own_it = 1',
    );

    await database.close();

    // Process records and create a Map structure
    Map<String, dynamic> resultMap = {
      'data': records, // Assuming you want to store records under 'data' key
    };

    return resultMap;
  }

  static Future<bool> updateGormita(
      String serie, String name, bool ownIt) async {
    try {
      final Database database = await initializedDB();
      final List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT id FROM gormiti WHERE serie = ? AND name = ?',
        [serie, name],
      );

      if (records.isNotEmpty) {
        final int gormitaId = records[0]['id'];
        await SQLHelper().ownChangerGormita(gormitaId, ownIt);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
