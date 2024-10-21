import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FrenchAmortizationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para calcular la cuota fija mensual
  double calculateFixedQuota({
    required double loanAmount,
    required double interestRate, // Tasa ingresada por el usuario
    required int loanTerm,
    required bool isAnnualRate, // Bandera para saber si la tasa es anual
  }) {
    // Si la tasa es anual, convertirla a mensual
    double monthlyRate = isAnnualRate ? (interestRate / 100) / 12 : interestRate / 100;

    // Calcular la cuota fija mensual usando la fórmula de amortización francesa
    return (loanAmount * monthlyRate) / (1 - pow(1 + monthlyRate, -loanTerm));
  }

  // Función para generar la tabla de amortización
  List<Map<String, dynamic>> generateAmortizationTable({
    required double loanAmount,
    required double interestRate, // Tasa ingresada por el usuario
    required int loanTerm,
    required bool isAnnualRate, // Bandera para saber si la tasa es anual
  }) {
    // Si la tasa es anual, convertirla a mensual
    double monthlyRate = isAnnualRate ? (interestRate / 100) / 12 : interestRate / 100;

    List<Map<String, dynamic>> amortizationTable = [];

    // Calcular la cuota fija mensual
    double fixedQuota = calculateFixedQuota(
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTerm: loanTerm,
      isAnnualRate: isAnnualRate,
    );

    double remainingBalance = loanAmount;

    for (int month = 1; month <= loanTerm; month++) {
      // Calcular intereses del mes
      double interest = remainingBalance * monthlyRate;

      // Calcular amortización del capital
      double principal = fixedQuota - interest;

      // Actualizar saldo restante
      remainingBalance -= principal;

      // Añadir los datos del mes a la tabla de amortización
      amortizationTable.add({
        'month': month,
        'quota': fixedQuota,
        'interest': interest,
        'principal': principal,
        'balance': remainingBalance > 0 ? remainingBalance : 0,
      });
    }

    return amortizationTable;
  }

  // Función para solicitar el préstamo y guardar los datos en Firestore
// Función para solicitar el préstamo y guardar los datos en Firestore
Future<void> requestFrenchLoan({
  required String cedula,
  required double loanAmount,
  required double rate,
  required int loanTerm,
  required String status,
  required bool isAnnualRate,
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

  // Generar la tabla de amortización francesa
  List<Map<String, dynamic>> amortizationTable = generateAmortizationTable(
    loanAmount: loanAmount,
    interestRate: rate,
    loanTerm: loanTerm,
    isAnnualRate: isAnnualRate,
  );

  // Calcular la fecha límite de pago (suponiendo plazo en meses)
  DateTime dueDate = DateTime.now().add(Duration(days: loanTerm * 30));

  // Guardar la solicitud en Firestore
  await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
    'cedula': cedula,
    'estado': status,
    'fecha_limite': Timestamp.fromDate(dueDate),
    'fecha_solicitud': Timestamp.now(),
    'monto': loanAmount,
    'num_cuotas': loanTerm,
    'tasa': rate,
    'tipo_prestamo': 'Amortización Francesa',
    'tipo_tasa': isAnnualRate ? 'Anual' : 'Mensual',
    'interes': amortizationTable.fold(0.0, (sum, item) => sum + item['interest']), // Sumar intereses
    'monto_por_cuota': amortizationTable[0]['quota'], // La cuota fija del primer mes
    'total_pago': amortizationTable.fold(0.0, (sum, item) => sum + item['quota']), // Sumar cuotas
  });

  // Guardar la tabla de amortización en Firestore
  await FirebaseFirestore.instance.collection('prestamos').add({
    'cedula': cedula,
    'tipo_prestamo': 'Amortización Francesa',
    'tabla_amortizacion': amortizationTable,
  });
}

}
