import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🔒 Contraseña exclusiva para encargados del monitor
  static const String _claveMonitor = "VitalAI2025";

  // 🔹 Función para pedir la clave antes de entrar al monitor
  Future<void> _pedirClaveYEntrar(BuildContext context) async {
    String? claveIngresada = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Acceso restringido"),
          content: TextField(
            obscureText: true,
            onChanged: (value) => claveIngresada = value,
            decoration: const InputDecoration(
              hintText: "Ingresa la contraseña de encargado",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, claveIngresada),
              child: const Text("Aceptar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result != null && result == _claveMonitor) {
      Navigator.pushNamed(context, '/monitor');
    } else if (result != null && result.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contraseña incorrecta ❌"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
            _buildCard(context, Icons.person, "Formulario", '/formulario'),
            _buildBluetoothTestCard(context),

            // 🔹 Nuevo botón para el monitor (con contraseña)
            _buildMonitorCard(context),

            // 🔹 Nuevo botón para historial de la BD
            _buildCard(context, Icons.history, "Historial", '/historial'),

            // 🔹 NUEVO BOTÓN para ver participantes
            _buildCard(context, Icons.group, "Participantes", '/participantes'),
          ],
        ),
      ),
    );
  }

  // 🔹 Card genérica
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

  // 🔹 Card para pruebas de Bluetooth
  Widget _buildBluetoothTestCard(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/bluetooth_test'),
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
                "Pruebas Bluetooth",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Card para Monitor (con contraseña)
  Widget _buildMonitorCard(BuildContext context) {
    return InkWell(
      onTap: () => _pedirClaveYEntrar(context),
      child: Card(
        color: const Color(0xFFEDE7F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monitor_heart_outlined,
                  size: 50, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              const Text(
                "Monitor de Donantes",
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
