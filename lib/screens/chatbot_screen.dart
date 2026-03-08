import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final int edad;
  final double peso;
  final double altura;
  final String resultado;
  final String motivo;

  const ChatbotScreen({
    super.key,
    required this.nombre,
    required this.apellidos,
    required this.edad,
    required this.peso,
    required this.altura,
    required this.resultado,
    required this.motivo,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Lista de mensajes del chat
  final List<Map<String, String>> _mensajes = [];

  void _enviarMensaje() {
    final texto = _inputController.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      // Agrega el mensaje del usuario
      _mensajes.add({"emisor": "usuario", "texto": texto});
      // Respuesta automática del bot
      _mensajes.add({
        "emisor": "bot",
        "texto": _respuestaBot(texto),
      });
    });

    _inputController.clear();

    // Scroll hacia el final
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Lógica básica de respuestas del bot
  String _respuestaBot(String mensaje) {
    mensaje = mensaje.toLowerCase();

    // 1. Saludos
    if (mensaje.contains("hola") || mensaje.contains("buenos") || mensaje.contains("buenas")) {
      return "¡Hola ${widget.nombre}! 😊 ¿Cómo te sientes hoy?";
    }

    // 2. Requisitos para donar
    if (mensaje.contains("requisitos") || mensaje.contains("donar") || mensaje.contains("elegibilidad")) {
      return "Para donar sangre debes tener entre 18 y 65 años, pesar entre 50 y 100 kg, estar en buen estado de salud y no haber donado en los últimos 4 meses. También evita alcohol, drogas y enfermedades recientes.";
    }

    // 3. Ansiedad o nervios
    if (mensaje.contains("nervioso") || mensaje.contains("ansioso") || mensaje.contains("miedo")) {
      return "Tranquilo 😌, es normal sentirse un poco nervioso. Respira profundo, relájate y recuerda que el proceso es seguro y rápido. ¡Tú puedes!";
    }

    // 4. Peso y altura
    if (mensaje.contains("peso")) {
      return "Tu peso registrado es de ${widget.peso} kg y tu altura ${widget.altura} m.";
    }

    // 5. Resultado de la evaluación
    if (mensaje.contains("resultado") || mensaje.contains("apto")) {
      return "Tu resultado es: ${widget.resultado}. Motivo: ${widget.motivo.isEmpty ? 'Ninguno, ¡estás apto!' : widget.motivo}";
    }

    // 6. Cuidar la salud antes de donar
    if (mensaje.contains("antes") && mensaje.contains("donar")) {
      return "Antes de donar es importante estar hidratado, haber desayunado y evitar alcohol las últimas 48 horas.";
    }

    // 7. Cómo sentirse después de donar
    if (mensaje.contains("despues") || mensaje.contains("posterior") && mensaje.contains("donar")) {
      return "Después de donar, descansa unos minutos, toma líquidos y evita esfuerzos físicos intensos. Tu cuerpo se recuperará rápidamente 💪.";
    }

    // 8. Preguntas sobre frecuencia
    if (mensaje.contains("cada cuanto") || mensaje.contains("frecuencia") || mensaje.contains("donar de nuevo")) {
      return "Se recomienda donar sangre completa cada 4 meses aproximadamente. Así tu cuerpo tiene tiempo de recuperarse totalmente.";
    }

    // 9. Preguntas sobre dolor
    if (mensaje.contains("duele") || mensaje.contains("dolor") || mensaje.contains("pinchazo")) {
      return "El proceso puede causar un pequeño pinchazo al insertar la aguja, pero es muy rápido y no debe doler más de unos segundos.";
    }

    // 10. Preguntas sobre alimentación
    if (mensaje.contains("comer") || mensaje.contains("desayuno") || mensaje.contains("alimentación")) {
      return "Come algo ligero y saludable antes de donar, como fruta, pan o cereales, y evita comidas pesadas o muy grasosas.";
    }

    // 11. Preguntas sobre bebidas
    if (mensaje.contains("agua") || mensaje.contains("liquido") || mensaje.contains("bebida")) {
      return "Mantente hidratado antes y después de donar. Agua, jugos naturales o bebidas isotónicas son perfectos.";
    }

    // 12. Preguntas sobre medicamentos
    if (mensaje.contains("medicamento") || mensaje.contains("pastilla") || mensaje.contains("droga")) {
      return "Algunos medicamentos pueden impedir donar. Si estás tomando algo, informa al personal de la clínica antes de donar.";
    }

    // 13. Preguntas sobre enfermedades
    if (mensaje.contains("enfermedad") || mensaje.contains("sida") || mensaje.contains("hepatitis") || mensaje.contains("covid")) {
      return "Si tienes alguna enfermedad reciente, infección o antecedente importante, es posible que no seas apto temporalmente. Es mejor consultar al personal médico.";
    }

    // 14. Preguntas sobre tatuajes/piercings
    if (mensaje.contains("tatuaje") || mensaje.contains("piercing") || mensaje.contains("dilatador")) {
      return "Si te hiciste un tatuaje o piercing recientemente, espera al menos 4 meses antes de donar para asegurar que tu sangre sea segura.";
    }

    // 15. Preguntas sobre embarazo o lactancia
    if (mensaje.contains("embarazo") || mensaje.contains("lactando") || mensaje.contains("lactancia")) {
      return "Durante el embarazo o lactancia no se recomienda donar sangre. Es importante proteger tu salud y la del bebé.";
    }

    // 16. Preguntas sobre emociones
    if (mensaje.contains("triste") || mensaje.contains("cansado") || mensaje.contains("estresado")) {
      return "Recuerda que donar también ayuda emocionalmente. Respira, piensa en lo bueno que haces por los demás y sonríe 😄.";
    }

    // 17. Preguntas sobre tips extra
    if (mensaje.contains("consejo") || mensaje.contains("tip") || mensaje.contains("sugerencia")) {
      return "Mi consejo: descansa bien la noche antes, hidrátate, desayuna y mantén una actitud positiva. ¡Todo saldrá bien!";
    }

    // 18. Pregunta sobre ansiedad antes de la extracción
    if (mensaje.contains("ansiedad") || mensaje.contains("preocupado")) {
      return "Intenta distraerte, respirar profundo y pensar en algo positivo. La mayoría de las personas sienten solo un pequeño pinchazo.";
    }

    // 19. Pregunta sobre cómo ayudar a otros
    if (mensaje.contains("ayudar") || mensaje.contains("salvar") || mensaje.contains("vidas")) {
      return "Cada donación puede salvar hasta 3 vidas. ¡Tu ayuda es invaluable! ❤️";
    }

    // 20. Pregunta divertida o curiosa
    if (mensaje.contains("curiosidad") || mensaje.contains("dato") || mensaje.contains("sabias")) {
      return "Sabías que el cuerpo repone la sangre donada en solo 24 a 48 horas? ¡Así que puedes sentirte genial rápidamente!";
    }

     // 21. Cómo se siente el usuario
    if (mensaje.contains("me siento mal") || mensaje.contains("no estoy bien") || mensaje.contains("me duele") || mensaje.contains("me siento enfermo")) {
      return "Lo siento 😟, si no te sientes bien es mejor que descanses y consultes con un médico antes de donar.";
    }
     
    if (mensaje.contains("me siento bien") || mensaje.contains("estoy bien") || mensaje.contains("me siento genial") || mensaje.contains("todo bien") || mensaje.contains("bien")) {
      return "¡Genial 😄! Si te sientes bien, estás en buena condición para donar. Recuerda hidratarte y mantener la calma.";
    }

    if (mensaje.contains("gracias")) {
      return "No hay de que, fue un placer haber sido de utilidad durante tu donación sanguinea, recuerda si tienes alguna otra duda estoy aquí para ayudarte.";
    }

    // Si el bot no entiende
    return "Lo siento 😅, no entendí eso. Puedes preguntarme sobre requisitos, resultados, cuidados antes/después de donar, o cómo mantener la calma.";
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (_, index) {
                final msg = _mensajes[index];
                final esUsuario = msg["emisor"] == "usuario";
                return Align(
                  alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: esUsuario ? Colors.purple[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["texto"]!),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _enviarMensaje,
                  child: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}