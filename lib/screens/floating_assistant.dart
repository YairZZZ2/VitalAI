import 'package:flutter/material.dart';
import 'chatbot_screen.dart';

class FloatingAssistant extends StatelessWidget {
  // Controladores para tomar los datos del formulario
  final TextEditingController nombreController;
  final TextEditingController apellidosController;
  final TextEditingController edadController;
  final TextEditingController pesoController;
  final TextEditingController alturaController;
  final TextEditingController resultadoController;
  final TextEditingController motivoController;

  const FloatingAssistant({
    super.key,
    required this.nombreController,
    required this.apellidosController,
    required this.edadController,
    required this.pesoController,
    required this.alturaController,
    required this.resultadoController,
    required this.motivoController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          // Abrir ChatbotScreen pasando los datos del formulario
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotScreen(
                nombre: nombreController.text,
                apellidos: apellidosController.text,
                edad: int.tryParse(edadController.text) ?? 0,
                peso: double.tryParse(pesoController.text) ?? 0.0,
                altura: double.tryParse(alturaController.text) ?? 0.0,
                resultado: resultadoController.text,
                motivo: motivoController.text,
              ),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}