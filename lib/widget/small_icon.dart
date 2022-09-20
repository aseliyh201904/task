
import 'package:flutter/material.dart';

class SmallIcon extends StatelessWidget {
  const SmallIcon({
    Key? key,
    required this.iconData
  }) : super(key: key);
 final IconData iconData ;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        width: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1
              )
            ]
        ),
        child: Icon(iconData,size: 20,));
  }
}
