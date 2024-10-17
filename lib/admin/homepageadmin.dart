// lib/admin/admin_homepage.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:software_ingenieriaeconomica/admin/Dashoaradmin.dart';
import 'package:software_ingenieriaeconomica/admin/SettingsPageadmin.dart';
import 'package:software_ingenieriaeconomica/admin/vistaprestamos.dart';



class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  Color _bgColor = Colors.white;

  final List<Widget> _navigationItems = [
    Icon(Icons.dashboard, size: 30),       // Dashboard
    Icon(Icons.request_page, size: 30),    // Gestión de Préstamos
    Icon(Icons.settings, size: 30),        // Configuraciones
  ];

  final List<Color> _bgColors = [
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
        color: Color.fromARGB(255, 133, 238, 159), // Color de la barra de navegación
        buttonBackgroundColor: Color.fromARGB(255, 133, 238, 159),
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
        return DashboardPageAdmin ();  // Página de dashboard
      case 1:
        return GestionPrestamosPage();  // Página de gestión de préstamos
      case 2:
        return SettingsPageAdmin();  // Página de configuraciones
      default:
        return Center(
          child: Text(
            "Página no encontrada",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 18),
          ),
        );
    }
  }
}
