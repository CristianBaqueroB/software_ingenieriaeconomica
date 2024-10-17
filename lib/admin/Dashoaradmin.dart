import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/Gestionclientes.dart';

class DashboardPageAdmin extends StatelessWidget {
  const DashboardPageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Préstamos'),
      ),
      body: ListView(
        children: <Widget>[
          _CardItem(
            title: 'Resumen de Préstamos',
            onTap: () {
              // Acciones para la sección de resumen
            },
          ),
          _CardItem(
            title: 'Agregar Nuevo Préstamo',
            onTap: () {
              // Acciones para agregar un nuevo préstamo
            },
          ),
          _CardItem(
            title: 'Lista de Préstamos Activos',
            onTap: () {
              // Acciones para listar préstamos activos
            },
          ),
          _CardItem(
            title: 'Análisis de Préstamos',
            onTap: () {
              // Acciones para análisis de préstamos
            },
          ),
          _CardItem(
            title: 'Configuración de Tasas de Interés',
            onTap: () {
              // Acciones para configurar tasas
            },
          ),
          _CardItem(
            title: 'Historial de Pagos',
            onTap: () {
              // Acciones para mostrar historial de pagos
            },
          ),
          _CardItem(
            title: 'Gestión de Clientes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientManagementPage()), // Navegar a la gestión de clientes
              );
            },
          ),
          _CardItem(
            title: 'Notificaciones y Recordatorios',
            onTap: () {
              // Acciones para notificaciones
            },
          ),
          _CardItem(
            title: 'Reportes',
            onTap: () {
              // Acciones para generar reportes
            },
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _CardItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}


