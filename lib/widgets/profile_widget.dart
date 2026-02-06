import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final List<dynamic> stats;

  const ProfileWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          var item = stats[index];
          return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: colorScheme.outline),
            ),
            color: colorScheme.surfaceContainerHighest,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: CircleAvatar(
                backgroundColor: colorScheme.surface,
                radius: 35.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outline, width: 2.0),
                  ),
                  child: Center(
                    child: Text(
                      '${item['count']} / ${item['totalCount']}',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                '${item['serie']}',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
