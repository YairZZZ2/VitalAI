import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de donaciones"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // 🔍 Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar por nombre o apellido...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),

            const SizedBox(height: 15),

            // 📌 LISTA DESDE FIREBASE
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                        "Aún no hay donaciones registradas.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  // Filtrar por búsqueda
                  var docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final nombre = data['nombre']?.toString().toLowerCase() ?? "";
                    final apP = data['apellido_paterno']?.toString().toLowerCase() ?? "";
                    final apM = data['apellido_materno']?.toString().toLowerCase() ?? "";

                    return nombre.contains(searchQuery) ||
                        apP.contains(searchQuery) ||
                        apM.contains(searchQuery);
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No se encontraron coincidencias.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data =
                          docs[index].data() as Map<String, dynamic>;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),

                          // Nombre completo
                          title: Text(
                            "${data['nombre']} ${data['apellido_paterno']} ${data['apellido_materno']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          // Datos vitales
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text("❤️ Ritmo: ${data['ritmo_cardiaco']} BPM"),
                              Text("🫁 Oxígeno: ${data['oxigenacion']}%"),
                              Text("🩸 Presión: ${data['presion_diastolica']} mmHg"),
                              Text("🔥 Estrés: ${data['estres']}%"),
                              const SizedBox(height: 8),
                              Text(
                                "📅 Fecha: ${data['fecha']}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          // Ícono
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Icon(Icons.health_and_safety,
                                color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
