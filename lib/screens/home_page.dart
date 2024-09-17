import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:software_ingenieriaeconomica/screens/Cards/CalculationPage.dart';
import 'package:software_ingenieriaeconomica/screens/Cards/dashboard.dart';
import 'package:software_ingenieriaeconomica/services/SettingsPage.dart'; // Importa SettingsPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  Color _bgColor = Color.fromRGBO(228, 236, 228, 1);

  final List<Widget> _navigationItems = [
    Icon(Icons.dashboard),
    Icon(Icons.home),
    Icon(Icons.calculate),
    Icon(Icons.settings),
  ];

  final List<Color> _bgColors = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        items: _navigationItems,
        index: _selectedIndex,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _bgColor = _bgColors[index];
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage(); // Utiliza DashboardPage aquí
      case 1:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/img/Logo.png',
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenido a TuBank",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "TuBank es una aplicación que te ayuda a calcular distintos tipos de interés y gradientes financieros para tus necesidades de cálculo.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 14.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Calculadora de Intereses y Gradientes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Utiliza nuestras herramientas para calcular el interés simple, compuesto, y gradientes financieros.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return CalculationPage();
      case 3:
        return SettingsPage(); // Cambia a SettingsPage aquí
      default:
        return Center(child: Text("Página no encontrada", style: TextStyle(fontFamily: 'Roboto')));
    }
  }
}
