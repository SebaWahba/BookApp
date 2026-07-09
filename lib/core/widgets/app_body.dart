import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// use this for ur body text , style: AppBody.style and pass ur own text in different onboarding screens
class AppBody{
static const textColor = Color(0xFFA6A6A6);
static TextStyle get style => GoogleFonts.roboto( color :textColor , fontWeight : FontWeight.w400 , fontSize : 16.0 , height : 1.5 , letterSpacing : 0.0 , );



}