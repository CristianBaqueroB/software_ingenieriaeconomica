import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importar para manejar fechas
import 'package:firebase_auth/firebase_auth.dart'; // Asegúrate de tener esto importado

class SimpleInterestController {
  // Propiedades del controlador
  double _interest = 0.0;
  double _totalPayment = 0.0;
  int _numInstallments = 0;
  double _amountPerInstallment = 0.0; // Nueva propiedad
  DateTime? _dueDate; // Nueva propiedad para la fecha límite

  void calculateInterest({
    required double principal,
    required double rate,
    required int years,
    required int months,
    required int days,
  }) {
    // Convertir el tiempo total a años
    double totalTime = years + (months / 12) + (days / 365);
    
    // Calcular el interés simple
    _interest = principal * (rate / 100) * totalTime;
    _totalPayment = principal + _interest;

    // Calcular el número de cuotas y el monto por cuota
    _numInstallments = _calculateInstallments(totalTime);
    _amountPerInstallment = _calculateAmountPerInstallment(_totalPayment, _numInstallments);

    // Calcular la fecha límite de pago
    _dueDate = _calculateDueDate(years, months, days);
  }

  // Método privado para calcular las cuotas
  int _calculateInstallments(double totalTime) {
    // Suponiendo que quieres una cuota por cada mes del tiempo total
    return (12 * totalTime).toInt(); // 12 cuotas al año
  }

  // Método privado para calcular el monto por cuota
  double _calculateAmountPerInstallment(double totalPayment, int numInstallments) {
    if (numInstallments == 0) return 0.0; // Para evitar división por cero
    return totalPayment / numInstallments;
  }

  // Método privado para calcular la fecha límite de pago
  DateTime _calculateDueDate(int years, int months, int days) {
    // Obtener la fecha actual
    DateTime now = DateTime.now();
    // Calcular la fecha límite sumando el tiempo al actual
    return DateTime(now.year + years, now.month + months, now.day + days);
  }

 // Método para solicitar préstamo
Future<void> submitLoanRequest({
  required String cedula,
  required double monto,
  required double tasa,
  required String tipoTasa,
  required int years,
  required int months,
  required int days,
}) async {
  // Obtener la cédula del usuario autenticado
  User? user = FirebaseAuth.instance.currentUser; // Obtener el usuario autenticado
  String? userCedula;

  if (user != null) {
    // Buscar la cédula en Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // Asegúrate de que este sea el nombre de tu colección de usuarios
        .doc(user.uid) // Utiliza el ID del usuario para obtener su documento
        .get();

    if (userDoc.exists) {
      userCedula = userDoc.get('cedula'); // Asegúrate de que este sea el nombre correcto del campo
    }
  }

  // Verificar si la cédula proporcionada coincide con la cédula del usuario autenticado
  if (cedula != userCedula) {
    throw Exception('La cédula no coincide con la del usuario autenticado.');
  }

  // Crear un documento en Firestore para guardar la solicitud
  await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
    'cedula': cedula,
    'monto': monto,
    'tasa': tasa,
    'tipo_tasa': tipoTasa,
    'estado': 'pendiente', // Guardar como pendiente
    'fecha_solicitud': Timestamp.now(), // Fecha actual
    'fecha_limite': _dueDate != null ? Timestamp.fromDate(_dueDate!) : null, // Guardar fecha límite
    'interes': _interest, // Guardar interés calculado
    'total_pago': _totalPayment, // Guardar total a pagar
    'monto_por_cuota': _amountPerInstallment, // Guardar monto por cuota
    'num_cuotas': _numInstallments, // Guardar número de cuotas
    'tipo_prestamo': 'interes_simple', // Identificador para préstamos de interés simple
  });
}


  // Métodos para obtener los resultados
  double get interest => _interest;
  double get totalPayment => _totalPayment;
  int get numInstallments => _numInstallments;
  double get amountPerInstallment => _amountPerInstallment; // Nuevo getter
  DateTime? get dueDate => _dueDate; // Nuevo getter para la fecha límite

  // Método para formatear números a estilo monetario
  String formatCurrency(double amount) {
    NumberFormat formatter = NumberFormat("#,##0.00", "es_ES"); // Establecer el formato en español
    return formatter.format(amount);
  }
}
