import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> loginUser() async {
    setState(() => loading = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        // Buscar info extra del usuario
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        if (doc.exists && doc['accesoMonitor'] == true) {
          // Tiene permiso, pedir contraseña exclusiva
          final passIngresada = await _pedirPasswordEspecial(context);
          if (passIngresada == doc['claveMonitor']) {
            Navigator.pushNamed(context, '/monitor');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Contraseña exclusiva incorrecta"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } else {
          // No tiene permiso al monitor → Pantalla normal
          Navigator.pushNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error al iniciar sesión")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<String?> _pedirPasswordEspecial(BuildContext context) async {
    String? password = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Contraseña exclusiva"),
          content: TextField(
            obscureText: true,
            onChanged: (value) => password = value,
            decoration:
                const InputDecoration(hintText: "Ingresa la clave del monitor"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, password),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : loginUser,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
