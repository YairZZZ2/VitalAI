import 'package:flutter/material.dart';

class OxigenoScreen extends StatefulWidget {
  const OxigenoScreen({super.key});

  @override
  State<OxigenoScreen> createState() => _OxigenoScreenState();
}

class _OxigenoScreenState extends State<OxigenoScreen> {
  int? nivelOxigeno;

  void medirOxigeno() {
    setState(() {
      // Simulación de medición
      nivelOxigeno = 97 + (DateTime.now().second % 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medir Oxígeno'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.air, size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: 30),
              Text(
                nivelOxigeno == null
                    ? 'Presiona el botón para medir tu nivel de oxígeno'
                    : 'Tu nivel de oxígeno es: $nivelOxigeno%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: medirOxigeno,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ), // 👈 aquí estaba faltando la coma
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Medir Oxígeno',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
