import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/services/AuthWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializar Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuBank',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false, // Ocultar el banner de depuración
      home: AuthWrapper(), // Usar AuthWrapper para manejar la autenticación
    );
  }
}
