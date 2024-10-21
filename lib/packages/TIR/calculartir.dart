import 'dart:math';
import 'package:flutter/material.dart';

class InterestRateReturnPage extends StatefulWidget {
  const InterestRateReturnPage({super.key});

  @override
  InterestRateReturnPageState createState() => InterestRateReturnPageState();
}

class InterestRateReturnPageState extends State<InterestRateReturnPage> {
  final _initialCapitalController = TextEditingController();
  final _yearsController = TextEditingController();
  final List<TextEditingController> _cashFlowControllers = [];
  double? _tir;

  @override
  void dispose() {
    _initialCapitalController.dispose();
    _yearsController.dispose();
    for (var controller in _cashFlowControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _calculateTIR(List<double> cashFlows, double initialInvestment) {
    double lowRate = 0.0; // Límite inferior
    double highRate = 1.0; // Límite superior
    double guessRate = 0;
    double npv;

    // Condición de iteración
    while ((highRate - lowRate).abs() > 0.00001) {
      guessRate = (lowRate + highRate) / 2;
      npv = _calculateNPV(cashFlows, initialInvestment, guessRate);

      if (npv > 0) {
        lowRate = guessRate;
      } else {
        highRate = guessRate;
      }
    }

    return guessRate * 100; // Retornar TIR como porcentaje
  }

  double _calculateNPV(
      List<double> cashFlows, double initialInvestment, double rate) {
    double npv = -initialInvestment;

    if (rate <= 0) {
      return npv; // Retornar inversión inicial negativa si el rate es inválido
    }

    for (int t = 0; t < cashFlows.length; t++) {
      npv += cashFlows[t] / pow(1 + rate, t + 1);
    }
    return npv;
  }

  void _onCalculateTIR() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final years = int.tryParse(_yearsController.text);

    if (initialCapital != null && years != null && years > 0) {
      List<double> cashFlows = _cashFlowControllers
          .map((controller) => double.tryParse(controller.text) ?? 0)
          .toList();

      final tir = _calculateTIR(cashFlows, initialCapital);

      setState(() {
        _tir = tir;
      });
    } else {
      setState(() {
        _tir = null;
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _yearsController.clear();
    _cashFlowControllers.forEach((controller) => controller.clear());
    setState(() {
      _tir = null;
    });
  }

  void _updateCashFlowFields(int years) {
    setState(() {
      _cashFlowControllers.clear();
      for (int i = 0; i < years; i++) {
        _cashFlowControllers.add(TextEditingController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Tasa Interna de Retorno (TIR)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Inversión Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yearsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Años',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final years = int.tryParse(value);
                if (years != null && years > 0) {
                  _updateCashFlowFields(years);
                }
              },
            ),
            const SizedBox(height: 20),
            if (_cashFlowControllers.isNotEmpty) ...[
              const Text(
                'Flujos de Caja Anuales:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              for (int i = 0; i < _cashFlowControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    controller: _cashFlowControllers[i],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Flujo de Caja Año ${i + 1}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _onCalculateTIR,
                  child: const Text("Calcular TIR"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle:
                        const TextStyle(fontSize: 18, fontFamily: 'Roboto'),
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
                    textStyle:
                        const TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
            if (_tir != null) ...[
              const SizedBox(height: 20),
              Text(
                "TIR: ${_tir!.toStringAsFixed(2)} %",
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
