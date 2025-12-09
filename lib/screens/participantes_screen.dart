import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantesScreen extends StatelessWidget {
  const ParticipantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Participantes Donación"),
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donaciones').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay participantes registrados."));
          }

          final docs = snapshot.data!.docs;

          // Filtrar aptos y no aptos
          final aptos = docs.where((d) {
            final resultado = (d.data() as Map<String, dynamic>)['resultado']?.toString().toLowerCase() ?? '';
            return resultado.contains("apto");
          }).toList();

          final noAptos = docs.where((d) {
            final resultado = (d.data() as Map<String, dynamic>)['resultado']?.toString().toLowerCase() ?? '';
            // Si no contiene "apto", lo consideramos no apto (incluye motivos específicos)
            return resultado.isNotEmpty && !resultado.contains("apto");
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Aptos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                _tablaParticipantes(aptos),

                const SizedBox(height: 30),

                const Text("No Aptos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 10),
                _tablaParticipantes(noAptos),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tablaParticipantes(List<QueryDocumentSnapshot> participantes) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFEDE7F6)),
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Edad", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Resultado/Motivo", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...participantes.map((d) {
          final data = d.data() as Map<String, dynamic>;
          final nombre = "${data['nombre'] ?? ''} ${data['apellido_paterno'] ?? ''} ${data['apellido_materno'] ?? ''}";
          final edad = data['edad']?.toString() ?? '';
          final resultado = data['resultado']?.toString() ?? 'Sin dato';

          return TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8), child: Text(nombre)),
              Padding(padding: const EdgeInsets.all(8), child: Text(edad)),
              Padding(padding: const EdgeInsets.all(8), child: Text(resultado)),
            ],
          );
        }),
      ],
    );
  }
}