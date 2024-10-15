import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/controller/historial_controller.dart'; // Asegúrate de agregar esta importación

class HistorialSolicitudesPrestamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('Por favor, inicie sesión para ver sus solicitudes.'));
    }

    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Solicitudes de Préstamos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('loans')
            .where('usuarioId', isEqualTo: userId)
            .orderBy('fechaSolicitud', descending: true)
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

          final loans = snapshot.data!.docs.map((doc) => Prestamo.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              String formattedDate = DateFormat('dd/MM/yyyy').format(loan.fechaSolicitud); // Formatear fecha

              return ListTile(
                title: Text('Monto del Préstamo: \$${loan.montoPrestamo}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha de Solicitud: $formattedDate'), // Usar fecha formateada
                    Text('Estado: ${loan.estado}'),
                    Text('Tasa de Interés: ${loan.tasaInteres}%'),
                    Text('Total a Pagar: \$${loan.totalAPagar}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
