import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class modified_text extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const modified_text(this.color,this.size,this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.breeSerif(
        color: color,
        fontSize: size
      ),
    );
  }
}
