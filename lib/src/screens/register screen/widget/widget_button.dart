import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetButton extends StatelessWidget {
  final String labelText;
  final void Function()? onPressed;
  final double? width;
  const WidgetButton({Key? key, required this.labelText, this.onPressed,this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4)
        ]),
        child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            onPressed: onPressed,
            child: Container(
              padding: width!=null ? const EdgeInsets.symmetric(vertical: 14) : const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              child: Text(
                labelText,
                style: GoogleFonts.lexendExa(fontSize: 16),
              ),
            )),
      ),
    );
  }
}
