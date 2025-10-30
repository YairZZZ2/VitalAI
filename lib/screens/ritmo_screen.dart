import 'package:flutter/material.dart';

class RitmoScreen extends StatelessWidget {
  const RitmoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medir Ritmo Cardíaco'),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              'Ritmo Cardíaco',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coloca tu dedo sobre el sensor o conecta un dispositivo Bluetooth\npara medir tu frecuencia cardiaca.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Aquí después se integrará la lógica de medición con Bluetooth
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Midiendo ritmo cardiaco..."),
                  ),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text(
                "Medir ahora",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
