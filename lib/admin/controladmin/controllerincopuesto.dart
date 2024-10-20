import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importar para manejar fechas
import 'package:firebase_auth/firebase_auth.dart'; // Asegúrate de tener esto importado
import 'dart:math'; // Para usar pow

class CompoundInterestController {
  // Propiedades del controlador
  double _interest = 0.0;
  double _totalPayment = 0.0;
  double _futureValue = 0.0; // Monto compuesto
  int _numInstallments = 0;
  double _amountPerInstallment = 0.0; // Monto por cuota
  DateTime? _dueDate; // Fecha límite

  // Calcular interés compuesto
  void calculateInterest({
    required double principal,
    required double rate,
    required int years,
    required int months,
    required int days,
    required String capitalizationFrequency, // Frecuencia de capitalización
  }) {
    // Convertir el tiempo total a años
    double totalTime = years + (months / 12) + (days / 365);

    // Calcular tasa efectiva
    double effectiveRate = _convertRateToCapitalization(rate, capitalizationFrequency);
    int totalPeriods = _calculateTotalPeriods(totalTime, capitalizationFrequency);

    // Calcular el monto compuesto (valor futuro)
    _futureValue = principal * pow((1 + effectiveRate), totalPeriods);
    _interest = _futureValue - principal; // Interés acumulado

    // Calcular el número de cuotas y el monto por cuota
    _numInstallments = _calculateInstallments(totalTime);
    _amountPerInstallment = _calculateAmountPerInstallment(_futureValue, _numInstallments);

    // Calcular la fecha límite de pago
    _dueDate = _calculateDueDate(years, months, days);
  }

  // Convertir tasa de interés a la unidad de capitalización
  double _convertRateToCapitalization(double rate, String frequency) {
    switch (frequency) {
      case 'diario':
        return rate / 36500; // Tasa diaria
      case 'mensual':
        return rate / 1200; // Tasa mensual
      case 'trimestral':
        return rate / 400; // Tasa trimestral
      case 'cuatrimestral':
        return rate / 300; // Tasa cuatrimestral
      case 'semestral':
        return rate / 200; // Tasa semestral
      case 'anual':
      default:
        return rate / 100; // Tasa anual
    }
  }

  // Calcular total de períodos de capitalización
  int _calculateTotalPeriods(double totalTime, String frequency) {
    switch (frequency) {
      case 'diario':
        return (totalTime * 365).toInt();
      case 'mensual':
        return (totalTime * 12).toInt();
      case 'trimestral':
        return (totalTime * 4).toInt();
      case 'cuatrimestral':
        return (totalTime * 3).toInt();
      case 'semestral':
        return (totalTime * 2).toInt();
      case 'anual':
      default:
        return totalTime.toInt();
    }
  }

  // Calcular el número de cuotas
  int _calculateInstallments(double totalTime) {
    return (12 * totalTime).toInt(); // Cuotas mensuales
  }

  // Calcular monto por cuota
  double _calculateAmountPerInstallment(double totalPayment, int numInstallments) {
    return numInstallments == 0 ? 0.0 : totalPayment / numInstallments; // Evitar división por cero
  }

  // Calcular fecha límite de pago
  DateTime _calculateDueDate(int years, int months, int days) {
    DateTime now = DateTime.now();
    return DateTime(now.year + years, now.month + months, now.day + days);
  }

  // Solicitar préstamo
  Future<void> submitLoanRequest({
    required String cedula,
    required double monto,
    required double tasa,
    required String tipoTasa,
    required int years,
    required int months,
    required int days,
    required String frecuenciaCapitalizacion, // Nueva entrada para la frecuencia de capitalización
  }) async {
    User? user = FirebaseAuth.instance.currentUser; // Obtener usuario autenticado
    String? userCedula;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Asegúrate de que este sea el nombre de tu colección de usuarios
          .doc(user.uid) // Utiliza el ID del usuario para obtener su documento
          .get();

      if (userDoc.exists) {
        userCedula = userDoc.get('cedula'); // Asegúrate de que este sea el nombre correcto del campo
      }
    }

    // Verificar cédula
    if (cedula != userCedula) {
      throw Exception('La cédula no coincide con la del usuario autenticado.');
    }

    // Crear documento en Firestore
    await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
      'cedula': cedula,
      'monto': monto,
      'tasa': tasa,
      'tipo_tasa': tipoTasa,
      'estado': 'pendiente', // Guardar como pendiente
      'fecha_solicitud': Timestamp.now(), // Fecha actual
      'fecha_limite': _dueDate != null ? Timestamp.fromDate(_dueDate!) : null, // Guardar fecha límite
      'interes': _interest, // Guardar interés calculado
      'total_pago': _futureValue, // Guardar total a pagar (monto compuesto)
      'monto_por_cuota': _amountPerInstallment, // Guardar monto por cuota
      'num_cuotas': _numInstallments, // Guardar número de cuotas
      'tipo_prestamo': 'interes_compuesto', // Identificador para préstamos de interés compuesto
    });
  }

  // Métodos para obtener los resultados
  double get interest => _interest;
  double get totalPayment => _futureValue; // Usar el monto compuesto como total a pagar
  int get numInstallments => _numInstallments;
  double get amountPerInstallment => _amountPerInstallment; // Nuevo getter
  DateTime? get dueDate => _dueDate; // Nuevo getter para la fecha límite

  // Método para formatear números a estilo monetario
  String formatCurrency(double amount) {
    NumberFormat formatter = NumberFormat("#,##0.00", "es_ES"); // Establecer el formato en español
    return formatter.format(amount);
  }
}
