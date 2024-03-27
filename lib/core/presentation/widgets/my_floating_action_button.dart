import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {

  final VoidCallback onPressed;
  const MyFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 4,
      onPressed: onPressed,
      child: const Icon(Icons.shuffle, color: Colors.white,),
    );
  }
}