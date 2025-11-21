import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;


class RitmoScreen extends StatefulWidget {
  const RitmoScreen({super.key});

  @override
  State<RitmoScreen> createState() => _RitmoScreenState();
}

class _RitmoScreenState extends State<RitmoScreen> {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _hrNotifyChar;
  StreamSubscription<List<int>>? _hrSub;

  int heartRate = 0;
  bool isScanning = false;
  bool isConnected = false;

  @override
  void dispose() {
    _hrSub?.cancel();
    _device?.disconnect();
    super.dispose();
  }

  // ---------------- PERMISOS ----------------
  Future<bool> requestPermissions() async {
    bool scan = await Permission.bluetoothScan.isGranted;
    bool connect = await Permission.bluetoothConnect.isGranted;
    bool location = await Permission.locationWhenInUse.isGranted;

    if (scan && connect && location) {
      return true;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses[Permission.bluetoothScan]!.isGranted &&
           statuses[Permission.bluetoothConnect]!.isGranted &&
           statuses[Permission.locationWhenInUse]!.isGranted;
  }

  // ---------------- ESCANEAR ----------------

  Future<void> startScan() async {
  bool ok = await requestPermissions();

  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Permisos Bluetooth no concedidos")),
    );
    return;
  }

  // 🔵 Verificar si la ubicación del sistema está activada
  loc.Location location = loc.Location();
  bool serviceEnabled = await location.serviceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Activa la ubicación para usar Bluetooth")),
      );
      return;
    }
  }

  setState(() => isScanning = true);

  try {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        final name = r.device.platformName.toLowerCase();

        if (name.contains("mi") ||
            name.contains("xiaomi") ||
            name.contains("band") ||
            name.contains("miband")) {

          await FlutterBluePlus.stopScan();
          setState(() => isScanning = false);

          _device = r.device;

          await connectToDevice();
          break;
        }
      }
    });
  } catch (e) {
    debugPrint("❌ Error al escanear: $e");
    setState(() => isScanning = false);
  }
}


  // ---------------- CONECTAR ----------------
  Future<void> connectToDevice() async {
    if (_device == null) return;

    try {
      await _device!.connect();
      setState(() => isConnected = true);

      await discoverServices();
    } catch (e) {
      debugPrint("❌ Error al conectar: $e");
    }
  }

  // ---------------- SERVICIOS ----------------
  Future<void> discoverServices() async {
    if (_device == null) return;

    final services = await _device!.discoverServices();

    for (var s in services) {
      for (var c in s.characteristics) {
        if (c.uuid.toString().contains("2a37")) {
          _hrNotifyChar = c;
        }
      }
    }

    if (_hrNotifyChar != null) {
      debugPrint("✅ Característica HR encontrada: ${_hrNotifyChar!.uuid}");
      await listenToHeartRate();
    } else {
      debugPrint("⚠ No se encontró la característica de ritmo cardíaco.");
    }
  }

  // ---------------- LEER BPM ----------------
  Future<void> listenToHeartRate() async {
    if (_hrNotifyChar == null) return;

    await _hrNotifyChar!.setNotifyValue(true);

    _hrSub = _hrNotifyChar!.lastValueStream.listen((value) {
      if (value.isNotEmpty && value.length > 1) {
        int bpm = value[1];
        setState(() => heartRate = bpm);
      }
    });

    debugPrint("🩺 Escuchando ritmo cardíaco...");
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ritmo Cardíaco"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$heartRate BPM",
              style: const TextStyle(
                  fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            isScanning
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: startScan,
                    child: const Text("Conectar y medir"),
                  ),

            if (isConnected)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Conectado ✔",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
