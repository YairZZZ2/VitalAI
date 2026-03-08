import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String tipoUsuario = "";

  // 🔹 Obtener el rol del usuario desde Firestore
  Future<void> obtenerTipoUsuario() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    setState(() {
      tipoUsuario = doc['tipo'];
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerTipoUsuario();
  }

  // 🔹 Función para entrar al monitor
  Future<void> _entrarMonitor(BuildContext context) async {

    // 🔒 Verificar rol
    if (tipoUsuario != "revisor") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El rol actual no te permite ingresar a esta opción."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/monitor');
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

            // 🔹 Monitor (ahora verifica rol)
            _buildMonitorCard(context),

            _buildCard(context, Icons.history, "Historial", '/historial'),

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

  // 🔹 Card para Monitor
  Widget _buildMonitorCard(BuildContext context) {
    return InkWell(
      onTap: () => _entrarMonitor(context),
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