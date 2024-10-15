// lib/controller/interest_calculator.dart

import 'package:software_ingenieriaeconomica/controller/solicitudinsim_controller.dart';

class InterestCalculator {
  // Calcula el interés simple basado en el tipo de tasa y el tiempo
  double calculateSimpleInterest({
    required double principal,
    required double rate, // Tasa de interés en porcentaje
    required InterestType rateType,
    int timeInYears = 0,
    int timeInMonths = 0,
    int timeInDays = 0,
  }) {
    double timeInYearsTotal = 0.0;

    switch (rateType) {
      case InterestType.annual:
        // Tiempo total en años
        timeInYearsTotal = timeInYears + (timeInMonths / 12) + (timeInDays / 365);
        break;
      case InterestType.monthly:
        // Tiempo total en meses
        timeInYearsTotal = (timeInYears * 12) + timeInMonths + (timeInDays / 30);
        break;
      case InterestType.daily:
        // Tiempo total en días
        timeInYearsTotal = (timeInDays / 365) + timeInYears + (timeInMonths / 12);
        break;
      default:
        timeInYearsTotal = timeInYears + (timeInMonths / 12) + (timeInDays / 365);
    }

    // Ajustar el tiempo según el tipo de tasa
    double adjustedTime = 1.0; // Valor por defecto
    double adjustedRate = rate;

    switch (rateType) {
      case InterestType.annual:
        adjustedTime = timeInYearsTotal;
        break;
      case InterestType.monthly:
        adjustedTime = timeInYearsTotal / 12; // Convertir meses a años
        adjustedRate = rate * 12; // Convertir tasa mensual a anual
        break;
      case InterestType.daily:
        adjustedTime = timeInYearsTotal / 365; // Convertir días a años
        adjustedRate = rate * 365; // Convertir tasa diaria a anual
        break;
      default:
        adjustedTime = timeInYearsTotal;
    }

    double interest = (principal * adjustedRate * adjustedTime) / 100;
    return interest;
  }
}
