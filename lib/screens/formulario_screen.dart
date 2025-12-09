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
  final TextEditingController alturaCtrl = TextEditingController(); // <- altura añadida
  String sexo = "Masculino";

  // ---------- CONTROLLERS / FLAGS: CLÍNICA (tu formulario original) ----------
// ---- Controladores separados ----
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
  bool desayuno = true;
  bool donacionReciente = false;
  bool viajesRiesgo = false;
  bool enfermedadesGraves = false;
  bool transfusionReciente = false;
  bool anticoagulantes = false;
  bool teratogenicos = false;
  bool vacunasRecientes = false;
  bool estadoActual = true;

  // Resultado (se muestra en la 3ra pantalla y también vía AlertDialog)
  String resultadoTexto = "";

  // ---------- NAVEGACIÓN ENTRE PÁGINAS ----------
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

    // Validaciones básicas
    if (edad == null || peso == null || altura == null) {
      _mostrarResultadoDialog(false, "⚠️ Por favor, ingresa valores válidos para edad, peso y altura.");
      setState(() => resultadoTexto = "Por favor completa edad, peso y altura correctamente.");
      return;
    }

    if (edad < 18 || edad > 65) {
      _mostrarResultadoDialog(false, "🚫 Lo sentimos, pero la edad debe estar entre 18 y 65 años para poder donar sangre.");
      setState(() => resultadoTexto = "No apto por edad.");
      return;
    }

    if (peso < 50 || peso > 100) {
      _mostrarResultadoDialog(false, "⚖️ Tu peso debe estar entre 50 y 100 kg para cumplir con los requisitos de donación.");
      setState(() => resultadoTexto = "No apto por peso.");
      return;
    }

    if (altura < 1.50) {
      _mostrarResultadoDialog(false, "📏 Debes medir al menos 1.50 metros para ser apto/a para la donación.");
      setState(() => resultadoTexto = "No apto por altura.");
      return;
    }

    // Condiciones de salud (si cualquiera es true -> NO APTO)
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
        !desayuno ||
        donacionReciente ||
        viajesRiesgo ||
        enfermedadesGraves ||
        transfusionReciente ||
        anticoagulantes ||
        teratogenicos ||
        vacunasRecientes ||
        parir ||
        lactando ||
        !estadoActual) {
      _mostrarResultadoDialog(false, "🚫 Lo sentimos mucho, pero usted no es apto/a para donar sangre debido a sus respuestas en el cuestionario.");
      setState(() => resultadoTexto = "No apto por cuestionario clínico.");
      return;
    }

    // Condición específica para mujeres
    if (sexo == "Femenino" && embarazada || lactando) {
      _mostrarResultadoDialog(false, "🤰 Lo sentimos, pero no puedes donar si estás embarazada o en periodo de lactancia.");
      setState(() => resultadoTexto = "No apta por embarazo / lactancia.");
      return;
    }

    if(sexo == "Femenino" && parir) {
      _mostrarResultadoDialog(false, "🤱🏼Se requiere un mínimo de 6 meses después del parto para asegurar su recuperación.");
      setState(() => resultadoTexto = "No apta por parto reciente.");
      return;
    }

    // Si pasa todas las validaciones:
    _mostrarResultadoDialog(true, "🎉 ¡Felicidades, eres apto/a para donar sangre! 🩸\n\nEn seguida colocaremos una banda en tu brazo para monitorear tus signos vitales mientras realizamos el proceso de donación. 🙏 Gracias por tu noble gesto.");
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
      });
      // opcional: feedback corto
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Datos guardados.")));
    } catch (e) {
      // imprime el error para debug
      print("Error al guardar datos en Firestore: $e");
      // opcional: puedes mostrar un SnackBar de error si quieres
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
    // dispose controllers
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
          // barra de progreso simple
          LinearProgressIndicator(value: (_pageIndex + 1) / 3, color: const Color(0xFF9C27B0), backgroundColor: Colors.purple.shade50),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // controlado por botones
              onPageChanged: (i) => setState(() => _pageIndex = i),
              children: [
                // ------------------ PÁGINA 1: DATOS PERSONALES ------------------
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
                      // ---- altura añadido explícitamente ----
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
                            onPressed: () {
                              // Reiniciar o navegar atrás si quieres
                              // aquí no hay página anterior
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                            onPressed: () {
                              // Opcional: validar campos personales mínimos antes de avanzar
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

                // ------------------ PÁGINA 2: DATOS CLÍNICOS / CUESTIONARIO ------------------
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------ PÁGINA 2: DATOS CLÍNICOS / CUESTIONARIO ------------------
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _seccionTitulo("Cuestionario de salud"),

                            // Ejemplo de integración de nuevas preguntas:
                            SwitchListTile(
                              title: const Text("¿Ha sido diagnosticado/a con Hepatitis B, Hepatitis C o VIH/SIDA?"),
                              value: hepatitis || sida, // puedes usar variables separadas si prefieres
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
                                value: parir, // crea una variable bool específica si quieres guardar
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
                              value: desayuno, // ya tienes esta variable, puedes renombrar si quieres
                              onChanged: (v) => setState(() => desayuno = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Ha donado sangre en los últimos 4 meses?"),
                              value: donacionReciente, // crea variable bool donacionReciente
                              onChanged: (v) => setState(() => donacionReciente = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Ha viajado o vivido en zona de riesgo (Malaria, Zika, Chagas) en los últimos 4 meses?"),
                              value: viajesRiesgo, // crea variable bool viajesRiesgo
                              onChanged: (v) => setState(() => viajesRiesgo = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Tiene o ha tenido Hemofilia, Lupus, Esclerosis Múltiple, enfermedad grave del corazón o pulmones?"),
                              value: enfermedadesGraves, // crea variable bool enfermedadesGraves
                              onChanged: (v) => setState(() => enfermedadesGraves = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Ha recibido una transfusión de sangre en los últimos 4-6 meses?"),
                              value: transfusionReciente, // crea variable bool transfusionReciente
                              onChanged: (v) => setState(() => transfusionReciente = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Está tomando medicamentos que afectan la coagulación?"),
                              value: anticoagulantes, // crea variable bool anticoagulantes
                              onChanged: (v) => setState(() => anticoagulantes = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Ha tomado medicamentos para acné o psoriasis (Isotretinoína, Etretinato)?"),
                              value: teratogenicos, // crea variable bool teratogenicos
                              onChanged: (v) => setState(() => teratogenicos = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Ha recibido vacunas de virus vivos atenuados en las últimas 4 semanas?"),
                              value: vacunasRecientes, // crea variable bool vacunasRecientes
                              onChanged: (v) => setState(() => vacunasRecientes = v),
                            ),

                            SwitchListTile(
                              title: const Text("¿Se siente usted bien, descansado/a y capaz de completar la donación en este momento?"),
                              value: estadoActual, // crea variable bool estadoActual
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
                            onPressed: () {
                              // puedes poner validaciones intermedias si quieres
                              _nextPage();
                            },
                            child: const Text("Continuar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ------------------ PÁGINA 3: RESULTADO / EVALUACIÓN ------------------
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _seccionTitulo("Resultado"),
                      const Text("Revisa tus respuestas y presiona Evaluar para obtener el resultado final.", style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),

                      // resumen breve (puedes ampliarlo)
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
                              Navigator.of(context, rootNavigator: true).pushNamed('/signos');
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
