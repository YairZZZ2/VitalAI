import 'package:flutter/material.dart';

class PresionScreen extends StatefulWidget {
  const PresionScreen({super.key});

  @override
  State<PresionScreen> createState() => _PresionScreenState();
}

class _PresionScreenState extends State<PresionScreen> {
  final TextEditingController sistolicaController = TextEditingController();
  final TextEditingController diastolicaController = TextEditingController();

  String resultado = "";

  void calcularPresion() {
    final int? sistolica = int.tryParse(sistolicaController.text);
    final int? diastolica = int.tryParse(diastolicaController.text);

    if (sistolica == null || diastolica == null) {
      setState(() {
        resultado = "⚠️ Ingresa valores válidos.";
      });
      return;
    }

    if (sistolica < 90 || diastolica < 60) {
      resultado = "Presión baja (Hipotensión)";
    } else if (sistolica <= 120 && diastolica <= 80) {
      resultado = "Presión normal ✅";
    } else if (sistolica <= 139 || diastolica <= 89) {
      resultado = "Prehipertensión ⚠️";
    } else if (sistolica <= 159 || diastolica <= 99) {
      resultado = "Hipertensión grado 1 ❗";
    } else {
      resultado = "Hipertensión grado 2 🚨";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medir Presión Arterial"),
        backgroundColor: Colors.pink.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Introduce tus valores de presión arterial:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: sistolicaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Sistólica (mmHg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.pink.shade50,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: diastolicaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Diastólica (mmHg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularPresion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Calcular",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                resultado,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
