import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // se genera automáticamente con flutterfire configure

// 🔹 Importaciones de tus pantallas existentes
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/presion_screen.dart';
import 'screens/ritmo_screen.dart';
import 'screens/sueno_screen.dart';
import 'screens/oxigeno_screen.dart';
import 'screens/estres_screen.dart';
import 'screens/formulario_screen.dart';
import 'screens/bluetooth_test_screen.dart';

// 🔹 Importaciones del sistema de login
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/monitor_screen.dart'; // futura pantalla del revisor

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VitalAI',
      theme: AppTheme.lightTheme,

      // 🔹 Pantalla inicial: el login
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(), // ✅ agregado
        '/presion': (context) => const PresionScreen(),
        '/ritmo': (context) => const RitmoScreen(),
        '/sueno': (context) => const SuenoScreen(),
        '/oxigeno': (context) => const OxigenoScreen(),
        '/estres': (context) => const EstresScreen(),
        '/formulario': (context) => DonacionWizardScreen(),
        '/bluetooth_test': (context) => const BluetoothTestScreen(),
        '/monitor': (context) => const MonitorScreen(),
      },
    );
  }
}
