import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart'; // Asegúrate de tener este archivo creado

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VitalAI - Inicio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, Icons.favorite, "Presión Arterial", '/presion'),
            _buildCard(context, Icons.monitor_heart, "Ritmo Cardíaco", '/ritmo'),
            _buildCard(context, Icons.bedtime, "Sueño", '/sueno'),
            _buildCard(context, Icons.bloodtype, "Oxígeno", '/oxigeno'),
            _buildCard(context, Icons.sentiment_satisfied, "Estrés", '/estres'),
            _buildCard(context, Icons.person, "Formulario", '/formulario'),
            // 🔹 Nuevo botón de prueba Bluetooth
            _buildBluetoothTestCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Nueva función para el card de prueba de Bluetooth
  Widget _buildBluetoothTestCard(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          final bluetooth = BluetoothService();
            bluetooth.scanForDevices().listen((results) {
              for (var r in results) {
                print('📡 Dispositivo: ${r.device.platformName} (${r.device.remoteId})');
              }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Escaneando dispositivos Bluetooth...')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bluetooth, size: 50, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              const Text(
                "Probar Bluetooth",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
