import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/Pagevienbenida.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/Paginadashboard.dart';

import 'package:software_ingenieriaeconomica/Users/prestamouser/SolicitudPrestamo.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/CalculationPage.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/dashboard.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/SettingsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  Color _bgColor = Color.fromRGBO(190, 233, 190, 1);

  final List<Widget> _navigationItems = [
    Icon(Icons.dashboard),
    Icon(Icons.account_balance),
     Icon(Icons.home),
    Icon(Icons.calculate),
    Icon(Icons.request_page),
  ];

  final List<Color> _bgColors = [
    Color.fromRGBO(253, 253, 253, 1),
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
        color: Color.fromARGB(255, 133, 238, 159),
        buttonBackgroundColor: Color.fromARGB(255, 133, 238, 159),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _bgColor = _bgColors[index];
          });
        },
      ),
      appBar: _selectedIndex == 2
          ? AppBar(
              title: Text('TuBank'),
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage();
      case 1:
        return SaldoPrestamoWidget();
      case 2:
        return  PaginaBienvenida();
      case 3:
        return CalculationPage();
      case 4:
        return SolicitudPrestamo();
      default:
        return Center(child: Text("Página no encontrada", style: TextStyle(fontFamily: 'Roboto')));
    }
  }
}
