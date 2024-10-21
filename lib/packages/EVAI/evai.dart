import 'dart:math'; // Importar dart:math para usar pow
import 'package:flutter/material.dart';

class InvestmentEvaluationPage extends StatefulWidget {
  const InvestmentEvaluationPage({super.key});

  @override
  InvestmentEvaluationPageState createState() =>
      InvestmentEvaluationPageState();
}

class InvestmentEvaluationPageState extends State<InvestmentEvaluationPage> {
  final _initialInvestmentController = TextEditingController();
  final _cashFlowsController = TextEditingController();
  final _discountRateController = TextEditingController();
  double? _npv;
  double? _irr;
  double? _paybackPeriod;

  // Calcular Valor Presente Neto (VPN)
  double _calculateNPV(
      double initialInvestment, List<double> cashFlows, double discountRate) {
    double npv = -initialInvestment;
    for (int t = 0; t < cashFlows.length; t++) {
      npv += cashFlows[t] / pow(1 + discountRate, t + 1);
    }
    return npv;
  }

  // Calcular Tasa Interna de Retorno (TIR)
  double _calculateIRR(double initialInvestment, List<double> cashFlows) {
    double irr = 0.0;
    double increment = 0.0001; // Incremento para aproximar la TIR
    double npv;

    do {
      irr += increment;
      npv = -initialInvestment;
      for (int t = 0; t < cashFlows.length; t++) {
        npv += cashFlows[t] / pow(1 + irr, t + 1);
      }
    } while (npv > 0);

    return irr * 100; // Convertir a porcentaje
  }

  // Calcular Payback
  double _calculatePaybackPeriod(
      double initialInvestment, List<double> cashFlows) {
    double accumulatedCashFlow = 0.0;
    int year = 0;

    while (year < cashFlows.length && accumulatedCashFlow < initialInvestment) {
      accumulatedCashFlow += cashFlows[year];
      year++;
    }

    if (accumulatedCashFlow >= initialInvestment) {
      return year.toDouble(); // Periodo en que la inversión se recupera
    } else {
      return -1; // No se recupera la inversión
    }
  }

  void _evaluateInvestment() {
    final initialInvestment =
        double.tryParse(_initialInvestmentController.text);
    final cashFlows = _cashFlowsController.text
        .split(',')
        .map((cf) => double.tryParse(cf.trim()) ?? 0)
        .toList();
    final discountRate = double.tryParse(_discountRateController.text);

    if (initialInvestment != null &&
        cashFlows.isNotEmpty &&
        discountRate != null) {
      // Cálculos
      final npv =
          _calculateNPV(initialInvestment, cashFlows, discountRate / 100);
      final irr = _calculateIRR(initialInvestment, cashFlows);
      final payback = _calculatePaybackPeriod(initialInvestment, cashFlows);

      setState(() {
        _npv = npv;
        _irr = irr;
        _paybackPeriod = payback;
      });
    } else {
      setState(() {
        _npv = null;
        _irr = null;
        _paybackPeriod = null;
      });
    }
  }

  void _clearFields() {
    _initialInvestmentController.clear();
    _cashFlowsController.clear();
    _discountRateController.clear();
    setState(() {
      _npv = null;
      _irr = null;
      _paybackPeriod = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación de Alternativas de Inversión"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _initialInvestmentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Inversión Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cashFlowsController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Flujos de Efectivo (separados por comas)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _discountRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Descuento (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _evaluateInvestment,
                  child: const Text("Evaluar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_npv != null) ...[
              const SizedBox(height: 20),
              Text(
                "Valor Presente Neto (VPN): ${_npv!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
            if (_irr != null) ...[
              const SizedBox(height: 10),
              Text(
                "Tasa Interna de Retorno (TIR): ${_irr!.toStringAsFixed(2)} %",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
            if (_paybackPeriod != null) ...[
              const SizedBox(height: 10),
              Text(
                "Periodo de Recuperación (Payback): ${_paybackPeriod!.toStringAsFixed(2)} años",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
