import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({Key? key, required this.onPress, required this.color})
      : super(key: key);

  final void Function() onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress,
      icon: Transform.rotate(
        angle: 5.5,
        alignment: Alignment.center,
        child: const Icon(
          Icons.send,
          size: 14,
          color: Colors.white,
        ),
      ),
      label: const Text(
        'Navigation',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: color,
          maximumSize: const Size(double.infinity, double.infinity),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
