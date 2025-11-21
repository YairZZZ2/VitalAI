import 'package:flutter/material.dart';

class EstresScreen extends StatelessWidget {
  const EstresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medir Estrés"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Nivel de Estrés",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Coloca tu dedo en el sensor (o conecta un dispositivo Bluetooth) para medir tu nivel de estrés.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            // Botón para iniciar la medición
            ElevatedButton(
              onPressed: () {
                // Aquí iría la lógica para iniciar la medición
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Iniciando medición de estrés...")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                "Iniciar Medición",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 40),

            // Resultado simulado
            const Text(
              "Resultado: -- %",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
