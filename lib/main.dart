import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/presion_screen.dart';
import 'screens/ritmo_screen.dart';
import 'screens/sueno_screen.dart';
import 'screens/oxigeno_screen.dart';
import 'screens/estres_screen.dart';
import 'screens/formulario_screen.dart';
import 'screens/bluetooth_test_screen.dart';

void main() {
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
      initialRoute: '/bluetooth',
      routes: {
        '/': (context) => const HomeScreen(),
        '/presion': (context) => const PresionScreen(),
        '/ritmo': (context) => const RitmoScreen(),
        '/sueno': (context) => const SuenoScreen(),
        '/oxigeno': (context) => const OxigenoScreen(),
        '/estres': (context) => const EstresScreen(),
        '/formulario': (context) => const FormularioScreen(),
        '/bluetooth_test': (context) => const BluetoothTestScreen(),
      },
    );
  }
}
