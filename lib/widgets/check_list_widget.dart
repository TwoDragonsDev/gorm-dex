import 'package:flutter/material.dart';

import '../db/sql_helper.dart';

class CheckListCard extends StatefulWidget {
  final String name;
  final String popolo;
  final String serie;
  final String availability;
  final bool isEdicola;
  final String imagePath;
  final Color textColor;
  final bool ownIt;
  final int id;

  const CheckListCard({
    super.key,
    required this.name,
    required this.popolo,
    required this.serie,
    required this.availability,
    required this.isEdicola,
    required this.imagePath,
    required this.textColor,
    required this.ownIt,
    required this.id,
  });

  @override
  State<CheckListCard> createState() => _CheckListCardState();
}

class _CheckListCardState extends State<CheckListCard> {
  late bool _ownIt;

  @override
  void initState() {
    super.initState();
    _ownIt = widget.ownIt;
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
        children: [
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
        width: 2,
        color: _ownIt ? colorScheme.primary : colorScheme.error,
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () async {
        bool isOk = await SQLHelper().ownChangerGormita(widget.id, !_ownIt);
        if (isOk && mounted) {
          setState(() {
            _ownIt = !_ownIt;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            height: 5,
            color: colorScheme.surface,
          ),
          _buildGormitiImage(),
          _buildNameText(colorScheme),
        ],
      ),
    );
  }

  Widget _buildGormitiImage() {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            widget.imagePath,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }

  Widget _buildNameText(ColorScheme colorScheme) {
    return Center(
      child: SizedBox(
        height: 30.0,
        child: Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
