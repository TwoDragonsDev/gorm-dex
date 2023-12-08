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
    return Visibility(
      visible: serieName.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: Card(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color:
                    const Color.fromARGB(255, 43, 43, 43), // Colore del bordo
                width: 2.0, // Larghezza del bordo
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black, // Colore dell'ombra
                  offset: Offset(0, 4), // Offset (spostamento) dell'ombra
                  blurRadius: 4.0, // Raggio di sfocatura dell'ombra
                  spreadRadius: 1.0, // Raggio di diffusione dell'ombra
                )
              ],
            ),
            child: Row(children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(serieName,
                          style: TextStyle(
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
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
