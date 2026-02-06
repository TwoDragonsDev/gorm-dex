import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/gormita.dart';
import '../../../../db/sql_helper.dart';

// Trigger to force refresh of providers when DB changes
class GormitiDatabaseUpdateNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final gormitiDatabaseUpdateProvider =
    NotifierProvider<GormitiDatabaseUpdateNotifier, int>(GormitiDatabaseUpdateNotifier.new);

final seriesListProvider = FutureProvider<List<String>>((ref) async {
  return await SQLHelper.getDistinctSeries();
});

final gormitiBySerieProvider =
    FutureProvider.family<List<Gormita>, String>((ref, serieName) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  return await SQLHelper.getGormitiListBySerie(serieName);
});

final popoliBySerieProvider =
    FutureProvider.family<List<String>, String>((ref, serieName) async {
  return await SQLHelper.getPopoliListBySerie(serieName);
});

final filteredGormitiProvider =
    FutureProvider.family<List<Gormita>, FilterParams>((ref, params) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  if (params.selectedPopoli.isEmpty) {
    return await SQLHelper.getGormitiListBySerie(params.serieName);
  }
  return await SQLHelper.filterGormitiListBySerie(
      params.serieName, params.selectedPopoli);
});

class FilterParams {
  final String serieName;
  final List<String> selectedPopoli;

  const FilterParams({
    required this.serieName,
    required this.selectedPopoli,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterParams &&
        other.serieName == serieName &&
        other.selectedPopoli.length == selectedPopoli.length &&
        other.selectedPopoli
            .every((element) => selectedPopoli.contains(element));
  }

  @override
  int get hashCode => serieName.hashCode ^ selectedPopoli.hashCode;
}

final allGormitiProvider = FutureProvider<List<Gormita>>((ref) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  return await SQLHelper.getAllGormitiList();
});

final searchGormitiProvider =
    FutureProvider.family<List<Gormita>, String>((ref, query) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  final allGormiti = await SQLHelper.getAllGormitiList();
  if (query.isEmpty) return allGormiti;
  return allGormiti
      .where((g) => g.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
});

final gormitaByIdProvider =
    FutureProvider.family<Gormita?, int>((ref, id) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  return await SQLHelper.getGormitaById(id);
});

final gormitiStatsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(gormitiDatabaseUpdateProvider); // Watch for updates
  return await SQLHelper.getOwnSerieCount2Test();
});
