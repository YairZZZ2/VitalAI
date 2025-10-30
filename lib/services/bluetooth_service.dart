import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  // Escanea dispositivos BLE cercanos
  Stream<List<ScanResult>> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    return FlutterBluePlus.scanResults;
  }

  // Detiene el escaneo
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Intenta conectar al dispositivo
  Future<void> connectToDevice(BluetoothDevice device) async {
  try {
    await device.disconnect();
  } catch (_) {}

  print("🔗 Intentando conectar a ${device.platformName}...");

  try {
    await device.connect(autoConnect: false);
    print("✅ Conexión establecida con ${device.platformName}");

    final state = await device.connectionState.first;
    if (state == BluetoothConnectionState.connected) {
      print("🟢 Confirmado: el dispositivo está conectado.");
    } else {
      print("⚠️ No se pudo establecer la conexión.");
    }

    await device.disconnect();
    print("🔌 Dispositivo desconectado correctamente.");
  } catch (e) {
    print("❌ Error al conectar: $e");
  }
}
}
