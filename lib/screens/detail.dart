import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/gormita.dart';
import '../widgets/detail_widget.dart';

class Detail extends ConsumerStatefulWidget {
  final Gormita gormita;

  const Detail({
    super.key,
    required this.gormita,
  });

  @override
  ConsumerState<Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<Detail> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerHighest,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: DetailWidget(gormita: widget.gormita),
    );
  }
}
