import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/series/presentation/state/gormiti_provider.dart';
import '../model/gormita.dart';
import '../widgets/gormita_widget.dart';

class SearchBarScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchBarScreen({
    super.key,
    this.initialQuery,
  });

  @override
  ConsumerState<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends ConsumerState<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final query = _searchController.text;
    final gormitiAsync = ref.watch(searchGormitiProvider(query));

    _searchFocusNode.requestFocus();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Ricerca Gormiti",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: colorScheme.onSurface),
                hintText: 'Cerca...',
              ),
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
        ),
      ),
      body: gormitiAsync.when(
        skipLoadingOnReload: true, // Prevents scroll reset
        data: (gormitiList) => _buildBody(gormitiList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Errore: $error',
              style: TextStyle(color: colorScheme.error)),
        ),
      ),
    );
  }

  Widget _buildBody(List<Gormita> gormitiList) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: gormitiList.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GormiCard(
                  gormita: gormitiList[index],
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
