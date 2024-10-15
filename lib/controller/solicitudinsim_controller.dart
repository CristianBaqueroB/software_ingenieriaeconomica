// lib/controller/solicitudinsim_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/controller/interest_calculator.dart';

enum InterestType {
  annual, // Interés anual
  monthly, // Interés mensual
  daily, // Interés diario
}

class SimpleInterestController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeYearsController = TextEditingController();
  final TextEditingController timeMonthsController = TextEditingController();
  final TextEditingController timeDaysController = TextEditingController();

  String? nombre;
  String? apellido;
  String? correo;
  String? cedula;

  InterestType? selectedInterestType;

  double interest = 0.0;
  double totalPayment = 0.0;

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          var userData = userSnapshot.docs.first;

          nombre = userData['firstName'] ?? '';
          apellido = userData['lastName'] ?? '';
          correo = user.email ?? '';
          cedula = userData['cedula'];
          notifyListeners();
        } else {
          // Manejar el caso donde no se encuentra el usuario
          nombre = apellido = correo = cedula = null;
          notifyListeners();
        }
      } catch (e) {
        // Manejar el error
        nombre = apellido = correo = cedula = null;
        notifyListeners();
      }
    }
  }

  double calculateSimpleInterest() {
    double principal = double.tryParse(principalController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    int years = int.tryParse(timeYearsController.text) ?? 0;
    int months = int.tryParse(timeMonthsController.text) ?? 0;
    int days = int.tryParse(timeDaysController.text) ?? 0;

    InterestCalculator calculator = InterestCalculator();
    interest = calculator.calculateSimpleInterest(
      principal: principal,
      rate: rate,
      rateType: selectedInterestType ?? InterestType.annual, // Usar un valor por defecto si no está seleccionado
      timeInYears: years,
      timeInMonths: months,
      timeInDays: days,
    );

    totalPayment = principal + interest; // Calcular el total a pagar
    notifyListeners();
    return interest;
  }

  double getTotalPayment() {
    return totalPayment; // Retornar el total a pagar
  }

  Future<int> _getLoanCount(String userId) async {
    QuerySnapshot loanSnapshot = await _firestore
        .collection('loans')
        .where('usuarioId', isEqualTo: userId)
        .where('estado', isEqualTo: 'pendiente')
        .get();
    return loanSnapshot.docs.length; // Retornar la cantidad de préstamos pendientes
  }

  // Función para calcular la fecha límite
  DateTime calculateDeadlineDate(DateTime startDate, int years, int months, int days) {
    int newYear = startDate.year + years;
    int newMonth = startDate.month + months;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }

    int newDay = startDate.day + days;
    // Obtener el número de días en el nuevo mes
    int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    return DateTime(newYear, newMonth, newDay);
  }

  Future<void> solicitarPrestamo(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Verificar que todos los campos estén completos
        if (principalController.text.isEmpty || rateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, complete todos los campos de monto y tasa de interés.')),
          );
          return; // Salir de la función si hay campos vacíos
        }

        // Verificar cuántos préstamos tiene el usuario
        int loanCount = await _getLoanCount(user.uid);
        if (loanCount >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No puede solicitar más de 3 préstamos pendientes.')),
          );
          return; // Salir si ya tiene 3 préstamos
        }

        // Verificar que al menos uno de los campos de tiempo esté lleno
        bool isAnyTimeFieldFilled = timeYearsController.text.isNotEmpty ||
                                    timeMonthsController.text.isNotEmpty ||
                                    timeDaysController.text.isNotEmpty;

        if (!isAnyTimeFieldFilled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, debe llenar al menos un campo de tiempo (años, meses, días).')),
          );
          return; // Salir si no hay campos de tiempo llenos
        }

        // Datos del préstamo
        double principal = double.tryParse(principalController.text) ?? 0;
        double rate = double.tryParse(rateController.text) ?? 0;
        double interest = calculateSimpleInterest();
        double totalPayment = getTotalPayment();
        int years = int.tryParse(timeYearsController.text) ?? 0;
        int months = int.tryParse(timeMonthsController.text) ?? 0;
        int days = int.tryParse(timeDaysController.text) ?? 0;

        // Fecha de solicitud
        DateTime solicitudDate = DateTime.now();

        // Calcular fecha límite
        DateTime deadlineDate = calculateDeadlineDate(solicitudDate, years, months, days);

        // Crear el objeto de solicitud de préstamo
        Map<String, dynamic> loanData = {
          'usuarioId': user.uid,
          'montoPrestamo': principal,
          'interes': double.parse(interest.toStringAsFixed(2)), // Guardar con 2 decimales
          'tasaInteres': double.parse(rate.toStringAsFixed(2)), // Guardar la tasa de interés con 2 decimales
          'totalAPagar': double.parse(totalPayment.toStringAsFixed(2)), // Guardar con 2 decimales
          'estado': 'pendiente', // Estado inicial
          'fechaSolicitud': Timestamp.fromDate(solicitudDate),
          'fechaLimite': Timestamp.fromDate(deadlineDate),
          'tiempo': {
            // Solo guardar el campo que tenga valor
            if (years > 0) 'años': years,
            if (months > 0) 'meses': months,
            if (days > 0) 'días': days,
          },
        };

        // Guardar en Firestore
        await _firestore.collection('loans').add(loanData);

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitud de préstamo enviada con éxito')),
        );

        // Opcional: Limpiar los campos después de la solicitud
        principalController.clear();
        rateController.clear();
        timeYearsController.clear();
        timeMonthsController.clear();
        timeDaysController.clear();
        selectedInterestType = null;
        notifyListeners();
      } else {
        // Manejar el caso donde el usuario no está autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe iniciar sesión para solicitar un préstamo')),
        );
      }
    } catch (e) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al solicitar el préstamo: $e')),
      );
    }
  }
}
