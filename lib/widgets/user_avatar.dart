import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {

  final double size; 
  final EdgeInsetsGeometry padding;

  const UserAvatar({
    Key? key,
    this.size = 30, 
    this.padding = const EdgeInsets.only(right: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding, 
      child: CircleAvatar(
        radius: size,
        backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/a-/AOh14GgnJxrP6RA2J53CeleEOUcsUv8FUNulr4FyhWUrDA=s288-p-rw-no'),
      )
    );
  }
}