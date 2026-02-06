import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/series/presentation/state/gormiti_provider.dart';
import '../widgets/series_widget.dart';

class SeriesList extends ConsumerWidget {
  const SeriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, color: colorScheme.onSurface),
              onPressed: () => context.push('/profile'),
            ),
            const SizedBox(width: 8),
            Text(
              "Serie Gormiti",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurface),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: seriesAsync.when(
          data: (seriesList) => _buildSeriesList(seriesList, context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Errore: $error', style: TextStyle(color: colorScheme.error)),
          ),
        ),
      ),
    );
  }

  Widget _buildSeriesList(List<String> seriesList, BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (seriesList.length / 2).ceil(),
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
                  onTap: () => context.push('/popoli?serieName=${Uri.encodeComponent(seriesList[i])}&serieId=$i'),
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
}
