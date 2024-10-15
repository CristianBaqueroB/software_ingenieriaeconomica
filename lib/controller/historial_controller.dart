import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String tipoPrestamo; // Nuevo campo
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
    required this.tipoPrestamo, // Nuevo campo
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
      tipoPrestamo: data['tipoPrestamo'] ?? 'desconocido', // Nuevo campo
      fechaSolicitud: (data['fechaSolicitud'] as Timestamp).toDate(),
      fechaLimite: (data['fechaLimite'] as Timestamp).toDate(),
      anios: data['tiempo']['anios'] ?? 0,
      meses: data['tiempo']['meses'] ?? 0,
      dias: data['tiempo']['dias'] ?? 0,
    );
  }
}
