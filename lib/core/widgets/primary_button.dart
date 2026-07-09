import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
///full width pill button so wrap it in a width constrained parent (padding/SizedBox)
class PrimaryButton extends StatelessWidget{
 static const buttonColor = Color(0xFF54408C);
 static const textColor = Color (0xFFFFFFFF);
 final String text;
 final VoidCallback onPressed;
 /// added as 12.0 for the 48 px in all , override in case 56 px with 16.0
 final double verticalPadding;
 const PrimaryButton({required this.text , required this.onPressed , super.key , this.verticalPadding = 12.0});

 @override
  Widget build(BuildContext context) {
   return SizedBox (
  width: double.infinity , child : Material ( color : Colors.transparent , borderRadius : BorderRadius.circular(12.0) , child : InkWell( onTap : onPressed ,borderRadius : BorderRadius.circular(12.0) ,
       child: Container( color : buttonColor , padding : EdgeInsets.symmetric(vertical : verticalPadding ), alignment: Alignment.center , child : Text( text , style: GoogleFonts.openSans( color : textColor , fontWeight : FontWeight.w700  , fontSize : 16.0  , height: 1.5  )   )



   )))


   );

 }

}

