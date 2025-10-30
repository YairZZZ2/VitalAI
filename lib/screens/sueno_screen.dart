import 'package:flutter/material.dart';

class SuenoScreen extends StatelessWidget {
  const SuenoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medición del Sueño"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Monitoreo del Sueño",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Aquí podrás registrar y analizar la calidad de tu sueño. "
              "La app se puede conectar con dispositivos externos "
              "para medir la duración y la calidad de tu descanso.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí iría la lógica de conexión con un dispositivo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Iniciando medición del sueño...")),
                );
              },
              icon: const Icon(Icons.bedtime),
              label: const Text("Iniciar medición"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí se podrían mostrar estadísticas o historial
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mostrando historial de sueño...")),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text("Ver historial"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
