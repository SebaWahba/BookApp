import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
///full width secondary sign in button so wrap it in a width constrained parent (padding/SizedBox)
class SecondaryButton extends StatelessWidget{
  static const buttonColor = Color(0xFFFAF9FD);
  static const textColor = Color (0xFF54408C);
  final VoidCallback onPressed;
  const SecondaryButton({required this.onPressed , super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox (
        width: double.infinity , child : Material ( color : Colors.transparent , borderRadius : BorderRadius.circular(12.0) , child : InkWell( onTap : onPressed ,borderRadius : BorderRadius.circular(12.0) ,
        child: Container( color : buttonColor , padding : EdgeInsets.symmetric(vertical : 16.0 ), alignment: Alignment.center , child : Text( 'Sign in' , style: GoogleFonts.openSans( color : textColor , fontWeight : FontWeight.w700  , fontSize : 16.0  , height: 1.5  )   )



        )))


    );

  }

}