import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignosScreen extends StatefulWidget {
  const SignosScreen({super.key});

  @override
  State<SignosScreen> createState() => _SignosScreenState();
}

class _SignosScreenState extends State<SignosScreen> {
  // Valores simulados
  int bpm = 75;
  int spo2 = 98;
  int sys = 120;
  int dia = 80;
  double temp = 36.7;

  Timer? timer;

  Future<void> guardarSignosEnFirebase() async {
  try {
      await FirebaseFirestore.instance.collection('donaciones').add({
        "ritmo_cardiaco": bpm,
        "oxigenacion": spo2,
        "presion_sistolica": sys,
        "presion_diastolica": dia,
        "temperatura": temp,
        "fecha": Timestamp.now(),
      });
      // Feedback opcional
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signos guardados en Firebase ✅")),
      );
    } catch (e) {
      print("Error al guardar signos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar en Firebase ❌")),
      );
    }
  }


  @override
  void initState() {
    super.initState();

    // Simulación de datos cada 2s
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        bpm = 70 + Random().nextInt(20);
        spo2 = 96 + Random().nextInt(4);
        sys = 110 + Random().nextInt(15);
        dia = 70 + Random().nextInt(15);
        temp = 36.5 + Random().nextDouble();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _card({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800)),
              Text(
                value,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoreo de Signos Vitales"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Valores en tiempo real",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Tarjetas
            Expanded(
              child: ListView(
                children: [
                  _card(
                    title: "Ritmo cardiaco",
                    value: "$bpm BPM",
                    icon: Icons.favorite,
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 15),
                  _card(
                    title: "Oxigenación",
                    value: "$spo2%",
                    icon: Icons.bubble_chart,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 15),
                  _card(
                    title: "Presión arterial",
                    value: "$sys / $dia mmHg",
                    icon: Icons.bloodtype,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 15),
                  _card(
                    title: "Temperatura",
                    value: "${temp.toStringAsFixed(1)}°C",
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Botón guardar en Firebase
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  guardarSignosEnFirebase(); // <-- aquí llamas al método que guarda
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Guardar en Firebase",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
