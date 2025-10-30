import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPController = TextEditingController();
  final TextEditingController _apellidoMController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  String? _mensaje;

  void _validarFormulario() {
    if (_formKey.currentState!.validate()) {
      int edad = int.parse(_edadController.text);
      if (edad < 18 || edad > 65) {
        setState(() {
          _mensaje = "⚠️ Atención: la edad ingresada está fuera del rango permitido (18-65).";
        });
      } else {
        setState(() {
          _mensaje = "✅ Datos válidos. Nombre: ${_nombreController.text} ${_apellidoPController.text} ${_apellidoMController.text}, Edad: $edad";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingresa tu nombre" : null,
              ),
              const SizedBox(height: 15),

              // Apellido Paterno
              TextFormField(
                controller: _apellidoPController,
                decoration: const InputDecoration(
                  labelText: "Apellido Paterno",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Ingresa tu apellido paterno"
                    : null,
              ),
              const SizedBox(height: 15),

              // Apellido Materno
              TextFormField(
                controller: _apellidoMController,
                decoration: const InputDecoration(
                  labelText: "Apellido Materno",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Ingresa tu apellido materno"
                    : null,
              ),
              const SizedBox(height: 15),

              // Edad
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: "Edad",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingresa tu edad";
                  }
                  final edad = int.tryParse(value);
                  if (edad == null) {
                    return "La edad debe ser un número";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Botón
              ElevatedButton(
                onPressed: _validarFormulario,
                child: const Text("Validar"),
              ),

              const SizedBox(height: 20),

              // Mensaje resultado
              if (_mensaje != null)
                Text(
                  _mensaje!,
                  style: TextStyle(
                    color: _mensaje!.contains("⚠️") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
