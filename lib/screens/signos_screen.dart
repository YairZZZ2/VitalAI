import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SignosScreen extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final int edad;
  final double altura;
  final double peso;
  final String resultado;
  final String motivo;

  const SignosScreen({
    super.key,
    required this.nombre,
    required this.apellidos,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.resultado,
    required this.motivo,
  });

  @override
  State<SignosScreen> createState() => _SignosScreenState();
}

class _SignosScreenState extends State<SignosScreen> {
  // 🔹 Valores simulados
  int bpm = 75;
  int spo2 = 98;
  int sys = 120;
  int dia = 80;
  double temp = 36.7;

  Timer? timer;

  // 🔹 Guardar en Firebase
  Future<void> guardarSignosEnFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('donaciones').add({
        "nombre": widget.nombre,
        "apellido_paterno": widget.apellidos,
        "apellido_materno": widget.apellidos,
        "edad": widget.edad,
        "altura": widget.altura,
        "peso": widget.peso,
        "resultado": widget.resultado,
        "motivo": widget.motivo,
        "ritmo_cardiaco": bpm,
        "oxigenacion": spo2,
        "presion_sistolica": sys,
        "presion_diastolica": dia,
        "temperatura": temp,
        "fecha": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resultados guardados en Firebase ✅")),
      );
    } catch (e) {
      print("Error al guardar signos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar en Firebase ❌")),
      );
    }
  }

  // 🔹 Generar PDF
  void imprimirResultadosPDF() async {
    final pdf = pw.Document();
    final fecha = DateTime.now();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "RESULTADOS FORMULARIO DONACIÓN SANGUÍNEA",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Nombre(s): ${widget.nombre}"),
            pw.Text("Apellidos: ${widget.apellidos}"),
            pw.Text("Edad: ${widget.edad}"),
            pw.Text("Altura: ${widget.altura} m"),
            pw.Text("Peso: ${widget.peso} kg"),
            pw.Text("Resultado: ${widget.resultado}"),
            if (widget.resultado != "APTO") pw.Text("Motivo: ${widget.motivo}"),
            pw.SizedBox(height: 20),
            pw.Text("Signos vitales:"),
            pw.Text("- Ritmo cardiaco: $bpm BPM"),
            pw.Text("- Oxigenación: $spo2%"),
            pw.Text("- Presión arterial: $sys/$dia mmHg"),
            pw.Text("- Temperatura: ${temp.toStringAsFixed(1)} °C"),
            pw.SizedBox(height: 20),
            pw.Text("FECHA: ${fecha.day}/${fecha.month}/${fecha.year}"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // 🔹 Ciclo de simulación
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        bpm = 70 + Random().nextInt(40);   // 70–109
        spo2 = 96 + Random().nextInt(4);   // 96–99
        sys = 110 + Random().nextInt(15);  // 110–124
        dia = 70 + Random().nextInt(15);   // 70–84
        temp = 36.5 + Random().nextDouble(); // 36.5–37.5
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 🔹 Widget para cada tarjeta
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 🔹 UI principal
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

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

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: guardarSignosEnFirebase,
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
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: imprimirResultadosPDF,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Imprimir PDF",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
