// lib/models/loan.dart
class Loan {
  final String id;
  final String estado;
  final DateTime fechaSolicitud;
  final DateTime fechaLimite;
  final double interes;
  final double montoPrestamo;
  final double totalAPagar;
  final String usuarioId;
  final double cantidadPagada;

  Loan({
    required this.id,
    required this.estado,
    required this.fechaSolicitud,
    required this.fechaLimite,
    required this.interes,
    required this.montoPrestamo,
    required this.totalAPagar,
    required this.usuarioId,
    required this.cantidadPagada,
  });

  factory Loan.fromDocument(Map<String, dynamic> data, String id) {
    return Loan(
      id: id,
      estado: data['estado'] ?? 'Sin estado',
      fechaSolicitud: (data['fechaSolicitud']?.toDate() ?? DateTime.now()),
      fechaLimite: (data['fechaLimite']?.toDate() ?? DateTime.now()),
      interes: data['interes']?.toDouble() ?? 0.0,
      montoPrestamo: data['montoPrestamo']?.toDouble() ?? 0.0,
      totalAPagar: data['totalAPagar']?.toDouble() ?? 0.0,
      usuarioId: data['usuarioId'] ?? 'Sin ID de usuario',
      cantidadPagada: (data['cantidadPagada'] is num) ? (data['cantidadPagada'] as num).toDouble() : 0.0,
    );
  }
}
