import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonantesAptosNoAptosScreen extends StatelessWidget {
  const DonantesAptosNoAptosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donacionesRef =
        FirebaseFirestore.instance.collection('donaciones');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donantes Aptos y No Aptos"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donacionesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final aptos = docs.where((d) => d['esApto'] == true).toList();
          final noAptos = docs.where((d) => d['esApto'] == false).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================== TABLA APTOS ==================
                const Text(
                  "Donantes Aptos",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                DataTable(
                  columns: const [
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Apellidos")),
                    DataColumn(label: Text("Edad")),
                    DataColumn(label: Text("Peso")),
                    DataColumn(label: Text("Altura")),
                    DataColumn(label: Text("Fecha")),
                  ],
                  rows: aptos.map((d) {
                    return DataRow(
                      cells: [
                        DataCell(Text(d['nombre'] ?? '')),
                        DataCell(Text(d['apellidos'] ?? '')),
                        DataCell(Text("${d['edad']}")),
                        DataCell(Text("${d['peso']} kg")),
                        DataCell(Text("${d['altura']} m")),
                        DataCell(Text(d['fecha'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                // ================== TABLA NO APTOS ==================
                const Text(
                  "Donantes No Aptos",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 12),

                DataTable(
                  columns: const [
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Apellidos")),
                    DataColumn(label: Text("Edad")),
                    DataColumn(label: Text("Peso")),
                    DataColumn(label: Text("Altura")),
                    DataColumn(label: Text("Motivo")),
                    DataColumn(label: Text("Fecha")),
                  ],
                  rows: noAptos.map((d) {
                    return DataRow(
                      cells: [
                        DataCell(Text(d['nombre'] ?? '')),
                        DataCell(Text(d['apellidos'] ?? '')),
                        DataCell(Text("${d['edad']}")),
                        DataCell(Text("${d['peso']} kg")),
                        DataCell(Text("${d['altura']} m")),
                        DataCell(Text(d['motivo'] ?? 'Sin motivo')),
                        DataCell(Text(d['fecha'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
