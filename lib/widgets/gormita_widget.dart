import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../db/sql_helper.dart';
import '../features/series/presentation/state/gormiti_provider.dart';
import '../model/gormita.dart';

class GormiCard extends ConsumerStatefulWidget {
  final Gormita gormita;
  final Color textColor;

  const GormiCard({
    super.key,
    required this.gormita,
    required this.textColor,
  });

  @override
  ConsumerState<GormiCard> createState() => _GormiCardState();
}

class _GormiCardState extends ConsumerState<GormiCard> {
  late bool _ownIt;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _ownIt = widget.gormita.ownIt;
    _isFavorite = widget.gormita.isFavorite;
  }

  @override
  void didUpdateWidget(covariant GormiCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gormita.ownIt != widget.gormita.ownIt) {
      _ownIt = widget.gormita.ownIt;
    }
    if (oldWidget.gormita.isFavorite != widget.gormita.isFavorite) {
      _isFavorite = widget.gormita.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest,
      shape: _buildCardShape(colorScheme),
      shadowColor: colorScheme.shadow,
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 18),
          Divider(
            height: 5,
            color: colorScheme.surface,
          ),
          _buildImage(colorScheme),
        ],
      ),
    );
  }

  ShapeBorder _buildCardShape(ColorScheme colorScheme) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        width: 3,
        color: colorScheme.outlineVariant,
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    context.push('/detail', extra: widget.gormita);
  }

  Widget _buildImage(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () => _navigateToDetail(context),
            child: _buildGormitiImage(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _navigateToDetail(context),
                child: _buildNameText(colorScheme),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPopoloText(colorScheme),
                  const SizedBox(width: 10),
                  _buildSerieText(colorScheme),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: Align(
            alignment: Alignment.topRight,
            child: _buildOwnCheck(colorScheme),
          ),
        ),
      ],
    );
  }

  Widget _buildGormitiImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          widget.gormita.image,
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  Widget _buildNameText(ColorScheme colorScheme) {
    return Text(
      widget.gormita.name,
      style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        color: widget.textColor,
      ),
    );
  }

  Widget _buildPopoloText(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.gormita.popolo,
        style: TextStyle(
          fontSize: 11,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSerieText(ColorScheme colorScheme) {
    return InkWell(
      onTap: () => context.push(
          '/popoli?serieName=${Uri.encodeComponent(widget.gormita.serie)}&serieId=0'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.secondaryContainer,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.gormita.serie,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildOwnCheck(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              context.push('/search?q=${Uri.encodeComponent(widget.gormita.name)}'),
          child: Icon(
            Icons.search,
            color: colorScheme.onSurface,
            size: 30.0,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                bool isOk =
                    await SQLHelper().ownChangerGormita(widget.gormita.id, !_ownIt);
                if (isOk && mounted) {
                  setState(() {
                    _ownIt = !_ownIt;
                  });
                  ref.read(gormitiDatabaseUpdateProvider.notifier).increment();
                }
              },
              child: Icon(
                _ownIt ? Icons.expand_circle_down_outlined : Icons.add_circle,
                color: _ownIt ? colorScheme.primary : colorScheme.outline,
                size: 35.0,
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool isOk =
                    await SQLHelper().favoriteGormita(widget.gormita.id, !_isFavorite);
                if (isOk && mounted) {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ref.read(gormitiDatabaseUpdateProvider.notifier).increment();
                }
              },
              child: Icon(
                _isFavorite ? Icons.star : Icons.star_border,
                color: _isFavorite ? Colors.amber : colorScheme.outline,
                size: 35.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
