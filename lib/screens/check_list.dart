import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../db/sql_helper.dart';
import '../features/series/presentation/state/gormiti_provider.dart';
import '../model/gormita.dart';

class CheckList extends ConsumerStatefulWidget {
  final String? serieName;

  const CheckList({
    super.key,
    this.serieName,
  });

  @override
  ConsumerState<CheckList> createState() => _CheckListState();
}

class _CheckListState extends ConsumerState<CheckList> {
  late String _serieName;

  @override
  void initState() {
    super.initState();
    _serieName = widget.serieName ?? 'Serie';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gormitiAsync = ref.watch(gormitiBySerieProvider(_serieName));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Checklist $_serieName',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        scrolledUnderElevation: 0,
      ),
      body: gormitiAsync.when(
        skipLoadingOnReload: true, // Prevents scroll reset on update
        data: (gormitiList) => _buildGroupedGrid(gormitiList, colorScheme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Errore: $error',
              style: TextStyle(color: colorScheme.error)),
        ),
      ),
    );
  }

  Widget _buildGroupedGrid(List<Gormita> gormitiList, ColorScheme colorScheme) {
    if (gormitiList.isEmpty) {
      return Center(
        child: Text(
          'Nessun Gormita trovato.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final Map<String, List<Gormita>> grouped = groupBy(gormitiList, (g) => g.popolo);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              for (var entry in grouped.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(
                    entry.key.toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final gormita = entry.value[index];
                    return _CheckGridItem(
                      gormita: gormita,
                      colorScheme: colorScheme,
                      onToggle: () async {
                        await SQLHelper()
                            .ownChangerGormita(gormita.id, !gormita.ownIt);
                        ref.read(gormitiDatabaseUpdateProvider.notifier).increment();
                      },
                    );
                  },
                ),
              ],
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}

class _CheckGridItem extends StatelessWidget {
  final Gormita gormita;
  final ColorScheme colorScheme;
  final VoidCallback onToggle;

  const _CheckGridItem({
    required this.gormita,
    required this.colorScheme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gormita.ownIt ? Colors.green : colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: gormita.ownIt ? 3 : 1,
          ),
          color: gormita.ownIt ? Colors.green.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: gormita.ownIt
              ? Image.asset(
                  gormita.image,
                  fit: BoxFit.contain,
                )
              : ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      gormita.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
