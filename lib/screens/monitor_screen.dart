import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Revisor'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 🔹 Escucha en tiempo real los datos de la colección "donaciones"
        stream: FirebaseFirestore.instance
            .collection('donaciones')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay registros de donantes todavía.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final donaciones = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: donaciones.length,
            itemBuilder: (context, index) {
              final doc = donaciones[index];
              final datos = doc.data() as Map<String, dynamic>;

              final nombre = datos['nombre'] ?? 'Desconocido';
              final presion = datos['presion'] ?? '-';
              final ritmo = datos['ritmo'] ?? '-';
              final oxigeno = datos['oxigeno'] ?? '-';
              final estres = datos['estres'] ?? '-';
              final fecha = (datos['fecha'] as Timestamp?)?.toDate();

              Color colorTarjeta = Colors.white;
              if (presion is num && presion > 140) {
                colorTarjeta = Colors.red.shade100;
              } else if (presion is num && presion < 90) {
                colorTarjeta = Colors.orange.shade100;
              }

              return Card(
                color: colorTarjeta,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.teal),
                  title: Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Presión arterial: $presion mmHg'),
                      Text('Ritmo cardíaco: $ritmo bpm'),
                      Text('Oxígeno: $oxigeno %'),
                      Text('Estrés: $estres %'),
                      if (fecha != null)
                        Text(
                          'Fecha: ${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.teal),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Detalles de $nombre'),
                          content: Text(
                            'Presión: $presion mmHg\n'
                            'Ritmo: $ritmo bpm\n'
                            'Oxígeno: $oxigeno %\n'
                            'Estrés: $estres %\n'
                            '${fecha != null ? 'Fecha: ${fecha.day}/${fecha.month}/${fecha.year}' : ''}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
