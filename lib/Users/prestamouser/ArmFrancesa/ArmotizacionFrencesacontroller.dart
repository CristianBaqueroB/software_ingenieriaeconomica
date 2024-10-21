import 'dart:math';

class FrenchAmortizationController {
  // Función para calcular la cuota fija mensual, ajustando si la tasa es anual
  double calculateFixedQuota({
    required double loanAmount,
    required double interestRate, // Tasa ingresada por el usuario
    required int loanTerm,
    required bool isAnnualRate, // Bandera para saber si la tasa es anual
  }) {
    // Si la tasa es anual, convertirla a mensual
    double monthlyRate = isAnnualRate ? interestRate / 12 : interestRate;

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
    double monthlyRate = isAnnualRate ? interestRate / 12 : interestRate;

    List<Map<String, dynamic>> amortizationTable = [];
    
    // Calcular la cuota fija mensual con la tasa mensual ya ajustada
    double fixedQuota = calculateFixedQuota(
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTerm: loanTerm,
      isAnnualRate: isAnnualRate,
    );

    double remainingBalance = loanAmount;

    for (int month = 1; month  <= loanTerm; month++) {
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
}
