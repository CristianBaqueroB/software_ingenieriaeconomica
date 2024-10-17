class Prestamo {
  final String id;
  final String cedula;
  final String estado;
  final DateTime fechaLimite;
  final DateTime fechaSolicitud;
  final double interes;
  final double monto;
  final double montoPorCuota;
  final int numCuotas;
  final double tasa;
  final String tipoTasa;
  final double totalPago;
  final String tipoprestamo;

  // Nueva propiedad que indica si el pago está atrasado
  bool get atrasado => DateTime.now().isAfter(fechaLimite);

  Prestamo({
    required this.id,
    required this.cedula,
    required this.estado,
    required this.fechaLimite,
    required this.fechaSolicitud,
    required this.interes,
    required this.monto,
    required this.montoPorCuota,
    required this.numCuotas,
    required this.tasa,
    required this.tipoTasa,
    required this.totalPago,
    required this.tipoprestamo,
  });

  factory Prestamo.fromDocument(Map<String, dynamic> data, String id) {
    return Prestamo(
      id: id,
      estado: data['estado'] ?? 'Sin estado',
      fechaSolicitud: (data['fecha_solicitud']?.toDate() ?? DateTime.now()),
      fechaLimite: (data['fecha_limite']?.toDate() ?? DateTime.now()),
      interes: _toDouble(data['interes']),
      monto: _toDouble(data['monto']),
      totalPago: _toDouble(data['total_pago']),
      cedula: data['cedula'] ?? 'Sin cédula',
      montoPorCuota: _toDouble(data['monto_por_cuota']),
      numCuotas: data['num_cuotas'] ?? 0,
      tasa: _toDouble(data['tasa']),
      tipoTasa: data['tipo_tasa'] ?? 'Desconocido',
      tipoprestamo: data['tipo_prestamo'] ?? 'Desconocido',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
