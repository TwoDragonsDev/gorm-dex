import 'package:flutter/material.dart';

import '../model/gormita.dart';

class DetailWidget extends StatelessWidget {
  final Gormita gormita;

  const DetailWidget({
    super.key,
    required this.gormita,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: _buildGormitaCard(context, gormita),
    );
  }

  Widget _buildGormitaCard(BuildContext context, Gormita gormita) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: colorScheme.shadow,
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(context, gormita.name),
              const SizedBox(height: 18),
              _buildGormitiImage(context, gormita.image),
              _buildInfoSection(context, gormita),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGormitiImage(BuildContext context, String image) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(image),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Gormita gormita) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
              context, "Popolo", gormita.popolo, colorScheme.primary),
          _buildInfoItem(context, "Serie", gormita.serie, colorScheme.tertiary),
          _buildInfoItem(
            context,
            "Posseduto",
            gormita.ownIt ? "Sì" : "No",
            colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String? value, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
            ),
          ),
          Text(
            value ?? "N/A",
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
