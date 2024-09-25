import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:software_ingenieriaeconomica/screens/Cards/CalculationPage.dart';
import 'package:software_ingenieriaeconomica/screens/Cards/dashboard.dart';
import 'package:software_ingenieriaeconomica/screens/SolPrestamo.dart';
import 'package:software_ingenieriaeconomica/services/SettingsPage.dart'; 
//import 'package:software_ingenieriaeconomica/screens/admin/GestionUsuarios.dart'; // Página de gestión de usuarios
//import 'package:software_ingenieriaeconomica/screens/admin/GestionPrestamos.dart'; // Página de gestión de préstamos

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  Color _bgColor = Color.fromRGBO(228, 236, 228, 1);

  final List<Widget> _navigationItems = [
    Icon(Icons.dashboard),
    Icon(Icons.people),       // Gestión de usuarios
    Icon(Icons.request_page),  // Gestión de préstamos
    Icon(Icons.calculate),     // Cálculos financieros
    Icon(Icons.settings),      // Configuraciones
  ];

  final List<Color> _bgColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
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
        return DashboardPage();  // Página de dashboard
      case 1:
       // return GestionUsuariosPage();  // Página de gestión de usuarios
      case 2:
       // return GestionPrestamosPage();  // Página de gestión de préstamos
      case 3:
        return CalculationPage();  // Página de cálculos financieros
      case 4:
        return SettingsPage();  // Página de configuraciones
      default:
        return Center(child: Text("Página no encontrada", style: TextStyle(fontFamily: 'Roboto')));
    }
  }
}
