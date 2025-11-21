import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<ScanResult> dispositivos = [];

  @override
  void initState() {
    super.initState();
    iniciarEscaneo();
  }

  void iniciarEscaneo() async {
    dispositivos.clear();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() => dispositivos = results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear dispositivos")),
      body: ListView.builder(
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          final device = dispositivos[index].device;

          return ListTile(
            title: Text(device.name.isNotEmpty ? device.name : "Sin nombre"),
            subtitle: Text(device.id.id),
            onTap: () async {
              await device.connect();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceScreen(device: device),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conectado a ${device.name}")),
      body: Center(child: Text("Conectado correctamente")),
    );
  }
}
