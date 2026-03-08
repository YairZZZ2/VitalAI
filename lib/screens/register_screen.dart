import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 NUEVO controlador para clave de revisor
  final TextEditingController _revisorPasswordController = TextEditingController();

  String _tipoUsuario = 'donante';
  bool _loading = false;
  String _error = '';

  // 🔹 Clave especial para revisores
  final String _claveRevisor = "REV123";

  Future<void> _register() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => _error = "Completa todos los campos.");
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    // 🔹 Validar clave de revisor
    if (_tipoUsuario == 'revisor') {
      if (_revisorPasswordController.text.trim() != _claveRevisor) {
        setState(() {
          _loading = false;
          _error = "Clave de revisor incorrecta.";
        });
        return;
      }
    }

    try {
      // 🔹 Crear usuario en Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 🔹 Crear documento en Firestore con el tipo de usuario
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'tipo': _tipoUsuario,
      });

      // 🔹 Redirigir al login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message ?? 'Error desconocido.';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro - VitalAI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Crear nueva cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Selección del tipo de usuario
              DropdownButtonFormField<String>(
                initialValue: _tipoUsuario,
                decoration: const InputDecoration(
                  labelText: 'Tipo de usuario',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'donante',
                    child: Text('Donante'),
                  ),
                  DropdownMenuItem(
                    value: 'revisor',
                    child: Text('Revisor'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoUsuario = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Campo que aparece SOLO si elige revisor
              if (_tipoUsuario == 'revisor') ...[
                TextField(
                  controller: _revisorPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Clave de autorización de revisor',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}