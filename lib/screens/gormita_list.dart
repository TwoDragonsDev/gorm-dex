import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/series/presentation/state/gormiti_provider.dart';
import '../model/gormita.dart';
import '../widgets/gormita_widget.dart';

class PopoliList extends ConsumerStatefulWidget {
  final String serieName;
  final int serieId;

  const PopoliList({
    super.key,
    required this.serieName,
    required this.serieId,
  });

  @override
  ConsumerState<PopoliList> createState() => _PopoliListState();
}

class _PopoliListState extends ConsumerState<PopoliList> {
  bool _showButtons = false;
  final List<String> _selectedPopoliString = [];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filterParams = FilterParams(
      serieName: widget.serieName,
      selectedPopoli: _selectedPopoliString,
    );
    final gormitiAsync = ref.watch(filteredGormitiProvider(filterParams));
    final popoliAsync = ref.watch(popoliBySerieProvider(widget.serieName));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.serieName,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () => context.push('/checklist?serieName=${Uri.encodeComponent(widget.serieName)}'),
              child: const Icon(Icons.wysiwyg),
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
      ),
      body: Stack(
        children: [
          popoliAsync.when(
            skipLoadingOnReload: true,
            data: (popoliList) => gormitiAsync.when(
              skipLoadingOnReload: true, // Prevents scroll reset
              data: (gormitiList) =>
                  _buildBody(context, popoliList, gormitiList),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Errore: $error',
                    style: TextStyle(color: colorScheme.error)),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Errore: $error',
                  style: TextStyle(color: colorScheme.error)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<String> popoliList,
      List<Gormita> gormitiList) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (_showButtons) ...[
          GridView.count(
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 6.0),
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(popoliList.length, (index) {
              return _buildFilterChip(context, popoliList[index]);
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
                  gormita: gormitiList[index],
                  textColor: colorScheme.onSurface,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String popolo) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedPopoliString.contains(popolo);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedPopoliString.add(popolo);
            } else {
              _selectedPopoliString.remove(popolo);
            }
          });
        },
        label: Text(popolo),
        selectedColor: colorScheme.secondaryContainer,
        checkmarkColor: colorScheme.onSecondaryContainer,
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: isSelected
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurface,
        ),
      ),
    );
  }
}
