import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/bluetooth_service.dart' as my_bt;

class BluetoothTestScreen extends StatefulWidget {
  const BluetoothTestScreen({super.key});

  @override
  State<BluetoothTestScreen> createState() => _BluetoothTestScreenState();
}

class _BluetoothTestScreenState extends State<BluetoothTestScreen> {
  final my_bt.BluetoothService _bluetoothService = my_bt.BluetoothService();
  List<ScanResult> devices = [];
  bool isScanning = false;

  void _startScan() {
    setState(() => isScanning = true);

    _bluetoothService.scanForDevices().listen((results) {
      setState(() => devices = results);
    }).onDone(() {
      setState(() => isScanning = false);
    });
  }

  void _stopScan() async {
    await _bluetoothService.stopScan();
    setState(() => isScanning = false);
  }

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prueba Bluetooth"),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.refresh),
            onPressed: isScanning ? _stopScan : _startScan,
          ),
        ],
      ),
      body: devices.isEmpty
          ? const Center(child: Text("No se han detectado dispositivos"))
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index].device;
                return ListTile(
                  title: Text(
                    device.platformName.isNotEmpty
                        ? device.platformName
                        : "Dispositivo sin nombre",
                  ),
                  subtitle: Text(device.remoteId.str),
                  trailing: ElevatedButton(
                    onPressed: () => _bluetoothService.connectToDevice(device),
                    child: const Text("Conectar"),
                  ),
                );
              },
            ),
    );
  }
}
