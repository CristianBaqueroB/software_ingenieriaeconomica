
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/historial_controller.dart';


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

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Solicitudes de Préstamos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Lógica para refrescar el historial, si es necesario
              // Puedes implementar una función para volver a cargar los datos
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: obtenerCedulaUsuarioLogueado(),
        builder: (context, snapshotCedula) {
          if (snapshotCedula.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshotCedula.hasError || !snapshotCedula.hasData) {
            return Center(child: Text('Error al obtener la cédula del usuario.'));
          }

          final cedulaUsuario = snapshotCedula.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('solicitudes_prestamo')
                .where('cedula', isEqualTo: cedulaUsuario) // Filtrar por cédula
                .orderBy('fecha_solicitud', descending: true) // Ordenar por fecha de solicitud
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
              final loans = snapshot.data!.docs.map((doc) {
                return Prestamo.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
              }).toList();

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
            Text('Tipo de Préstamo: ${loan.tipoprestamo}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Monto del Préstamo: \$${formatNumber(loan.monto)}'),
            Text('Interés: \$${formatNumber(loan.interes)}'),
            Text('Tasa de Interés: ${loan.tasa}%'),
            Text('Total a Pagar: \$${formatNumber(loan.totalPago)}'),
            Text('Fecha de Solicitud: $formattedSolicitud'),
            Text('Fecha Límite: $formattedLimite'),
            Text('Estado: ${loan.estado}'),

            // Mensaje de estado de pago
            Text(
              loan.atrasado ? 'El pago está atrasado.' : 'El pago está al día.',
              style: TextStyle(
                color: loan.atrasado ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  },
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

  // Método para obtener la cédula del usuario logueado desde Firestore
  Future<String> obtenerCedulaUsuarioLogueado() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      // Buscar el documento del usuario en Firestore
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(usuario.uid)
          .get();

      // Extraer la cédula del documento
      return usuarioDoc['cedula'] ?? 'Sin cédula';
    }

    return 'Sin cédula';
  }
}
