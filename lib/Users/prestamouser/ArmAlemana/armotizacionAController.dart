import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanRequestController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double interest = 0.0; // Intereses totales
  double totalPayment = 0.0; // Pago total
  int numInstallments = 0; // Número de cuotas
  DateTime? dueDate; // Fecha límite de pago
  List<Map<String, dynamic>> amortizationTable = []; // Tabla de amortización

  // Calcular interés y otros valores
  void calculateInterest({
    required double principal,
    required double rate,
    required int years,
    required int months,
    required int days,
  }) {
    // Convertir el tiempo total a meses
    int totalMonths = (years * 12) + months;

    // Calcular la tasa de interés mensual
    double monthlyRate = rate / 100 / 12;

    // Calcular la amortización constante
    double constantAmortization = principal / totalMonths;

    // Generar tabla de amortización y calcular intereses totales y pago total
    _generateAmortizationTable(principal, monthlyRate, constantAmortization, totalMonths);
  }

  // Generar la tabla de amortización
  void _generateAmortizationTable(double principal, double monthlyRate, double constantAmortization, int installments) {
    double balance = principal;
    interest = 0.0;
    totalPayment = 0.0;

    amortizationTable = [];

    for (int i = 1; i <= installments; i++) {
      double interestPayment = balance * monthlyRate; // Intereses sobre el saldo
      double totalPaymentForInstallment = constantAmortization + interestPayment; // Cuota total
      balance -= constantAmortization; // Reducir saldo con amortización constante

      // Sumar al interés y pago total acumulados
      interest += interestPayment;
      totalPayment += totalPaymentForInstallment;

      amortizationTable.add({
        'month': i,
        'constant_amortization': constantAmortization,
        'interest': interestPayment,
        'total_payment': totalPaymentForInstallment,
        'balance': balance < 0 ? 0 : balance, // Asegura que el saldo no sea negativo
      });
    }
  }

  // Calcular la fecha límite de pago en base a la duración del préstamo
  DateTime _calculateDueDate(int years, int months, int days) {
    DateTime now = DateTime.now();
    return DateTime(now.year + years, now.month + months, now.day + days);
  }

  // Solicitud de préstamo
Future<void> requestLoan({
  required String cedula,
  required double loanAmount,
  required double rate,
  required int loanTerm,
  required String rateType,
  required String status,
  required String termType,
}) async {
  // Verificar si el usuario está autenticado
  User? user = _auth.currentUser;
  if (user == null) {
    throw Exception('Usuario no autenticado');
  }

  // Obtener los datos del usuario autenticado desde Firestore
  var snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (!snapshot.exists || snapshot.data()!['cedula'] != cedula) {
    throw Exception('La cédula ingresada no coincide con el usuario logueado.');
  }

  // Verificar el número de solicitudes pendientes o aceptadas
  var solicitudesSnapshot = await FirebaseFirestore.instance
      .collection('solicitudes_prestamo')
      .where('cedula', isEqualTo: cedula)
      .where('estado', whereIn: ['pendiente', 'aceptada'])
      .get();

  if (solicitudesSnapshot.docs.length >= 3) {
    throw Exception('No se puede enviar más solicitudes, ya tienes 3 solicitudes pendientes o aceptadas.');
  }

  // Si el plazo está en años, convertir a meses
  if (termType == 'años') loanTerm *= 12; // Convertir años a meses

  // Calcular los valores de interés
  calculateInterest(
    principal: loanAmount,
    rate: rate,
    years: loanTerm ~/ 12,
    months: loanTerm % 12,
    days: 0,
  );

  // Calcular la fecha límite en base a la duración del préstamo
  dueDate = _calculateDueDate(loanTerm ~/ 12, loanTerm % 12, 0);

  // Calcular monto por cuota
  double montoPorCuota = totalPayment / loanTerm;

  // Guardar la solicitud en Firestore con el total a pagar, intereses, monto por cuota y fecha límite
  await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
    'cedula': cedula,
    'estado': status,
    'fecha_limite': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    'fecha_solicitud': Timestamp.now(),
    'interes': interest, // Intereses totales calculados
    'monto': loanAmount,
    'num_cuotas': loanTerm,
    'tasa': rate, // Mantener tasa como se ingresó
    'tipo_prestamo': 'Amortización Alemana', // Cambiar según el tipo de préstamo
    'tipo_tasa': rateType == 'anual' ? 'Anual' : 'Mensual',
    'total_pago': totalPayment, // Total a pagar
    'monto_por_cuota': montoPorCuota, // Monto por cuota calculado
  });

  // Guardar la tabla de amortización en Firestore
  await FirebaseFirestore.instance.collection('prestamos').add({
    'cedula': cedula,
    'tipo_prestamo': 'Amortización Constante', // Cambiar según el tipo de préstamo
    'tabla_amortizacion': amortizationTable,
  });
}
}