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
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController tratamientoController = TextEditingController();
  final TextEditingController oncologiaController = TextEditingController();

  String sexo = "Masculino";

  // Respuestas de Sí / No
  bool covid19 = false;
  bool tMedico = false;
  bool hepatitis = false;
  bool hemofilia = false;
  bool sida = false;
  bool oncologia = false;
  bool carcinoma = false;
  bool tatuajesRecientes = false;
  bool piercingsRecientes = false;
  bool relaciones = false;
  bool drogas = false;
  bool alcohol = false;  
  bool embarazadaOLactando = false;
  bool desayuno = true;

  // Evaluar si cumple con los requisitos
  void evaluarElegibilidad() {
    int? edad = int.tryParse(edadController.text);
    double? peso = double.tryParse(pesoController.text);
    double? altura = double.tryParse(alturaController.text);

    // VALIDACIONES BÁSICAS
    if (edad == null || peso == null || altura == null) {
      _mostrarResultado(
        false,
        "⚠️ Por favor, ingresa valores válidos para edad, peso y altura."
      );
      return;
    }

    if (edad < 18 || edad > 65) {
      _mostrarResultado(
        false,
        "🚫 Lo sentimos, pero la edad debe estar entre 18 y 65 años para poder donar sangre."
      );
      return;
    }

    if (peso < 50 || peso > 100) {
      _mostrarResultado(
        false,
        "⚖️ Tu peso debe estar entre 50 y 100 kg para cumplir con los requisitos de donación."
      );
      return;
    }

    if (altura < 1.50) {
      _mostrarResultado(
        false,
        "📏 Debes medir al menos 1.50 metros para ser apto/a para la donación."
      );
      return;
    }

    // Condiciones generales
    if (covid19 ||
        hepatitis ||
        hemofilia ||
        sida ||
        carcinoma ||
        tatuajesRecientes ||
        piercingsRecientes ||
        relaciones ||
        drogas ||
        alcohol ||
        !desayuno) {
      _mostrarResultado(false,
           "🚫 Lo sentimos mucho, pero usted no es apto/a para donar sangre debido a sus respuestas en el cuestionario.");
      return;
    }

    if (sexo == "Femenino" && embarazadaOLactando) {
      _mostrarResultado(false,
          "🤰 Lo sentimos, pero no puedes donar si estás embarazada o en periodo de lactancia.");
      return;
    }

    _mostrarResultado(true,
         "🎉 ¡Felicidades, eres apto/a para donar sangre! 🩸\n\n"
          "En seguida colocaremos una banda en tu brazo para monitorear tus signos vitales mientras realizamos el proceso de donación. "
          "🙏 Gracias por tu noble gesto, estás ayudando a salvar vidas.");
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
              TextFormField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Altura (mts)",
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

              // 🔹 Esta pregunta solo aparece si el sexo es femenino
              if (sexo == "Femenino")
                SwitchListTile(
                  title: const Text("¿Estás embarazada o lactando?"),
                  value: embarazadaOLactando,
                  onChanged: (v) => setState(() => embarazadaOLactando = v),
                ),
              SwitchListTile(
                title: const Text("Has sido diagnosticado con COVID-19 en los últimos 28 días?"),
                value: covid19, 
                onChanged: (v) => setState(() => covid19 = v),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text("¿Estas en tratamiento médico o tomas alguna medicación?"),
                    value: tMedico,
                    onChanged: (v) {
                      setState(() {
                        tMedico = v;
                        if (!tMedico) tratamientoController.clear();
                      });
                    },
                  ),

                  // 👇 Si la respuesta es Sí, se muestra la nueva pregunta
                  if (tMedico) ...[
                    const SizedBox(height: 10),
                    const Text(
                      "¿Qué tipo de tratamiento o medicina tomas?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: tratamientoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Describe el tratamiento...",
                      ),
                    ),
                  ],
                ],
              ),
              SwitchListTile(
                title: const Text("¿Has tenido Hepatitis tipo C o B alguna vez o recientemente?"),
                value: hepatitis, 
                onChanged: (v) => setState(() => hepatitis = v),
                ),
                 SwitchListTile(
                title: const Text("¿Has sido diagnosticado de hemofilia?"),
                value: hemofilia, 
                onChanged: (v) => setState(() => hemofilia = v),
                ),
                 SwitchListTile(
                title: const Text("¿Eres portador/a de anticuerpos frente al VIH o enfermo/a de sida?"),
                value: sida, 
                onChanged: (v) => setState(() => sida = v),
                ),


                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text("¿Has padecido de algun proceso oncológico a lo largo de tu vida?"),
                    value: oncologia,
                    onChanged: (v) {
                      setState(() {
                        oncologia = v;
                        if (!oncologia) oncologiaController.clear();
                      });
                    },
                  ),

                  // 👇 Si la respuesta es Sí, se muestra la nueva pregunta
                  if (oncologia) ...[
                    SwitchListTile(
                    title: const Text("El cancer que tuviste, ¿fue un carcinoma in situ de cuello de útero o un carcinoma localizado de piel (basobascular y escamoso)?, ¿Ya te han dado de alta?"),
                      value: carcinoma, 
                      onChanged: (v) => setState(() => carcinoma = v),
                     ),
                  ],
                ],
              ),



              SwitchListTile(
                title: const Text("¿Te hiciste tatuajes en los últimos 4 meses?"),
                value: tatuajesRecientes,
                onChanged: (v) => setState(() => tatuajesRecientes = v),
              ),
              SwitchListTile(
                title: const Text("¿Te has puesto piercing o dilatador en los últimos 4 meses?"),
                value: piercingsRecientes,
                onChanged: (v) => setState(() => piercingsRecientes = v),
              ),


              SwitchListTile(
                title: const Text("¿Haz mantenido tú o tu pareja relaciones sexuales con personas (POSITIVAS EN VIH) de alto riesgo?"),
                value: relaciones,
                onChanged: (v) => setState(() => relaciones = v),
              ),


                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text("¿Utilizas alguna droga, anabolizantes o esteroides?"),
                    value: drogas,
                    onChanged: (v) {
                      setState(() {
                        drogas = v;
                        if (!drogas) tratamientoController.clear();
                      });
                    },
                  ),

                  // 👇 Si la respuesta es Sí, se muestra la nueva pregunta
                  if (drogas) ...[
                    const SizedBox(height: 10),
                    const Text(
                      "¿Cuál de estos usas?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: tratamientoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Coloca su nombre...",
                      ),
                    ),
                  ],
                ],
              ),

              SwitchListTile(
                title: const Text("¿Bebiste alcohol/mezcal en las últimas 48 horas?"),
                value: alcohol,
                onChanged: (v) => setState(() => alcohol = v),
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
