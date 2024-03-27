import 'package:flutter/material.dart';

enum PlayerButtonSize {
  small,
  big,
}

class PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final PlayerButtonSize size;

  const PlayerIconButton({
    super.key,
    this.icon = Icons.play_arrow,
    required this.onPressed,
    this.size = PlayerButtonSize.big,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: size == PlayerButtonSize.big ? 80 : 60,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              (size == PlayerButtonSize.big
                  ? Theme.of(context).primaryColor
                  : Colors.grey)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}