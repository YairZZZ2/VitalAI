import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({Key? key}) : super(key: key);

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();

  String sexo = "Masculino";

  // Respuestas de Sí / No
  bool buenaSalud = true;
  bool cirugiaReciente = false;
  bool tatuajesRecientes = false;
  bool drogas = false;
  bool embarazadaOLactando = false;
  bool analgesicos = false;
  bool alcohol = false;
  bool sintomas = false;
  bool desayuno = true;

  // Evaluar si cumple con los requisitos
  void evaluarElegibilidad() {
    int? edad = int.tryParse(edadController.text);
    double? peso = double.tryParse(pesoController.text);

    // Validaciones básicas
    if (edad == null || peso == null) {
      _mostrarResultado(
          false, "Por favor, ingresa valores válidos para edad y peso.");
      return;
    }

    if (edad < 18 || edad > 65) {
      _mostrarResultado(false, "La edad debe estar entre 18 y 65 años.");
      return;
    }

    if (peso < 50) {
      _mostrarResultado(false, "El peso debe ser mínimo de 50 kg.");
      return;
    }

    // Condiciones generales
    if (!buenaSalud ||
        cirugiaReciente ||
        tatuajesRecientes ||
        drogas ||
        analgesicos ||
        alcohol ||
        sintomas ||
        !desayuno) {
      _mostrarResultado(false,
          "No cumples con uno o más requisitos. Revisa tus respuestas y consulta con el personal médico.");
      return;
    }

    // Condición específica para mujeres
    if (sexo == "Femenino" && embarazadaOLactando) {
      _mostrarResultado(false,
          "No puedes donar si estás embarazada o en periodo de lactancia.");
      return;
    }

    // Si pasa todo
    _mostrarResultado(true,
        "✅ Apto para donar sangre.\n\nGracias por tu disposición y compromiso con la vida.");
  }

  // Mostrar resultado en un AlertDialog
  void _mostrarResultado(bool apto, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(apto ? "Resultado: Apto" : "Resultado: No Apto"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario de Donación"),
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Datos del donante",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),

              const SizedBox(height: 15),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre completo",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: edadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Edad",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Peso (kg)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              const Text("Sexo:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Masculino"),
                      value: "Masculino",
                      groupValue: sexo,
                      onChanged: (value) {
                        setState(() => sexo = value!);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Femenino"),
                      value: "Femenino",
                      groupValue: sexo,
                      onChanged: (value) {
                        setState(() => sexo = value!);
                      },
                    ),
                  ),
                ],
              ),

              const Divider(height: 30, thickness: 1),

              const Text("Cuestionario de salud",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text("¿Tienes buena salud general?"),
                value: buenaSalud,
                onChanged: (v) => setState(() => buenaSalud = v),
              ),
              SwitchListTile(
                title: const Text("¿Tuviste cirugía en los últimos 6 meses?"),
                value: cirugiaReciente,
                onChanged: (v) => setState(() => cirugiaReciente = v),
              ),
              SwitchListTile(
                title: const Text(
                    "¿Te hiciste tatuajes, perforaciones o acupuntura en los últimos 12 meses?"),
                value: tatuajesRecientes,
                onChanged: (v) => setState(() => tatuajesRecientes = v),
              ),
              SwitchListTile(
                title: const Text("¿Usas drogas intravenosas o inhaladas?"),
                value: drogas,
                onChanged: (v) => setState(() => drogas = v),
              ),

              // 🔹 Esta pregunta solo aparece si el sexo es femenino
              if (sexo == "Femenino")
                SwitchListTile(
                  title: const Text("¿Estás embarazada o lactando?"),
                  value: embarazadaOLactando,
                  onChanged: (v) => setState(() => embarazadaOLactando = v),
                ),

              SwitchListTile(
                title: const Text("¿Tomaste analgésicos en los últimos 5 días?"),
                value: analgesicos,
                onChanged: (v) => setState(() => analgesicos = v),
              ),
              SwitchListTile(
                title: const Text("¿Bebiste alcohol en las últimas 48 horas?"),
                value: alcohol,
                onChanged: (v) => setState(() => alcohol = v),
              ),
              SwitchListTile(
                title: const Text("¿Tienes tos, resfriado o dolor actualmente?"),
                value: sintomas,
                onChanged: (v) => setState(() => sintomas = v),
              ),
              SwitchListTile(
                title: const Text("¿Desayunaste ligero hoy?"),
                value: desayuno,
                onChanged: (v) => setState(() => desayuno = v),
              ),

              const SizedBox(height: 25),

              Center(
                child: ElevatedButton(
                  onPressed: evaluarElegibilidad,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Evaluar elegibilidad",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
