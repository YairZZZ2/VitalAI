import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonacionWizardScreen extends StatefulWidget {
  const DonacionWizardScreen({super.key});

  @override
  State<DonacionWizardScreen> createState() => _DonacionWizardScreenState();
}

class _DonacionWizardScreenState extends State<DonacionWizardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  // ---------- CONTROLLERS: DATOS PERSONALES ----------
  final TextEditingController apPaternoCtrl = TextEditingController();
  final TextEditingController apMaternoCtrl = TextEditingController();
  final TextEditingController nombresCtrl = TextEditingController();
  final TextEditingController edadCtrl = TextEditingController();
  final TextEditingController pesoCtrl = TextEditingController();
  final TextEditingController alturaCtrl = TextEditingController();
  String sexo = "Masculino";

  // ---------- CONTROLLERS / FLAGS: CLÍNICA ----------
  final TextEditingController drogasController = TextEditingController();
  final TextEditingController tratamientoController = TextEditingController();
  final TextEditingController oncologiaController = TextEditingController();
  final TextEditingController carcinomaController = TextEditingController();

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
  bool menstruando = false;
  bool embarazada = false;
  bool lactando = false;
  bool parir = false;
  bool carcinomaAlta = false;
  bool desayuno = true;           // true = sí desayunó
  bool donacionReciente = false;
  bool viajesRiesgo = false;
  bool enfermedadesGraves = false;
  bool transfusionReciente = false;
  bool anticoagulantes = false;
  bool teratogenicos = false;
  bool vacunasRecientes = false;
  bool estadoActual = true;       // true = se siente bien

  // Resultado y motivo
  String resultadoTexto = "";
  String motivoNoApto = "";

  // ---------- NAVEGACIÓN ----------
  void _nextPage() {
    if (_pageIndex < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if (_pageIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  // ---------- VALIDACIÓN / EVALUACIÓN ----------
  void evaluarElegibilidad() {
    int? edad = int.tryParse(edadCtrl.text);
    double? peso = double.tryParse(pesoCtrl.text);
    double? altura = double.tryParse(alturaCtrl.text);

    // Básicos
    if (edad == null || peso == null || altura == null) {
      motivoNoApto = "Datos incompletos o inválidos (edad, peso, altura)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (edad < 18 || edad > 65) {
      motivoNoApto = "Edad fuera del rango permitido (18-65 años)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (peso < 50 || peso > 100) {
      motivoNoApto = "Peso fuera del rango permitido (50-100 kg)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (altura < 1.50) {
      motivoNoApto = "Altura menor de la permitida (≥ 1.50 m)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }

    // Clínicos (motivos específicos, uno por uno)
    if (covid19) {
      motivoNoApto = "Diagnosticado con COVID-19 hace menos de 28 días";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (hepatitis || sida) {
      motivoNoApto = "Antecedente de Hepatitis B/C o VIH/SIDA";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (hemofilia) {
      motivoNoApto = "Antecedente de Hemofilia";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (carcinoma || oncologia) {
      motivoNoApto = "Antecedente de cáncer";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (anticoagulantes) {
      motivoNoApto = "Uso de medicamentos anticoagulantes";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (enfermedadesGraves) {
      motivoNoApto = "Antecedente de enfermedad grave (corazón, pulmones, etc.)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (transfusionReciente) {
      motivoNoApto = "Transfusión de sangre reciente";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (drogas) {
      motivoNoApto = "Consumo de drogas, anabolizantes o esteroides";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (alcohol) {
      motivoNoApto = "Consumo de alcohol en las últimas 48 horas";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (relaciones) {
      motivoNoApto = "Relaciones sexuales de alto riesgo";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (donacionReciente) {
      motivoNoApto = "Donación de sangre en los últimos 4 meses";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (viajesRiesgo) {
      motivoNoApto = "Viajes recientes a zonas de riesgo (Malaria, Zika, Chagas)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (teratogenicos) {
      motivoNoApto = "Uso reciente de medicamentos teratogénicos (Isotretinoína, Etretinato)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (vacunasRecientes) {
      motivoNoApto = "Vacunas de virus vivos atenuados en las últimas semanas";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (tatuajesRecientes) {
      motivoNoApto = "Tatuajes recientes (menos de 4 meses)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (piercingsRecientes) {
      motivoNoApto = "Piercing/dilatador reciente (menos de 4 meses)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (!desayuno) {
      motivoNoApto = "No desayunó adecuadamente";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (!estadoActual) {
      motivoNoApto = "No se encuentra en condiciones óptimas para donar";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }

    // Condiciones específicas para mujeres
    if (sexo == "Femenino" && embarazada) {
      motivoNoApto = "Embarazo actual";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (sexo == "Femenino" && lactando) {
      motivoNoApto = "Periodo de lactancia";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }
    if (sexo == "Femenino" && parir) {
      motivoNoApto = "Parto reciente (menos de 6 meses)";
      _mostrarResultadoDialog(false, motivoNoApto);
      setState(() => resultadoTexto = motivoNoApto);
      return;
    }

    // Si pasa todo:
    motivoNoApto = ""; // limpio porque es apto
    _mostrarResultadoDialog(true, "🎉 ¡Felicidades, eres apto/a para donar sangre!");
    setState(() => resultadoTexto = "Apto para donar.");
  }
  // ---------- FIRESTORE: GUARDAR DATOS ----------
  Future<void> guardarDatosEnFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('donaciones').add({
        "apellido_paterno": apPaternoCtrl.text.trim(),
        "apellido_materno": apMaternoCtrl.text.trim(),
        "nombre": nombresCtrl.text.trim(),
        "edad": int.tryParse(edadCtrl.text),
        "peso": double.tryParse(pesoCtrl.text),
        "altura": double.tryParse(alturaCtrl.text),
        "sexo": sexo,
        "fecha": Timestamp.now(),
        "resultado": resultadoTexto,   // "Apto para donar." o motivo
        "motivo": motivoNoApto,        // vacío si es apto; texto específico si no
      });
    } catch (e) {
      print("Error al guardar datos en Firestore: $e");
    }
  }

  void _mostrarResultadoDialog(bool apto, String mensaje) {
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

  // ---------- WIDGETS REUTILIZABLES ----------
  Widget _campoTexto(TextEditingController c, String label, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _seccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
    );
  }

  @override
  void dispose() {
    apPaternoCtrl.dispose();
    apMaternoCtrl.dispose();
    nombresCtrl.dispose();
    edadCtrl.dispose();
    pesoCtrl.dispose();
    alturaCtrl.dispose();
    tratamientoController.dispose();
    oncologiaController.dispose();
    super.dispose();
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario de Donación"),
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_pageIndex + 1) / 3,
            color: const Color(0xFF9C27B0),
            backgroundColor: Colors.purple.shade50,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _pageIndex = i),
              children: [
                // PÁGINA 1: DATOS PERSONALES
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _seccionTitulo("Datos personales"),
                      _campoTexto(apPaternoCtrl, "Apellido paterno"),
                      _campoTexto(apMaternoCtrl, "Apellido materno"),
                      _campoTexto(nombresCtrl, "Nombre(s)"),
                      Row(
                        children: [
                          Expanded(child: _campoTexto(edadCtrl, "Edad", keyboard: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(child: _campoTexto(pesoCtrl, "Peso (kg)", keyboard: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _campoTexto(alturaCtrl, "Altura (mts) (ej. 1.75)", keyboard: TextInputType.number),
                      const SizedBox(height: 8),
                      const Text("Sexo:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("M"),
                              value: "Masculino",
                              groupValue: sexo,
                              onChanged: (v) => setState(() => sexo = v!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("F"),
                              value: "Femenino",
                              groupValue: sexo,
                              onChanged: (v) => setState(() => sexo = v!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("O"),
                              value: "Otro",
                              groupValue: sexo,
                              onChanged: (v) => setState(() => sexo = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                            onPressed: () {
                              if (nombresCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Completa los campos para continuar.")));
                                return;
                              }
                              _nextPage();
                            },
                            child: const Text("Continuar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PÁGINA 2: DATOS CLÍNICOS / CUESTIONARIO
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _seccionTitulo("Cuestionario de salud"),
                            SwitchListTile(
                              title: const Text("¿Ha sido diagnosticado/a con Hepatitis B, Hepatitis C o VIH/SIDA?"),
                              value: hepatitis || sida,
                              onChanged: (v) => setState(() {
                                hepatitis = v;
                                sida = v;
                              }),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha sido diagnosticado/a con COVID-19 con síntomas en los últimos 28 días?"),
                              value: covid19,
                              onChanged: (v) => setState(() => covid19 = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha sido diagnosticado/a de Hemofilia o trastorno grave de coagulación?"),
                              value: hemofilia,
                              onChanged: (v) => setState(() => hemofilia = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Alguna vez ha sido diagnosticado/a con cáncer (excepto basocelular)?"),
                              value: oncologia,
                              onChanged: (v) => setState(() => oncologia = v),
                            ),
                            if (sexo == "Femenino")
                              SwitchListTile(
                                title: const Text("¿Está embarazada o cree que podría estarlo?"),
                                value: embarazada,
                                onChanged: (v) => setState(() => embarazada = v),
                              ),
                            if (sexo == "Femenino")
                              SwitchListTile(
                                title: const Text("¿Ha dado a luz en los últimos 6 meses?"),
                                value: parir,
                                onChanged: (v) => setState(() => parir = v),
                              ),
                            if (sexo == "Femenino")
                              SwitchListTile(
                                title: const Text("¿Se encuentra actualmente en período de lactancia?"),
                                value: lactando,
                                onChanged: (v) => setState(() => lactando = v),
                              ),
                            if (sexo == "Femenino")
                              SwitchListTile(
                                title: const Text("¿Se siente débil, mareada o con menstruación abundante?"),
                                value: menstruando,
                                onChanged: (v) => setState(() => menstruando = v),
                              ),
                            SwitchListTile(
                              title: const Text("¿Ha ingerido suficientes líquidos en las últimas 4 horas?"),
                              value: desayuno,
                              onChanged: (v) => setState(() => desayuno = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha donado sangre en los últimos 4 meses?"),
                              value: donacionReciente,
                              onChanged: (v) => setState(() => donacionReciente = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha viajado o vivido en zona de riesgo (Malaria, Zika, Chagas) en los últimos 4 meses?"),
                              value: viajesRiesgo,
                              onChanged: (v) => setState(() => viajesRiesgo = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Tiene o ha tenido Lupus, Esclerosis Múltiple, enfermedad grave del corazón o pulmones?"),
                              value: enfermedadesGraves,
                              onChanged: (v) => setState(() => enfermedadesGraves = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha recibido una transfusión de sangre en los últimos 4-6 meses?"),
                              value: transfusionReciente,
                              onChanged: (v) => setState(() => transfusionReciente = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Está tomando medicamentos que afectan la coagulación?"),
                              value: anticoagulantes,
                              onChanged: (v) => setState(() => anticoagulantes = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha tomado medicamentos para acné o psoriasis (Isotretinoína, Etretinato)?"),
                              value: teratogenicos,
                              onChanged: (v) => setState(() => teratogenicos = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Ha recibido vacunas de virus vivos atenuados en las últimas 4 semanas?"),
                              value: vacunasRecientes,
                              onChanged: (v) => setState(() => vacunasRecientes = v),
                            ),
                            SwitchListTile(
                              title: const Text("¿Se siente usted bien, descansado/a y capaz de completar la donación en este momento?"),
                              value: estadoActual,
                              onChanged: (v) => setState(() => estadoActual = v),
                            ),
                          ],
                        ),
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
                        title: const Text("¿Has mantenido tú o tu pareja relaciones sexuales con personas (POSITIVAS EN VIH) de alto riesgo?"),
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
                                if (!drogas) drogasController.clear();
                              });
                            },
                          ),
                          if (drogas) _campoTexto(tratamientoController, "¿Cuál de estos usas?"),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(onPressed: _previousPage, child: const Text("Atrás")),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                            onPressed: _nextPage,
                            child: const Text("Continuar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PÁGINA 3: RESULTADO / EVALUACIÓN
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _seccionTitulo("Resultado"),
                      const Text("Revisa tus respuestas y presiona Evaluar para obtener el resultado final.", style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nombre: ${apPaternoCtrl.text} ${apMaternoCtrl.text} ${nombresCtrl.text}"),
                              Text("Edad: ${edadCtrl.text}"),
                              Text("Peso: ${pesoCtrl.text} kg"),
                              Text("Altura: ${alturaCtrl.text} m"),
                              Text("Sexo: $sexo"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0), padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14)),
                          onPressed: () {
                            evaluarElegibilidad();
                            guardarDatosEnFirebase();
                          },
                          child: const Text("Evaluar elegibilidad", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (resultadoTexto.isNotEmpty)
                        Center(
                          child: Text(resultadoTexto, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(onPressed: _previousPage, child: const Text("Atrás")),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                '/signos',
                                arguments: {
                                  "nombre": nombresCtrl.text.trim(),
                                  "apellidos": "${apPaternoCtrl.text.trim()} ${apMaternoCtrl.text.trim()}",
                                  "edad": int.tryParse(edadCtrl.text) ?? 0,
                                  "altura": double.tryParse(alturaCtrl.text) ?? 0.0,
                                  "peso": double.tryParse(pesoCtrl.text) ?? 0.0,
                                  "resultado": (resultadoTexto.toLowerCase().contains("apto")) ? "APTO" : "NO APTO",
                                  "motivo": motivoNoApto,
                                },
                              );
                            },
                            child: const Text("Finalizar"),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
