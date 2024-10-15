import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Prestamo {
  final String id;
  final String usuarioId;
  final String cedula;
  final double montoPrestamo;
  final double interes;
  final double tasaInteres;
  final double totalAPagar;
  final DateTime fechaSolicitud;
  final DateTime fechaLimite;
  final String estado;
  final int anios;
  final int meses;
  final int dias;

  // Constructor
  Prestamo({
    required this.id,
    required this.usuarioId,
    required this.cedula,
    required this.montoPrestamo,
    required this.interes,
    required this.tasaInteres,
    required this.totalAPagar,
    required this.fechaSolicitud,
    required this.fechaLimite,
    required this.estado,
    required this.anios,
    required this.meses,
    required this.dias,
  });

  // Método para crear un objeto Prestamo desde Firestore
  factory Prestamo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Prestamo(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? '',
      cedula: data['cedula'] ?? '',
      montoPrestamo: data['montoPrestamo']?.toDouble() ?? 0.0,
      interes: data['interes']?.toDouble() ?? 0.0,
      tasaInteres: data['tasaInteres']?.toDouble() ?? 0.0,
      totalAPagar: data['totalAPagar']?.toDouble() ?? 0.0,
      estado: data['estado'] ?? '',
      fechaSolicitud: (data['fechaSolicitud'] as Timestamp).toDate(),
      fechaLimite: (data['fechaLimite'] as Timestamp).toDate(),
      anios: data['tiempo']['anios'] ?? 0,
      meses: data['tiempo']['meses'] ?? 0,
      dias: data['tiempo']['dias'] ?? 0,
    );
  }
}

// Función para obtener el usuario autenticado
String obtenerUsuarioId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? ""; // Devuelve el ID del usuario autenticado o una cadena vacía si no hay usuario autenticado
}

// Función para obtener préstamos filtrados por usuario autenticado
Future<List<Prestamo>> obtenerPrestamosPorUsuario() async {
  String usuarioId = obtenerUsuarioId(); // Obtiene el ID del usuario autenticado

  if (usuarioId.isEmpty) {
    return []; // Devuelve una lista vacía si no hay usuario autenticado
  }

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('loans')
      .where('usuarioId', isEqualTo: usuarioId)
      .orderBy('fechaSolicitud') // Eliminar 'ascending' porque se asume por defecto
      .get();

  return snapshot.docs.map((doc) => Prestamo.fromFirestore(doc)).toList();
}


