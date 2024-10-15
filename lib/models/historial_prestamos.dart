// lib/screens/historial_solicitudes_prestamos.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/controller/historial_controller.dart';
import 'package:software_ingenieriaeconomica/controller/solicitudinsim_controller.dart';

class HistorialSolicitudesPrestamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el usuario logueado
    final user = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario está logueado
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mis Solicitudes de Préstamos'),
        ),
        body: Center(child: Text('Por favor, inicie sesión para ver sus solicitudes.')),
      );
    }

    // ID del usuario logueado
    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Solicitudes de Préstamos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('loans')
            .where('usuarioId', isEqualTo: userId) // Filtrar por usuarioId
            .orderBy('fechaSolicitud', descending: true) // Ordenar por fecha de solicitud
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay solicitudes de préstamos disponibles.'));
          }

          // Convertir documentos a objetos Prestamo
          final loans = snapshot.data!.docs.map((doc) => Prestamo.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];

              // Determinar el color del Card basado en el estado
              Color cardColor;
              switch (loan.estado.toLowerCase()) {
                case "pendiente":
                  cardColor = Colors.amber[100]!;
                  break;
                case "aceptado":
                  cardColor = Colors.green[100]!;
                  break;
                case "rechazado":
                  cardColor = Colors.red[100]!;
                  break;
                default:
                  cardColor = Colors.white; // Color por defecto
              }

              // Formatear fechas
              final DateFormat formatter = DateFormat('dd/MM/yyyy');
              String formattedSolicitud = formatter.format(loan.fechaSolicitud);
              String formattedLimite = formatter.format(loan.fechaLimite);

              return Card(
                margin: EdgeInsets.all(10), // Espaciado alrededor de cada Card
                elevation: 4, // Sombra del Card
                color: cardColor, // Color del Card según el estado
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Espaciado interno
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo de Préstamo: ${loan.tipoPrestamo}', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Monto del Préstamo: \$${formatNumber(loan.montoPrestamo)}'),
                      Text('Interés: \$${formatNumber(loan.interes)}'),
                      Text('Tasa de Interés: ${loan.tasaInteres}%'),
                      Text('Total a Pagar: \$${formatNumber(loan.totalAPagar)}'),
                      Text('Fecha de Solicitud: $formattedSolicitud'),
                      Text('Fecha Límite: $formattedLimite'),
                      Text('Estado: ${loan.estado}'),
                      Text('Tiempo: ${loan.anios} años, ${loan.meses} meses, ${loan.dias} días'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO');
    return formatter.format(number);
  }
}
