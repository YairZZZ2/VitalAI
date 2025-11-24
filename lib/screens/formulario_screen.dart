import 'package:flutter/material.dart';

class DonacionWizardScreen extends StatefulWidget {
  const DonacionWizardScreen({Key? key}) : super(key: key);

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
  final TextEditingController curpCtrl = TextEditingController();
  final TextEditingController edadCtrl = TextEditingController();
  final TextEditingController pesoCtrl = TextEditingController();
  final TextEditingController alturaCtrl = TextEditingController(); // <- altura añadida
  String sexo = "Masculino";
  final TextEditingController telefonoCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();

  // ---------- CONTROLLERS / FLAGS: CLÍNICA (tu formulario original) ----------
  final TextEditingController tratamientoController = TextEditingController();
  final TextEditingController oncologiaController = TextEditingController();

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
        !desayuno) {
      _mostrarResultadoDialog(false, "🚫 Lo sentimos mucho, pero usted no es apto/a para donar sangre debido a sus respuestas en el cuestionario.");
      setState(() => resultadoTexto = "No apto por cuestionario clínico.");
      return;
    }

    // Condición específica para mujeres
    if (sexo == "Femenino" && embarazadaOLactando) {
      _mostrarResultadoDialog(false, "🤰 Lo sentimos, pero no puedes donar si estás embarazada o en periodo de lactancia.");
      setState(() => resultadoTexto = "No apto por embarazo / lactancia.");
      return;
    }

    // Si pasa todas las validaciones:
    _mostrarResultadoDialog(true, "🎉 ¡Felicidades, eres apto/a para donar sangre! 🩸\n\nEn seguida colocaremos una banda en tu brazo para monitorear tus signos vitales mientras realizamos el proceso de donación. 🙏 Gracias por tu noble gesto.");
    setState(() => resultadoTexto = "Apto para donar.");
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
    curpCtrl.dispose();
    edadCtrl.dispose();
    pesoCtrl.dispose();
    alturaCtrl.dispose();
    telefonoCtrl.dispose();
    correoCtrl.dispose();
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
                      _campoTexto(curpCtrl, "CURP"),
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
                      _campoTexto(telefonoCtrl, "Teléfono", keyboard: TextInputType.phone),
                      _campoTexto(correoCtrl, "Correo electrónico", keyboard: TextInputType.emailAddress),

                      const SizedBox(height: 20),
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
                              if (nombresCtrl.text.trim().isEmpty || curpCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Completa al menos nombre y CURP para continuar.")));
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
                      _seccionTitulo("Cuestionario de salud"),
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
                            title: const Text("¿Estás en tratamiento médico o tomas alguna medicación?"),
                            value: tMedico,
                            onChanged: (v) {
                              setState(() {
                                tMedico = v;
                                if (!tMedico) tratamientoController.clear();
                              });
                            },
                          ),
                          if (tMedico) _campoTexto(tratamientoController, "¿Qué tipo de tratamiento o medicina tomas?"),
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
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text("¿Has padecido de algún proceso oncológico a lo largo de tu vida?"),
                            value: oncologia,
                            onChanged: (v) {
                              setState(() {
                                oncologia = v;
                                if (!oncologia) oncologiaController.clear();
                              });
                            },
                          ),
                          if (oncologia)
                            SwitchListTile(
                              title: const Text("El cáncer que tuviste, ¿fue un carcinoma in situ de cuello de útero o un carcinoma localizado de piel (basobascular/escamoso)? ¿Te han dado de alta?"),
                              value: carcinoma,
                              onChanged: (v) => setState(() => carcinoma = v),
                            ),
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
                                if (!drogas) tratamientoController.clear();
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
                              // reiniciar formulario si quieres
                              Navigator.pop(context);
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
