import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeriesWidget extends StatelessWidget {
  final String serieName;

  const SeriesWidget({
    super.key,
    required this.serieName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Visibility(
      visible: serieName.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: Card(
          color: colorScheme.surfaceContainerHighest,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        serieName,
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
