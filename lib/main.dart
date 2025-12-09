import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health/health.dart';

import 'firebase_options.dart';

// Pantallas
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/formulario_screen.dart';
import 'screens/bluetooth_test_screen.dart';
import 'screens/signos_screen.dart';
import 'screens/historial_screen.dart';

// Login
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/monitor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar Health (versión 10.2.0)
  final health = Health();

  // Tipos de datos a solicitar (solo los que NO necesitan Health Connect)
  final healthTypes = <HealthDataType>[
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
  ];

  // Revisar permisos
  final hasPerms = await health.hasPermissions(healthTypes) ?? false;

  // Pedir permisos solo si faltan
  if (!hasPerms) {
    await health.requestAuthorization(healthTypes);
  }

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

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/formulario': (context) => DonacionWizardScreen(),
        '/bluetooth_test': (context) => const BluetoothTestScreen(),
        '/monitor': (context) => const MonitorScreen(),
        '/signos': (context) => const SignosScreen(),
        '/historial': (context) => const HistorialScreen(),
      },
    );
  }
}
