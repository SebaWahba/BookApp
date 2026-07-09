import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkipButton extends StatelessWidget {
 static const textColor = Color(0xFF54408C);
 final VoidCallback onPressed;
 final String text = 'Skip';

const SkipButton({required this.onPressed , super.key});

@override
Widget build(BuildContext context){
  return GestureDetector ( onTap: onPressed , child : Text(text , style: GoogleFonts.roboto( color : textColor , fontWeight : FontWeight.w400 , fontSize : 14.0 , height : 1.4 , letterSpacing : 0.0 ,)));




}



}