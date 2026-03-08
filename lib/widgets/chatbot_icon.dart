import 'package:flutter/material.dart';
import 'dart:math';

enum EstadoEmocional { feliz, neutral, preocupado }

class ChatbotIcon extends StatefulWidget {
  final EstadoEmocional estado;

  const ChatbotIcon({super.key, required this.estado});

  @override
  State<ChatbotIcon> createState() => _ChatbotIconState();
}

class _ChatbotIconState extends State<ChatbotIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animOjos;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _animOjos = Tween<double>(begin: 8, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _colorFondo() {
    switch (widget.estado) {
      case EstadoEmocional.feliz:
        return Colors.green;
      case EstadoEmocional.neutral:
        return Colors.yellow;
      case EstadoEmocional.preocupado:
        return Colors.red;
    }
  }

  String _emoticon() {
    switch (widget.estado) {
      case EstadoEmocional.feliz:
        return '😊';
      case EstadoEmocional.neutral:
        return '🫥';
      case EstadoEmocional.preocupado:
        return '😧';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _colorFondo(),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _animOjos,
        builder: (context, child) {
          return Text(
            _emoticon(),
            style: const TextStyle(fontSize: 32),
          );
        },
      ),
    );
  }
}